//
//  PetDetailViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 04.09.2025.
//

import UIKit
import YandexMapsMobile
import Kingfisher
import Combine

final class PetDetailViewController: UIViewController {

    // MARK: - Properties

    private var pet: Pet
    private let viewModel: PetDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    private var hasAppeared = false

    // MARK: - UI Elements

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Carousel

    private let carouselScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.layer.cornerRadius = 24
        sv.clipsToBounds = true
        sv.backgroundColor = .systemGray5
        return sv
    }()

    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.45)
        pc.hidesForSinglePage = true
        pc.isUserInteractionEnabled = false
        return pc
    }()

    private var carouselImageViews: [UIImageView] = []

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()

    private let ownerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray4
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()

    private let externalSignsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()

    private let ageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = .darkGray
        return label
    }()

    private let lostDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = .darkGray
        return label
    }()

    private let locationTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

    private let detailsStack: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 12
        return sv
    }()

    private let mapView: YMKMapView = {
        let map = YMKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.layer.cornerRadius = 16
        map.clipsToBounds = true
        map.mapWindow?.map.isZoomGesturesEnabled = false
        map.mapWindow?.map.isScrollGesturesEnabled = false
        map.mapWindow?.map.isRotateGesturesEnabled = false
        return map
    }()

    private let callButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 200/255, green: 220/255, blue: 255/255, alpha: 1.0)
        button.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 20
        return button
    }()

    private let chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 200/255, green: 220/255, blue: 255/255, alpha: 1.0)
        button.setImage(UIImage(systemName: "message.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 20
        return button
    }()

    private let reportButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 200/255, green: 220/255, blue: 255/255, alpha: 1.0)
        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 20
        return button
    }()

    private var sightings: [Sighting] = []

    private var scrollViewBottomConstraint: NSLayoutConstraint?

    private var isSubscribed: Bool = false {
        didSet { updateSubscribeButton() }
    }

    // MARK: - Initialization

    init(pet: Pet) {
        self.pet = pet
        self.viewModel = PetDetailViewModel(pet: pet)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupUI()
        configureData()
        bindViewModel()

        if !viewModel.isOwner {
            fetchSubscriptionStatus()
        }

        fetchSightings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if hasAppeared {
            refreshPet()
        }
        hasAppeared = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateMapCamera()
    }

    private func refreshPet() {
        Task {
            do {
                let updated: Pet = try await APIClient.shared.request("GET", path: "/pets/\(pet.id)")
                await MainActor.run {
                    self.pet = updated
                    self.configureData()
                }
            } catch {
            }
        }
        fetchSightings()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label

        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareButtonTapped)
        )

        if viewModel.isOwner {
            let editMenu = UIMenu(title: "", children: [
                UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { [weak self] _ in
                    self?.editButtonTapped()
                },
                UIAction(title: "Удалить анкету", image: UIImage(systemName: "trash"),
                         attributes: .destructive) { [weak self] _ in
                    self?.deletePetTapped()
                }
            ])
            let editButton = UIBarButtonItem(
                image: UIImage(systemName: "pencil"),
                menu: editMenu
            )

            let foundButton = UIBarButtonItem(
                image: UIImage(systemName: "checkmark.circle"),
                style: .plain,
                target: self,
                action: #selector(markAsFoundTapped)
            )
            foundButton.tintColor = .systemGreen

            navigationItem.rightBarButtonItems = [foundButton, editButton, shareButton]
        } else {
            let heartButton = UIBarButtonItem(
                image: UIImage(systemName: "heart"),
                style: .plain,
                target: self,
                action: #selector(subscribeButtonTapped)
            )
            heartButton.tag = 42   // чтобы найти кнопку для обновления иконки
            heartButton.tintColor = .systemPink
            navigationItem.rightBarButtonItems = [heartButton, shareButton]
        }
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(carouselScrollView)
        contentView.addSubview(pageControl)
        carouselScrollView.delegate = self

        [descriptionLabel, externalSignsLabel, ageLabel, lostDateLabel].forEach(detailsStack.addArrangedSubview)
        [titleLabel, nameLabel, ownerImageView, detailsStack, locationTitleLabel, mapView].forEach(contentView.addSubview)

        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        mapView.addGestureRecognizer(mapTapGesture)
        mapView.isUserInteractionEnabled = true

        let padding: CGFloat = 16

        let scrollBottom: NSLayoutYAxisAnchor
        if viewModel.isOwner {
            let sightingsBtn = makeSightingsButton()
            view.addSubview(sightingsBtn)
            NSLayoutConstraint.activate([
                sightingsBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                sightingsBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
                sightingsBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                sightingsBtn.heightAnchor.constraint(equalToConstant: 52)
            ])
            scrollBottom = sightingsBtn.topAnchor

            NotificationCenter.default.addObserver(self, selector: #selector(onSightingStatusChanged),
                                                   name: .sightingStatusChanged, object: nil)
        } else {
            [callButton, reportButton].forEach(view.addSubview)
            callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
            reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)

            NSLayoutConstraint.activate([
                callButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
                callButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                callButton.heightAnchor.constraint(equalToConstant: 60),

                reportButton.leadingAnchor.constraint(equalTo: callButton.trailingAnchor, constant: 8),
                reportButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
                reportButton.bottomAnchor.constraint(equalTo: callButton.bottomAnchor),
                reportButton.heightAnchor.constraint(equalTo: callButton.heightAnchor),
                reportButton.widthAnchor.constraint(equalTo: callButton.widthAnchor)
            ])
            scrollBottom = callButton.topAnchor
        }

        let scrollBottomConstraint = scrollView.bottomAnchor.constraint(
            equalTo: scrollBottom, constant: viewModel.isOwner ? 0 : -padding
        )
        self.scrollViewBottomConstraint = scrollBottomConstraint

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollBottomConstraint,

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            carouselScrollView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            carouselScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            carouselScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            carouselScrollView.heightAnchor.constraint(equalTo: carouselScrollView.widthAnchor, multiplier: 0.8),

            pageControl.bottomAnchor.constraint(equalTo: carouselScrollView.bottomAnchor, constant: -8),
            pageControl.centerXAnchor.constraint(equalTo: carouselScrollView.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: carouselScrollView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),

            ownerImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            ownerImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: padding),
            ownerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ownerImageView.widthAnchor.constraint(equalToConstant: 50),
            ownerImageView.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: ownerImageView.leadingAnchor, constant: -padding),

            detailsStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            detailsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            detailsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            locationTitleLabel.topAnchor.constraint(equalTo: detailsStack.bottomAnchor, constant: 24),
            locationTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            locationTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            mapView.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor, constant: padding),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            mapView.heightAnchor.constraint(equalToConstant: 200),
            mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }

    private func setupCarousel() {
        carouselImageViews.forEach { $0.removeFromSuperview() }
        carouselImageViews = []

        let urls = pet.imageUrls.compactMap { URL(string: $0) }
        pageControl.numberOfPages = urls.count

        for (i, url) in urls.enumerated() {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.tag = i
            iv.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
            carouselScrollView.addSubview(iv)
            carouselImageViews.append(iv)
        }

        if urls.isEmpty {
            let iv = UIImageView(image: UIImage(systemName: "photo"))
            iv.contentMode = .scaleAspectFit
            iv.tintColor = .systemGray3
            iv.tag = 0
            carouselScrollView.addSubview(iv)
            carouselImageViews.append(iv)
            pageControl.numberOfPages = 1
        }

        view.layoutIfNeeded()
        layoutCarouselSlides()
    }

    private func layoutCarouselSlides() {
        let w = carouselScrollView.bounds.width
        let h = carouselScrollView.bounds.height
        guard w > 0 else { return }

        for (i, iv) in carouselImageViews.enumerated() {
            iv.frame = CGRect(x: CGFloat(i) * w, y: 0, width: w, height: h)
        }
        carouselScrollView.contentSize = CGSize(
            width: w * CGFloat(carouselImageViews.count),
            height: h
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutCarouselSlides()
    }

    private func configureData() {
        setupCarousel()

        ownerImageView.image = UIImage(systemName: "person.circle")

        titleLabel.text = pet.breed
        nameLabel.text = "Кличка: \(pet.name)"

        let desc = pet.description.trimmingCharacters(in: .whitespacesAndNewlines)
        descriptionLabel.isHidden = desc.isEmpty
        descriptionLabel.text = desc

        if let signs = pet.externalSigns, !signs.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            externalSignsLabel.isHidden = false
            externalSignsLabel.text = "Внешние признаки: \(signs)"
        } else {
            externalSignsLabel.isHidden = true
        }

        if let age = pet.age, age > 0 {
            ageLabel.isHidden = false
            ageLabel.text = "Возраст: \(ageString(age))"
        } else {
            ageLabel.isHidden = true
        }

        if let lostDate = pet.lostDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM yyyy"
            formatter.locale = Locale(identifier: "ru_RU")
            lostDateLabel.isHidden = false
            lostDateLabel.text = "Пропал: \(formatter.string(from: lostDate))"
        } else {
            lostDateLabel.isHidden = true
        }

        locationTitleLabel.text = "📍 \(pet.location)"

        updateMapMarkers()
    }

    // MARK: - Sightings

    private func fetchSightings() {
        Task {
            do {
                let result: [Sighting] = try await APIClient.shared.request(
                    "GET", path: "/pets/\(pet.id)/sightings"
                )
                await MainActor.run {
                    self.sightings = result
                    self.updateMapMarkers()
                    if self.hasAppeared {
                        self.updateMapCamera()
                    }
                    if self.viewModel.isOwner {
                        self.updateSightingsButton()
                    }
                }
            } catch {
            }
        }
    }

    private func updateMapMarkers() {
        guard let map = mapView.mapWindow?.map else { return }
        map.mapObjects.clear()

        if let lat = pet.latitude, let lon = pet.longitude {
            let point = YMKPoint(latitude: lat, longitude: lon)
            let petPin = map.mapObjects.addPlacemark()
            petPin.geometry = point
            if let icon = makePinImage(systemName: "pawprint.fill", color: .label, size: 28) {
                petPin.setIconWith(icon)
            }
        }

        let visibleSightings = viewModel.isOwner
            ? sightings
            : sightings.filter { $0.status == "confirmed" }

        for sighting in visibleSightings {
            let point = YMKPoint(latitude: sighting.latitude, longitude: sighting.longitude)
            let marker = map.mapObjects.addPlacemark()
            marker.geometry = point

            let isConfirmed = sighting.status == "confirmed"
            let color: UIColor = isConfirmed ? .systemGreen : .systemOrange
            let icon = isConfirmed ? "checkmark.circle.fill" : "eye.fill"
            if let img = makePinImage(systemName: icon, color: color, size: 22) {
                marker.setIconWith(img)
            }

            if isConfirmed, let lat = pet.latitude, let lon = pet.longitude {
                let petPoint = YMKPoint(latitude: lat, longitude: lon)
                let polyline = map.mapObjects.addPolyline(with: YMKPolyline(points: [petPoint, point]))
                polyline.strokeWidth = 2.5
                polyline.dashLength = 8
                polyline.gapLength = 6
            }
        }
    }

    private func updateMapCamera() {
        guard let map = mapView.mapWindow?.map else { return }

        var points: [YMKPoint] = []
        if let lat = pet.latitude, let lon = pet.longitude {
            points.append(YMKPoint(latitude: lat, longitude: lon))
        }
        let confirmedSightings = sightings.filter { $0.status == "confirmed" }
        for s in confirmedSightings {
            points.append(YMKPoint(latitude: s.latitude, longitude: s.longitude))
        }

        if points.count >= 2 {
            let lats = points.map { $0.latitude }
            let lons = points.map { $0.longitude }
            let minLat = lats.min()!, maxLat = lats.max()!
            let minLon = lons.min()!, maxLon = lons.max()!
            let pad = max(maxLat - minLat, maxLon - minLon) * 0.4 + 0.003
            let sw = YMKPoint(latitude: minLat - pad, longitude: minLon - pad)
            let ne = YMKPoint(latitude: maxLat + pad, longitude: maxLon + pad)
            let bbox = YMKBoundingBox(southWest: sw, northEast: ne)
            let cameraPos = map.cameraPosition(with: YMKGeometry(boundingBox: bbox))
            map.move(with: cameraPos)
        } else if let first = points.first {
            map.move(with: YMKCameraPosition(target: first, zoom: 14, azimuth: 0, tilt: 0))
        }
    }

    private func makePinImage(systemName: String, color: UIColor, size: CGFloat) -> UIImage? {
        let padding: CGFloat = 6
        let total = size + padding * 2
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: total, height: total))
        return renderer.image { ctx in
            UIColor.white.setFill()
            let circle = UIBezierPath(ovalIn: CGRect(x: 1, y: 1, width: total - 2, height: total - 2))
            ctx.cgContext.setShadow(offset: CGSize(width: 0, height: 1), blur: 3,
                                   color: UIColor.black.withAlphaComponent(0.35).cgColor)
            circle.fill()
            ctx.cgContext.setShadow(offset: .zero, blur: 0, color: nil)

            let config = UIImage.SymbolConfiguration(pointSize: size * 0.55, weight: .semibold)
            if let symbol = UIImage(systemName: systemName, withConfiguration: config)?
                .withTintColor(color, renderingMode: .alwaysOriginal) {
                let iconSize = symbol.size
                let origin = CGPoint(
                    x: (total - iconSize.width) / 2,
                    y: (total - iconSize.height) / 2
                )
                symbol.draw(at: origin)
            }
        }
    }

    // MARK: - Bindings

    private func bindViewModel() {
    }

    // MARK: - Alert Helpers

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Actions

    @objc private func markAsFoundTapped() {
        let alert = UIAlertController(
            title: "Питомец нашёлся?",
            message: "Объявление будет снято с поиска, но вся история находок и переписки сохранится.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.closePetCard()
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }

    private func closePetCard() {
        Task {
            do {
                struct StatusUpdate: Encodable { let status: String }
                let _: EmptyResponse = try await APIClient.shared.request(
                    "PATCH",
                    path: "/pets/\(pet.id)/status",
                    body: StatusUpdate(status: "found")
                )
                await MainActor.run {
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                await MainActor.run {
                    self.showErrorAlert(message: "Не удалось закрыть анкету")
                }
            }
        }
    }

    @objc private func deletePetTapped() {
        let alert = UIAlertController(
            title: "Удалить анкету?",
            message: "Фотографии, история находок и вся переписка по этому питомцу будут удалены безвозвратно.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Удалить навсегда", style: .destructive) { [weak self] _ in
            self?.performDeletePet()
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }

    private func performDeletePet() {
        Task {
            do {
                let _: EmptyResponse = try await APIClient.shared.request(
                    "DELETE",
                    path: "/pets/\(pet.id)"
                )
                await MainActor.run {
                    self.navigationController?.popViewController(animated: true)
                }
            } catch {
                await MainActor.run {
                    self.showErrorAlert(message: "Не удалось удалить анкету")
                }
            }
        }
    }

    private func editButtonTapped() {
        let vm = AddEditPetViewModel(petToEdit: self.pet)
        let vc = AddEditViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func mapTapped() {
        guard let lat = pet.latitude, let lon = pet.longitude else {
            showErrorAlert(message: "Координаты не указаны.")
            return
        }

        guard let yandexMapsURL = URL(string: "yandexmaps://maps.yandex.ru/?pt=\(lon),\(lat)&z=15") else { return }
        guard let yandexMapsWebURL = URL(string: "https://yandex.ru/maps/?pt=\(lon),\(lat)&z=15") else { return }

        if UIApplication.shared.canOpenURL(yandexMapsURL) {
            UIApplication.shared.open(yandexMapsURL)
        } else {
            UIApplication.shared.open(yandexMapsWebURL)
        }
    }

    @objc private func shareButtonTapped() {
        if viewModel.isOwner {
            showPosterFormatPicker()
        } else {
            var itemsToShare: [Any] = [viewModel.shareText]
            if let imageURL = viewModel.shareImageURL {
                itemsToShare.append(imageURL)
            }
            let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            present(activityVC, animated: true)
        }
    }

    private func showPosterFormatPicker() {
        let sheet = UIAlertController(title: "Создать постер", message: "Выберите формат", preferredStyle: .actionSheet)

        for format in PosterFormat.allCases {
            sheet.addAction(UIAlertAction(title: format.rawValue, style: .default) { [weak self] _ in
                self?.generateAndSharePoster(format: format)
            })
        }
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel))

        if let popover = sheet.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItems?.last
        }
        present(sheet, animated: true)
    }

    private func generateAndSharePoster(format: PosterFormat) {
        let firstPhoto: UIImage? = (carouselScrollView.subviews.first as? UIImageView)?.image

        let poster = PetPosterGenerator.generate(pet: pet, photo: firstPhoto, format: format)
        let activityVC = UIActivityViewController(activityItems: [poster], applicationActivities: nil)
        if let popover = activityVC.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItems?.last
        }
        present(activityVC, animated: true)
    }

    // MARK: - Subscription

    private func fetchSubscriptionStatus() {
        Task {
            do {
                struct SubResp: Decodable { let subscribed: Bool }
                let resp: SubResp = try await APIClient.shared.request(
                    "GET", path: "/pets/\(pet.id)/subscribed"
                )
                await MainActor.run { self.isSubscribed = resp.subscribed }
            } catch {
            }
        }
    }

    private func updateSubscribeButton() {
        let imageName = isSubscribed ? "heart.fill" : "heart"
        let newItem = UIBarButtonItem(
            image: UIImage(systemName: imageName),
            style: .plain,
            target: self,
            action: #selector(subscribeButtonTapped)
        )
        newItem.tintColor = .systemPink
        if var items = navigationItem.rightBarButtonItems, items.count >= 2 {
            items[0] = newItem
            navigationItem.rightBarButtonItems = items
        }
    }

    @objc private func subscribeButtonTapped() {
        let method = isSubscribed ? "DELETE" : "POST"
        let nextState = !isSubscribed

        Task {
            do {
                struct SubResp: Decodable { let subscribed: Bool }
                let resp: SubResp = try await APIClient.shared.request(
                    method, path: "/pets/\(pet.id)/subscribe"
                )
                await MainActor.run {
                    self.isSubscribed = resp.subscribed
                    let msg = resp.subscribed
                        ? "Вы будете получать уведомления о новых отметках"
                        : "Подписка отменена"
                    let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            } catch {
                await MainActor.run {
                    self.isSubscribed = !nextState   // откат
                    self.showErrorAlert(message: "Не удалось изменить подписку")
                }
            }
        }
    }

    @objc private func callButtonTapped() {
        guard let phoneNumber = pet.contactPhone, !phoneNumber.isEmpty else {
            showErrorAlert(message: "Номер телефона не указан")
            return
        }

        let cleanedPhone = phoneNumber.filter { $0.isNumber }
        guard let phoneURL = URL(string: "tel://\(cleanedPhone)") else { return }

        if UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL)
        }
    }

    @objc private func reportButtonTapped() {
        let reportVC = ReportSightingViewController(pet: pet)
        navigationController?.pushViewController(reportVC, animated: true)
    }

    @objc private func chatButtonTapped() {
        guard let ownerId = pet.ownerId else {
            showErrorAlert(message: "Не удалось определить владельца")
            return
        }

        let chatVC = ChatViewController(pet: pet, recipientId: ownerId)
        navigationController?.pushViewController(chatVC, animated: true)
    }

    // MARK: - Sightings Button (owner only)

    private func makeSightingsButton() -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = "Наблюдения"
        config.image = UIImage(systemName: "eye.fill")
        config.imagePadding = 8
        config.baseBackgroundColor = .systemBlue
        config.cornerStyle = .large
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = 99  // чтобы найти и обновить заголовок
        btn.addTarget(self, action: #selector(sightingsTapped), for: .touchUpInside)
        return btn
    }

    private func updateSightingsButton() {
        guard let btn = view.viewWithTag(99) as? UIButton else { return }
        let count = sightings.count
        let pending = sightings.filter { $0.status == "pending" }.count
        var config = btn.configuration ?? UIButton.Configuration.filled()
        if count == 0 {
            config.title = "Наблюдения"
        } else if pending > 0 {
            config.title = "Наблюдения (\(count)) · \(pending) новых"
        } else {
            config.title = "Наблюдения (\(count))"
        }
        btn.configuration = config
    }

    @objc private func sightingsTapped() {
        let listVC = SightingsListViewController(sightings: sightings, pet: pet)
        navigationController?.pushViewController(listVC, animated: true)
    }

    @objc private func onSightingStatusChanged() {
        fetchSightings()
    }
}

// MARK: - Helpers

private func ageString(_ age: Int) -> String {
    let mod100 = age % 100
    let mod10  = age % 10
    if mod100 >= 11 && mod100 <= 14 { return "\(age) лет" }
    switch mod10 {
    case 1:          return "\(age) год"
    case 2, 3, 4:   return "\(age) года"
    default:         return "\(age) лет"
    }
}

// MARK: - UIScrollViewDelegate (carousel page tracking)

extension PetDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === carouselScrollView else { return }
        let w = carouselScrollView.bounds.width
        guard w > 0 else { return }
        let page = Int((carouselScrollView.contentOffset.x + w / 2) / w)
        pageControl.currentPage = max(0, min(page, carouselImageViews.count - 1))
    }
}
