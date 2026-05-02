//
//  ReportSightingViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 27.03.2026.
//
import UIKit
import CoreLocation
import PhotosUI

// MARK: - ReportSightingViewController

final class ReportSightingViewController: UIViewController {

    // MARK: - ViewModel

    private let viewModel: ReportSightingViewModel

    // MARK: - Location (delegate-based, stays in VC)

    private let locationManager = CLLocationManager()

    // MARK: - UI

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Я видел этого питомца"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private let locationCard: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemGray6
        v.layer.cornerRadius = 16
        return v
    }()

    private let locationIconView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        iv.image = UIImage(systemName: "mappin.circle.fill", withConfiguration: config)?
            .withTintColor(.label, renderingMode: .alwaysOriginal)
        return iv
    }()

    private let locationTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Определяем вашу локацию..."
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()

    private let locationSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Будет отправлена как место наблюдения"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private let changeLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Изменить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        return button
    }()

    private let commentTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Комментарий (опционально)"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()

    private let commentTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = .systemFont(ofSize: 16)
        tv.backgroundColor = .systemGray6
        tv.layer.cornerRadius = 12
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        tv.text = ""
        tv.textColor = .placeholderText
        return tv
    }()

    private let photoTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Фото (опционально)"
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()

    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+ добавить фото", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()

    // Большое превью первого фото
    private let mainPhotoContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()

    private let mainPhotoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .systemGray5
        iv.isUserInteractionEnabled = true
        return iv
    }()

    private let mainPhotoRemoveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        btn.layer.cornerRadius = 14
        return btn
    }()

    // Горизонтальная карусель для доп. фото
    private let extraPhotosScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsHorizontalScrollIndicator = false
        sv.isHidden = true
        return sv
    }()

    private let extraPhotosStack: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .fill
        return sv
    }()

    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отправить репорт", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .accent
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .white
        ai.hidesWhenStopped = true
        return ai
    }()

    // Нижний якорь contentView — меняется в зависимости от наличия фото
    private var contentBottomConstraint: NSLayoutConstraint!

    // MARK: - Init

    init(pet: Pet) {
        self.viewModel = ReportSightingViewModel(pet: pet)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Репорт о питомце"

        setupUI()
        setupDelegates()
        requestLocation()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        locationCard.addSubview(locationIconView)
        locationCard.addSubview(locationTitleLabel)
        locationCard.addSubview(locationSubtitleLabel)
        locationCard.addSubview(changeLocationButton)

        sendButton.addSubview(activityIndicator)

        mainPhotoContainer.addSubview(mainPhotoImageView)
        mainPhotoContainer.addSubview(mainPhotoRemoveButton)

        extraPhotosScrollView.addSubview(extraPhotosStack)

        [headerLabel, locationCard, commentTitleLabel, commentTextView,
         photoTitleLabel, addPhotoButton, mainPhotoContainer, extraPhotosScrollView].forEach {
            contentView.addSubview($0)
        }
        view.addSubview(sendButton)

        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        changeLocationButton.addTarget(self, action: #selector(changeLocationTapped), for: .touchUpInside)
        addPhotoButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        mainPhotoRemoveButton.addTarget(self, action: #selector(removeMainPhotoTapped), for: .touchUpInside)

        let p: CGFloat = 20

        // Нижний якорь contentView — по умолчанию прибит к кнопке добавить фото
        contentBottomConstraint = addPhotoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -p)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -16),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: p),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: p),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -p),

            locationCard.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            locationCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: p),
            locationCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -p),

            locationIconView.topAnchor.constraint(equalTo: locationCard.topAnchor, constant: 16),
            locationIconView.leadingAnchor.constraint(equalTo: locationCard.leadingAnchor, constant: 16),
            locationIconView.widthAnchor.constraint(equalToConstant: 24),
            locationIconView.heightAnchor.constraint(equalToConstant: 24),

            locationTitleLabel.topAnchor.constraint(equalTo: locationCard.topAnchor, constant: 14),
            locationTitleLabel.leadingAnchor.constraint(equalTo: locationIconView.trailingAnchor, constant: 12),
            locationTitleLabel.trailingAnchor.constraint(equalTo: changeLocationButton.leadingAnchor, constant: -8),

            locationSubtitleLabel.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor, constant: 4),
            locationSubtitleLabel.leadingAnchor.constraint(equalTo: locationTitleLabel.leadingAnchor),
            locationSubtitleLabel.trailingAnchor.constraint(equalTo: locationTitleLabel.trailingAnchor),
            locationSubtitleLabel.bottomAnchor.constraint(equalTo: locationCard.bottomAnchor, constant: -16),

            changeLocationButton.centerYAnchor.constraint(equalTo: locationCard.centerYAnchor),
            changeLocationButton.trailingAnchor.constraint(equalTo: locationCard.trailingAnchor, constant: -16),

            commentTitleLabel.topAnchor.constraint(equalTo: locationCard.bottomAnchor, constant: 28),
            commentTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: p),

            commentTextView.topAnchor.constraint(equalTo: commentTitleLabel.bottomAnchor, constant: 8),
            commentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: p),
            commentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -p),
            commentTextView.heightAnchor.constraint(equalToConstant: 120),

            photoTitleLabel.topAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: 28),
            photoTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: p),

            addPhotoButton.topAnchor.constraint(equalTo: photoTitleLabel.bottomAnchor, constant: 8),
            addPhotoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: p),
            addPhotoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -p),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 50),

            // Большое превью
            mainPhotoContainer.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 12),
            mainPhotoContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: p),
            mainPhotoContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -p),
            mainPhotoContainer.heightAnchor.constraint(equalToConstant: 200),

            mainPhotoImageView.topAnchor.constraint(equalTo: mainPhotoContainer.topAnchor),
            mainPhotoImageView.leadingAnchor.constraint(equalTo: mainPhotoContainer.leadingAnchor),
            mainPhotoImageView.trailingAnchor.constraint(equalTo: mainPhotoContainer.trailingAnchor),
            mainPhotoImageView.bottomAnchor.constraint(equalTo: mainPhotoContainer.bottomAnchor),

            mainPhotoRemoveButton.topAnchor.constraint(equalTo: mainPhotoContainer.topAnchor, constant: 8),
            mainPhotoRemoveButton.trailingAnchor.constraint(equalTo: mainPhotoContainer.trailingAnchor, constant: -8),
            mainPhotoRemoveButton.widthAnchor.constraint(equalToConstant: 28),
            mainPhotoRemoveButton.heightAnchor.constraint(equalToConstant: 28),

            // Карусель доп. фото
            extraPhotosScrollView.topAnchor.constraint(equalTo: mainPhotoContainer.bottomAnchor, constant: 8),
            extraPhotosScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: p),
            extraPhotosScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -p),
            extraPhotosScrollView.heightAnchor.constraint(equalToConstant: 80),

            extraPhotosStack.topAnchor.constraint(equalTo: extraPhotosScrollView.topAnchor),
            extraPhotosStack.bottomAnchor.constraint(equalTo: extraPhotosScrollView.bottomAnchor),
            extraPhotosStack.leadingAnchor.constraint(equalTo: extraPhotosScrollView.leadingAnchor),
            extraPhotosStack.trailingAnchor.constraint(equalTo: extraPhotosScrollView.trailingAnchor),
            extraPhotosStack.heightAnchor.constraint(equalTo: extraPhotosScrollView.heightAnchor),

            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: p),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -p),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            sendButton.heightAnchor.constraint(equalToConstant: 56),

            activityIndicator.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor),

            contentBottomConstraint,
        ])
    }

    private func setupDelegates() {
        commentTextView.delegate = self
        locationManager.delegate = self
    }

    // MARK: - Location

    private func requestLocation() {
        if let saved = LocationService.shared.loadLocation() {
            viewModel.currentAddress = saved.address
            viewModel.currentLocation = CLLocation(latitude: saved.latitude, longitude: saved.longitude)
            locationTitleLabel.text = saved.address
            return
        }

        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    private func reverseGeocode(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let placemark = placemarks?.first {
                let address = [placemark.thoroughfare, placemark.subThoroughfare, placemark.locality]
                    .compactMap { $0 }
                    .joined(separator: ", ")
                DispatchQueue.main.async {
                    let resolved = address.isEmpty ? "Текущее местоположение" : address
                    self.viewModel.currentAddress = resolved
                    self.locationTitleLabel.text = resolved
                }
            }
        }
    }

    // MARK: - Photo UI updates

    private func updatePhotoUI() {
        let images = viewModel.selectedImages
        let count = images.count

        contentBottomConstraint.isActive = false

        if count == 0 {
            mainPhotoContainer.isHidden = true
            extraPhotosScrollView.isHidden = true
            addPhotoButton.setTitle("+ добавить фото", for: .normal)
            contentBottomConstraint = addPhotoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        } else {
            // Показываем первое фото как обложку
            mainPhotoContainer.isHidden = false
            mainPhotoImageView.image = images[0]

            if count > 1 {
                // Дополнительные фото в карусели
                extraPhotosScrollView.isHidden = false
                rebuildExtraPhotos(Array(images.dropFirst()))
                contentBottomConstraint = extraPhotosScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            } else {
                extraPhotosScrollView.isHidden = true
                contentBottomConstraint = mainPhotoContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            }

            let title = count < 5 ? "+ добавить ещё фото (\(count)/5)" : "Максимум 5 фото"
            addPhotoButton.setTitle(title, for: .normal)
        }

        contentBottomConstraint.isActive = true
        view.layoutIfNeeded()
    }

    private func rebuildExtraPhotos(_ images: [UIImage]) {
        extraPhotosStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, image) in images.enumerated() {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            container.widthAnchor.constraint(equalToConstant: 80).isActive = true

            let iv = UIImageView(image: image)
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.layer.cornerRadius = 8
            iv.isUserInteractionEnabled = true

            let xBtn = UIButton(type: .system)
            xBtn.translatesAutoresizingMaskIntoConstraints = false
            xBtn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            xBtn.tintColor = .white
            xBtn.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            xBtn.layer.cornerRadius = 10
            xBtn.tag = index + 1 // +1 потому что доп. фото начинаются с индекса 1
            xBtn.addTarget(self, action: #selector(removeExtraPhotoTapped(_:)), for: .touchUpInside)

            container.addSubview(iv)
            container.addSubview(xBtn)

            NSLayoutConstraint.activate([
                iv.topAnchor.constraint(equalTo: container.topAnchor),
                iv.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                iv.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                iv.bottomAnchor.constraint(equalTo: container.bottomAnchor),

                xBtn.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
                xBtn.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4),
                xBtn.widthAnchor.constraint(equalToConstant: 20),
                xBtn.heightAnchor.constraint(equalToConstant: 20),
            ])

            extraPhotosStack.addArrangedSubview(container)
        }
    }

    // MARK: - Actions

    @objc private func changeLocationTapped() {
        let picker = LocationPickerViewController(mode: .sighting, initialLocation: viewModel.currentLocation)
        picker.delegate = self
        navigationController?.pushViewController(picker, animated: true)
    }

    @objc private func addPhotoTapped() {
        guard viewModel.selectedImages.count < 5 else { return }
        var config = PHPickerConfiguration()
        config.selectionLimit = 5 - viewModel.selectedImages.count
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func removeMainPhotoTapped() {
        viewModel.selectedImages.removeFirst()
        updatePhotoUI()
    }

    @objc private func removeExtraPhotoTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index < viewModel.selectedImages.count else { return }
        viewModel.selectedImages.remove(at: index)
        updatePhotoUI()
    }

    @objc private func sendButtonTapped() {
        viewModel.comment = commentTextView.textColor == .placeholderText ? "" : (commentTextView.text ?? "")

        sendButton.isEnabled = false
        sendButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()

        Task {
            await viewModel.submit()
            self.activityIndicator.stopAnimating()
            if viewModel.didSubmit {
                self.showSuccess()
            } else {
                self.sendButton.isEnabled = true
                self.sendButton.setTitle("Отправить репорт", for: .normal)
                if let msg = viewModel.errorMessage {
                    self.showError(msg)
                }
            }
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Helpers

    private func showSuccess() {
        let alert = UIAlertController(
            title: "Спасибо! 🙏",
            message: "Репорт отправлен. Владелец питомца будет уведомлён.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate

extension ReportSightingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Например: видел сегодня утром возле подъезда..."
            textView.textColor = .placeholderText
        }
    }
}

// MARK: - PHPickerViewControllerDelegate

extension ReportSightingViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else { return }

        let group = DispatchGroup()
        var newImages: [UIImage] = []

        for result in results {
            guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else { continue }
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                if let image = object as? UIImage {
                    newImages.append(image)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            let remaining = 5 - self.viewModel.selectedImages.count
            self.viewModel.selectedImages.append(contentsOf: newImages.prefix(remaining))
            self.updatePhotoUI()
        }
    }
}

// MARK: - LocationPickerDelegate

extension ReportSightingViewController: LocationPickerDelegate {
    func didFinishPickingLocation(location: SavedLocation) {
        let address = location.address.isEmpty ? "Выбранное место" : location.address
        viewModel.currentAddress = address
        viewModel.currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        locationTitleLabel.text = address
    }
}

// MARK: - CLLocationManagerDelegate

extension ReportSightingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        viewModel.currentLocation = location
        reverseGeocode(location: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationTitleLabel.text = "Не удалось определить локацию"
        }
    }
}
