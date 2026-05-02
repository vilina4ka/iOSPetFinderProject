//
//  SightingDetailViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 28.03.2026.
//
import UIKit
import YandexMapsMobile
import Kingfisher

final class SightingDetailViewController: UIViewController {

    // MARK: - Properties

    private var sighting: Sighting
    private let pet: Pet
    private let isOwner: Bool

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

    private let photoScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.layer.cornerRadius = 16
        sv.clipsToBounds = true
        sv.backgroundColor = .systemGray5
        return sv
    }()

    private let reporterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private lazy var mapView: YMKMapView = {
        let mv = YMKMapView(frame: .zero)!
        mv.translatesAutoresizingMaskIntoConstraints = false
        mv.layer.cornerRadius = 16
        mv.clipsToBounds = true
        mv.mapWindow.map.isZoomGesturesEnabled   = false
        mv.mapWindow.map.isScrollGesturesEnabled = false
        mv.mapWindow.map.isRotateGesturesEnabled = false
        return mv
    }()

    private lazy var chatButton: UIButton = makeActionButton(icon: "message.fill", color: .accent)
    private lazy var confirmButton: UIButton = makeActionButton(icon: "checkmark.circle.fill", color: .systemGreen)
    private lazy var rejectButton: UIButton = makeActionButton(icon: "xmark.circle.fill", color: .systemRed)

    // MARK: - Init

    init(sighting: Sighting, pet: Pet, isOwner: Bool) {
        self.sighting = sighting
        self.pet = pet
        self.isOwner = isOwner
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Наблюдение"
        view.backgroundColor = .systemBackground
        setupLayout()
        configure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateMapCamera()
    }

    // MARK: - Setup

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        let padding: CGFloat = 16

        let buttonStack = UIStackView(arrangedSubviews: [chatButton, confirmButton, rejectButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 12
        buttonStack.alignment = .fill

        var arrangedViews: [UIView] = [photoScrollView, reporterLabel, addressLabel, commentLabel, mapView]
        if isOwner {
            arrangedViews.append(buttonStack)
        }

        let stack = UIStackView(arrangedSubviews: arrangedViews)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),

            photoScrollView.heightAnchor.constraint(equalToConstant: sighting.imageUrls.isEmpty ? 0 : 220),
            mapView.heightAnchor.constraint(equalToConstant: 220),

            buttonStack.heightAnchor.constraint(equalToConstant: 56),
        ])

        chatButton.addTarget(self, action: #selector(chatTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        rejectButton.addTarget(self, action: #selector(rejectTapped), for: .touchUpInside)

        addMapOverlayButtons()
    }

    private func configure() {
        let urls = sighting.imageUrls.compactMap { URL(string: $0) }
        let w = view.bounds.width - 32
        for (i, url) in urls.enumerated() {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.frame = CGRect(x: CGFloat(i) * w, y: 0, width: w, height: 220)
            iv.kf.setImage(with: url)
            photoScrollView.addSubview(iv)
        }
        photoScrollView.contentSize = CGSize(width: w * CGFloat(urls.count), height: 220)
        photoScrollView.isHidden = urls.isEmpty

        let dateStr = sighting.createdAt.map { formatDate($0) } ?? ""
        reporterLabel.text = "Нашёл: \(sighting.reporterName.isEmpty ? "Аноним" : sighting.reporterName) · \(dateStr)"
        addressLabel.setLocationText(sighting.address)
        commentLabel.text = sighting.comment.isEmpty ? nil : sighting.comment
        commentLabel.isHidden = sighting.comment.isEmpty

        updateMapMarkers()

        if isOwner {
            updateButtonStates()
        }
    }

    // MARK: - Map helpers (shared between embedded and full-screen)

    private func setupMarkersOnMap(_ map: YMKMap) {
        map.mapObjects.clear()

        let sightingPoint = YMKPoint(latitude: sighting.latitude, longitude: sighting.longitude)

        let isConfirmed = sighting.status == "confirmed"
        let eyeColor: UIColor = isConfirmed ? .systemGreen : .systemOrange
        let sightingMark = map.mapObjects.addPlacemark()
        sightingMark.geometry = sightingPoint
        sightingMark.setIconWith(
            UIImage(systemName: isConfirmed ? "checkmark.circle.fill" : "eye.circle.fill")?
                .withTintColor(eyeColor, renderingMode: .alwaysOriginal) ?? UIImage()
        )

        if isConfirmed, let lat = pet.latitude, let lon = pet.longitude {
            let petPoint = YMKPoint(latitude: lat, longitude: lon)
            let petMark = map.mapObjects.addPlacemark()
            petMark.geometry = petPoint
            petMark.setIconWith(
                UIImage(systemName: "pawprint.circle.fill")?
                    .withTintColor(.accent, renderingMode: .alwaysOriginal) ?? UIImage()
            )
            let polyline = map.mapObjects.addPolyline(with: YMKPolyline(points: [petPoint, sightingPoint]))
            let style = polyline.style
            style.strokeWidth = 2.5
            style.dashLength = 8
            style.gapLength = 6
        }
    }

    private func setupCameraOnMap(_ map: YMKMap) {
        let sightingPoint = YMKPoint(latitude: sighting.latitude, longitude: sighting.longitude)

        if sighting.status == "confirmed", let lat = pet.latitude, let lon = pet.longitude {
            let minLat = min(lat, sighting.latitude)
            let maxLat = max(lat, sighting.latitude)
            let minLon = min(lon, sighting.longitude)
            let maxLon = max(lon, sighting.longitude)
            let pad = max(maxLat - minLat, maxLon - minLon) * 0.4 + 0.002
            let sw = YMKPoint(latitude: minLat - pad, longitude: minLon - pad)
            let ne = YMKPoint(latitude: maxLat + pad, longitude: maxLon + pad)
            let bbox = YMKBoundingBox(southWest: sw, northEast: ne)
            let cameraPos = mapView.mapWindow.map.cameraPosition(with: YMKGeometry(boundingBox: bbox))
            map.move(with: cameraPos)
        } else {
            map.move(with: YMKCameraPosition(target: sightingPoint, zoom: 15, azimuth: 0, tilt: 0))
        }
    }

    private func updateMapMarkers() { setupMarkersOnMap(mapView.mapWindow.map) }
    private func updateMapCamera()  { setupCameraOnMap(mapView.mapWindow.map) }

    private func updateMap() {
        updateMapMarkers()
        updateMapCamera()
    }

    // MARK: - Map overlay buttons

    private func addMapOverlayButtons() {
        let expandBtn  = makeSmallMapBtn(icon: "arrow.up.left.and.arrow.down.right")
        let zoomInBtn  = makeSmallMapBtn(icon: "plus")
        let zoomOutBtn = makeSmallMapBtn(icon: "minus")
        let mapsBtn    = makeSmallMapBtn(icon: "arrow.triangle.turn.up.right.circle.fill")

        expandBtn.addTarget (self, action: #selector(expandMapTapped),  for: .touchUpInside)
        zoomInBtn.addTarget (self, action: #selector(mapZoomInTapped),  for: .touchUpInside)
        zoomOutBtn.addTarget(self, action: #selector(mapZoomOutTapped), for: .touchUpInside)
        mapsBtn.addTarget   (self, action: #selector(openInMapsTapped), for: .touchUpInside)

        [expandBtn, zoomInBtn, zoomOutBtn, mapsBtn].forEach { mapView.addSubview($0) }

        let s: CGFloat = 34
        NSLayoutConstraint.activate([
            expandBtn.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 8),
            expandBtn.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -8),
            expandBtn.widthAnchor.constraint(equalToConstant: s),
            expandBtn.heightAnchor.constraint(equalToConstant: s),

            zoomInBtn.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -20),
            zoomInBtn.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -8),
            zoomInBtn.widthAnchor.constraint(equalToConstant: s),
            zoomInBtn.heightAnchor.constraint(equalToConstant: s),

            zoomOutBtn.topAnchor.constraint(equalTo: zoomInBtn.bottomAnchor, constant: 4),
            zoomOutBtn.trailingAnchor.constraint(equalTo: zoomInBtn.trailingAnchor),
            zoomOutBtn.widthAnchor.constraint(equalToConstant: s),
            zoomOutBtn.heightAnchor.constraint(equalToConstant: s),

            mapsBtn.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -8),
            mapsBtn.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 8),
            mapsBtn.widthAnchor.constraint(equalToConstant: s),
            mapsBtn.heightAnchor.constraint(equalToConstant: s),
        ])
    }

    private func makeSmallMapBtn(icon: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: icon), for: .normal)
        btn.tintColor = .label
        btn.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        btn.layer.cornerRadius = 8
        btn.layer.shadowColor   = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.15
        btn.layer.shadowOffset  = CGSize(width: 0, height: 1)
        btn.layer.shadowRadius  = 3
        return btn
    }

    private func updateButtonStates() {
        let confirmed = sighting.status == "confirmed"
        let rejected = sighting.status == "rejected"
        confirmButton.isEnabled = !confirmed
        rejectButton.isEnabled = !rejected
        if confirmed {
            confirmButton.alpha = 0.5
        }
        if rejected {
            rejectButton.alpha = 0.5
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }

    private func makeActionButton(icon: String, color: UIColor) -> UIButton {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = color.withAlphaComponent(0.15)
        btn.setImage(UIImage(systemName: icon), for: .normal)
        btn.tintColor = color
        btn.layer.cornerRadius = 20
        return btn
    }

    // MARK: - Map overlay actions

    @objc private func expandMapTapped() {
        let coord = (lat: sighting.latitude, lon: sighting.longitude)
        let fs = FullScreenMapViewController(coordinate: coord) { [weak self] mapView in
            guard let self, let map = mapView.mapWindow?.map else { return }
            self.setupMarkersOnMap(map)
            self.setupCameraOnMap(map)
        }
        present(fs, animated: true)
    }

    @objc private func mapZoomInTapped() {
        let map = mapView.mapWindow.map
        let p = map.cameraPosition
        map.move(
            with: YMKCameraPosition(target: p.target, zoom: p.zoom + 1, azimuth: p.azimuth, tilt: p.tilt),
            animation: YMKAnimation(type: .smooth, duration: 0.25), cameraCallback: nil
        )
    }

    @objc private func mapZoomOutTapped() {
        let map = mapView.mapWindow.map
        let p = map.cameraPosition
        map.move(
            with: YMKCameraPosition(target: p.target, zoom: p.zoom - 1, azimuth: p.azimuth, tilt: p.tilt),
            animation: YMKAnimation(type: .smooth, duration: 0.25), cameraCallback: nil
        )
    }

    @objc private func openInMapsTapped() {
        FullScreenMapViewController.openInYandexMaps(lat: sighting.latitude, lon: sighting.longitude)
    }

    // MARK: - Actions

    @objc private func chatTapped() {
        let chatVC = ChatViewController(
            pet: pet,
            recipientId: sighting.reporterId,
            recipientName: sighting.reporterName.isEmpty ? "Аноним" : sighting.reporterName,
            recipientAvatar: sighting.reporterAvatar,
            sightingId: sighting.id
        )
        navigationController?.pushViewController(chatVC, animated: true)
    }

    @objc private func confirmTapped() {
        patchStatus("confirmed") { [weak self] in
            guard let self else { return }
            self.sighting.status = "confirmed"
            self.confirmButton.isEnabled = false
            self.confirmButton.alpha = 0.5
            self.updateMapMarkers()
            self.updateMapCamera()
            self.showAlert("Подтверждено", message: "На карте отображены обе точки: где потерялся и где видели")
            NotificationCenter.default.post(name: .sightingStatusChanged, object: nil)
        }
    }

    @objc private func rejectTapped() {
        let alert = UIAlertController(
            title: "Отклонить наблюдение?",
            message: "Автор наблюдения получит уведомление об отклонении.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Отклонить", style: .destructive) { [weak self] _ in
            self?.patchStatus("rejected") { [weak self] in
                guard let self else { return }
                self.sighting.status = "rejected"
                self.rejectButton.isEnabled = false
                self.rejectButton.alpha = 0.5
                self.confirmButton.isEnabled = false
                self.confirmButton.alpha = 0.5
                self.updateMapMarkers()
                self.showAlert("Отклонено", message: "Наблюдение отклонено.")
            }
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }

    private struct PatchStatusRequest: Encodable {
        let status: String
    }

    private func patchStatus(_ status: String, completion: @escaping () -> Void) {
        Task {
            do {
                let _: EmptyResponse = try await APIClient.shared.request(
                    "PATCH",
                    path: "/pets/\(pet.id)/sightings/\(sighting.id)/status",
                    body: PatchStatusRequest(status: status)
                )
                await MainActor.run { completion() }
            } catch {
                await MainActor.run {
                    self.showAlert("Ошибка", message: error.localizedDescription)
                }
            }
        }
    }

    private func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Notification names

extension Notification.Name {
    static let sightingStatusChanged = Notification.Name("sightingStatusChanged")
}
