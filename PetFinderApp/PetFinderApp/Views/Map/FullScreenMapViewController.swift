//
//  FullScreenMapViewController.swift
//  PetFinderApp
//

import UIKit
import YandexMapsMobile

/// Полноэкранная карта. Передай замыкание `configure` — оно устанавливает камеру и маркеры
/// на новый YMKMapView уже после того, как view появится на экране.
final class FullScreenMapViewController: UIViewController {

    // MARK: - Properties

    private let configure: (YMKMapView) -> Void
    private let coordinate: (lat: Double, lon: Double)?

    private lazy var mapView: YMKMapView = {
        let mv = YMKMapView(frame: .zero)!
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
    }()

    // MARK: - Init

    /// - Parameters:
    ///   - coordinate: Координаты для кнопки «Открыть в Яндекс Картах».
    ///   - configure: Замыкание настраивает камеру и маркеры на переданном `YMKMapView`.
    init(coordinate: (lat: Double, lon: Double)? = nil,
         configure: @escaping (YMKMapView) -> Void) {
        self.coordinate = coordinate
        self.configure  = configure
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        setupButtons()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Включаем жесты в полноэкранном режиме
        if let map = mapView.mapWindow?.map {
            map.isZoomGesturesEnabled   = true
            map.isScrollGesturesEnabled = true
            map.isRotateGesturesEnabled = true
        }
        configure(mapView)
    }

    // MARK: - UI

    private func setupButtons() {
        let closeBtn   = makeBtn(icon: "xmark")
        let mapsBtn    = makeBtn(icon: "arrow.triangle.turn.up.right.circle.fill")
        let zoomInBtn  = makeBtn(icon: "plus")
        let zoomOutBtn = makeBtn(icon: "minus")

        closeBtn.addTarget  (self, action: #selector(closeTapped),   for: .touchUpInside)
        mapsBtn.addTarget   (self, action: #selector(openMapsTapped), for: .touchUpInside)
        zoomInBtn.addTarget (self, action: #selector(zoomInTapped),  for: .touchUpInside)
        zoomOutBtn.addTarget(self, action: #selector(zoomOutTapped), for: .touchUpInside)

        [closeBtn, mapsBtn, zoomInBtn, zoomOutBtn].forEach { view.addSubview($0) }

        let safe = view.safeAreaLayoutGuide
        let s: CGFloat = 44
        NSLayoutConstraint.activate([
            // Закрыть — левый верх
            closeBtn.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            closeBtn.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            closeBtn.widthAnchor.constraint(equalToConstant: s),
            closeBtn.heightAnchor.constraint(equalToConstant: s),

            // Открыть в картах — левый низ
            mapsBtn.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -24),
            mapsBtn.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            mapsBtn.widthAnchor.constraint(equalToConstant: s),
            mapsBtn.heightAnchor.constraint(equalToConstant: s),

            // Зум+ — правая сторона, чуть выше центра
            zoomInBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -26),
            zoomInBtn.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            zoomInBtn.widthAnchor.constraint(equalToConstant: s),
            zoomInBtn.heightAnchor.constraint(equalToConstant: s),

            // Зум− — под зум+
            zoomOutBtn.topAnchor.constraint(equalTo: zoomInBtn.bottomAnchor, constant: 6),
            zoomOutBtn.trailingAnchor.constraint(equalTo: zoomInBtn.trailingAnchor),
            zoomOutBtn.widthAnchor.constraint(equalToConstant: s),
            zoomOutBtn.heightAnchor.constraint(equalToConstant: s),
        ])
    }

    private func makeBtn(icon: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: icon), for: .normal)
        btn.tintColor = .label
        btn.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.92)
        btn.layer.cornerRadius = 22
        btn.layer.shadowColor  = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.18
        btn.layer.shadowOffset  = CGSize(width: 0, height: 2)
        btn.layer.shadowRadius  = 5
        return btn
    }

    // MARK: - Actions

    @objc private func closeTapped() { dismiss(animated: true) }

    @objc private func zoomInTapped() {
        guard let map = mapView.mapWindow?.map else { return }
        let p = map.cameraPosition
        map.move(
            with: YMKCameraPosition(target: p.target, zoom: p.zoom + 1, azimuth: p.azimuth, tilt: p.tilt),
            animation: YMKAnimation(type: .smooth, duration: 0.25),
            cameraCallback: nil
        )
    }

    @objc private func zoomOutTapped() {
        guard let map = mapView.mapWindow?.map else { return }
        let p = map.cameraPosition
        map.move(
            with: YMKCameraPosition(target: p.target, zoom: p.zoom - 1, azimuth: p.azimuth, tilt: p.tilt),
            animation: YMKAnimation(type: .smooth, duration: 0.25),
            cameraCallback: nil
        )
    }

    @objc private func openMapsTapped() {
        guard let (lat, lon) = coordinate else { return }
        FullScreenMapViewController.openInYandexMaps(lat: lat, lon: lon)
    }

    // MARK: - Static helper

    static func openInYandexMaps(lat: Double, lon: Double) {
        guard let url = URL(string: "https://maps.yandex.ru/?pt=\(lon),\(lat)&z=15") else { return }
        // Сначала пробуем universal link — открывает приложение Яндекс Карт напрямую без Safari
        UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { success in
            guard !success else { return }
            // Если universal link не сработал — открываем веб-версию
            UIApplication.shared.open(url)
        }
    }
}
