//
//  ReportSightingViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 27.03.2026.
//

import UIKit
import CoreLocation
import PhotosUI

// MARK: - Request model

private struct SightingRequest: Encodable {
    let latitude: Double
    let longitude: Double
    let address: String
    let comment: String
    let imageUrls: [String]
}

// MARK: - ReportSightingViewController

final class ReportSightingViewController: UIViewController {

    // MARK: - Properties

    private let pet: Pet
    private var currentLocation: CLLocation?
    private var currentAddress: String = ""
    private let locationManager = CLLocationManager()
    private var selectedImage: UIImage?

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

    private let locationIconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "📍"
        label.font = .systemFont(ofSize: 24)
        return label
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
        button.layer.cornerRadius = 25
        return button
    }()

    private let photoPreviewImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .systemGray5
        iv.isHidden = true
        return iv
    }()

    private let removePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        button.isHidden = true
        return button
    }()

    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отправить репорт", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .systemBlue
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

    // MARK: - Init

    init(pet: Pet) {
        self.pet = pet
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

        locationCard.addSubview(locationIconLabel)
        locationCard.addSubview(locationTitleLabel)
        locationCard.addSubview(locationSubtitleLabel)
        locationCard.addSubview(changeLocationButton)

        sendButton.addSubview(activityIndicator)
        photoPreviewImageView.addSubview(removePhotoButton)

        [headerLabel, locationCard, commentTitleLabel, commentTextView,
         photoTitleLabel, addPhotoButton, photoPreviewImageView].forEach {
            contentView.addSubview($0)
        }
        view.addSubview(sendButton)

        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        changeLocationButton.addTarget(self, action: #selector(changeLocationTapped), for: .touchUpInside)
        addPhotoButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        removePhotoButton.addTarget(self, action: #selector(removePhotoTapped), for: .touchUpInside)

        let p: CGFloat = 20

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

            locationIconLabel.topAnchor.constraint(equalTo: locationCard.topAnchor, constant: 16),
            locationIconLabel.leadingAnchor.constraint(equalTo: locationCard.leadingAnchor, constant: 16),

            locationTitleLabel.topAnchor.constraint(equalTo: locationCard.topAnchor, constant: 14),
            locationTitleLabel.leadingAnchor.constraint(equalTo: locationIconLabel.trailingAnchor, constant: 12),
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

            photoPreviewImageView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 12),
            photoPreviewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: p),
            photoPreviewImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -p),
            photoPreviewImageView.heightAnchor.constraint(equalToConstant: 200),

            removePhotoButton.topAnchor.constraint(equalTo: photoPreviewImageView.topAnchor, constant: 8),
            removePhotoButton.trailingAnchor.constraint(equalTo: photoPreviewImageView.trailingAnchor, constant: -8),
            removePhotoButton.widthAnchor.constraint(equalToConstant: 32),
            removePhotoButton.heightAnchor.constraint(equalToConstant: 32),

            photoPreviewImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -p),

            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: p),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -p),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            sendButton.heightAnchor.constraint(equalToConstant: 56),

            activityIndicator.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor),
        ])
    }

    private func setupDelegates() {
        commentTextView.delegate = self
        locationManager.delegate = self
    }

    // MARK: - Location

    private func requestLocation() {
        if let saved = LocationService.shared.loadLocation() {
            currentAddress = saved.address
            currentLocation = CLLocation(latitude: saved.latitude, longitude: saved.longitude)
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
                    self.currentAddress = address.isEmpty ? "Текущее местоположение" : address
                    self.locationTitleLabel.text = self.currentAddress
                }
            }
        }
    }

    // MARK: - Actions

    @objc private func changeLocationTapped() {
        let picker = LocationPickerViewController(mode: .sighting, initialLocation: currentLocation)
        picker.delegate = self
        navigationController?.pushViewController(picker, animated: true)
    }

    @objc private func addPhotoTapped() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func removePhotoTapped() {
        selectedImage = nil
        photoPreviewImageView.image = nil
        photoPreviewImageView.isHidden = true
        removePhotoButton.isHidden = true
        addPhotoButton.setTitle("+ добавить фото", for: .normal)
    }

    @objc private func sendButtonTapped() {
        guard let location = currentLocation else {
            showError("Не удалось определить локацию. Попробуйте ещё раз.")
            return
        }

        let comment = commentTextView.textColor == .placeholderText ? "" : (commentTextView.text ?? "")

        sendButton.isEnabled = false
        sendButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()

        Task {
            do {
                var imageUrls: [String] = []
                if let image = selectedImage,
                   let jpeg = image.jpegData(compressionQuality: 0.8) {
                    let url = try await APIClient.shared.upload(imageData: jpeg, filename: "sighting_\(UUID().uuidString).jpg")
                    imageUrls.append(url)
                }

                let request = SightingRequest(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    address: currentAddress,
                    comment: comment,
                    imageUrls: imageUrls
                )

                struct SightingResponse: Decodable { let id: String }
                let _: SightingResponse = try await APIClient.shared.request(
                    "POST",
                    path: "/pets/\(pet.id)/sightings",
                    body: request
                )

                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                    self.showSuccess()
                }
            } catch {
                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                    self.sendButton.isEnabled = true
                    self.sendButton.setTitle("Отправить репорт", for: .normal)
                    self.showError("Не удалось отправить репорт. Попробуйте ещё раз.")
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
        guard let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self = self, let image = object as? UIImage else { return }
            DispatchQueue.main.async {
                self.selectedImage = image
                self.photoPreviewImageView.image = image
                self.photoPreviewImageView.isHidden = false
                self.removePhotoButton.isHidden = false
                self.addPhotoButton.setTitle("+ заменить фото", for: .normal)
            }
        }
    }
}

// MARK: - LocationPickerDelegate

extension ReportSightingViewController: LocationPickerDelegate {
    func didFinishPickingLocation(location: SavedLocation) {
        currentAddress = location.address.isEmpty ? "Выбранное место" : location.address
        currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        locationTitleLabel.text = currentAddress
    }
}

// MARK: - CLLocationManagerDelegate

extension ReportSightingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocation = location
        reverseGeocode(location: location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationTitleLabel.text = "Не удалось определить локацию"
        }
    }
}
