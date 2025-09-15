//
//  PetLocationPickerViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 15.09.2025.
//


import UIKit
import YandexMapsMobile
import CoreLocation

protocol PetLocationPickerDelegate: AnyObject {
    func didFinishPickingPetLocation(location: SavedLocation)
}

final class PetLocationPickerViewController: UIViewController, YMKMapInputListener {
    
    weak var delegate: PetLocationPickerDelegate?
    
    private lazy var searchManager: YMKSearchManager = YMKSearchFactory.instance().createSearchManager(with: .combined)
    private var searchSession: YMKSearchSession?
    
    private var mapView: YMKMapView!
    private var selectedPoint: YMKPoint
    private var selectedAddress: String
    
    private var placemark: YMKPlacemarkMapObject?
    
    private lazy var zoomInButton: UIButton = createZoomButton(systemImageName: "plus", action: #selector(zoomInTapped))
    private lazy var zoomOutButton: UIButton = createZoomButton(systemImageName: "minus", action: #selector(zoomOutTapped))
    
    // MARK: - Initialization
    
    init(initialLocation: SavedLocation?) {
        if let location = initialLocation, location.latitude != 0, location.longitude != 0 {
            self.selectedPoint = YMKPoint(latitude: location.latitude, longitude: location.longitude)
            self.selectedAddress = location.address
        } else {
            let `default` = LocationService.shared.getDefaultLocation()
            self.selectedPoint = YMKPoint(latitude: `default`.latitude, longitude: `default`.longitude)
            self.selectedAddress = `default`.address
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Укажите место"
        view.backgroundColor = .systemBackground
        
        self.isModalInPresentation = true
        
        setupMap()
        setupNavigationBar()
        setupZoomButtons() // 👈 Добавляем настройку кнопок зума
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.updatePlacemark()
        }
        
        if selectedAddress == "Не указано" || selectedAddress.isEmpty {
             reverseGeocode(point: selectedPoint)
        }
    }
    
    // MARK: - Setup
    
    private func setupMap() {
        mapView = YMKMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        mapView.mapWindow.map.move(with: YMKCameraPosition(target: selectedPoint, zoom: 12, azimuth: 0, tilt: 0))
        mapView.mapWindow.map.addInputListener(with: self)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneTapped))
    }
    
    private func setupZoomButtons() {
        view.addSubview(zoomInButton)
        view.addSubview(zoomOutButton)
        
        NSLayoutConstraint.activate([
            zoomOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            zoomOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            zoomOutButton.widthAnchor.constraint(equalToConstant: 44),
            zoomOutButton.heightAnchor.constraint(equalToConstant: 44),
            
            zoomInButton.trailingAnchor.constraint(equalTo: zoomOutButton.trailingAnchor),
            zoomInButton.bottomAnchor.constraint(equalTo: zoomOutButton.topAnchor, constant: -12),
            zoomInButton.widthAnchor.constraint(equalToConstant: 44),
            zoomInButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Map Logic
    
    private func updatePlacemark() {
        mapView.mapWindow.map.mapObjects.clear()
        placemark = mapView.mapWindow.map.mapObjects.addPlacemark()
        placemark?.geometry = selectedPoint
        
        if let icon = UIImage(systemName: "mappin.circle.fill") {
            let iconStyle = YMKIconStyle()
            iconStyle.anchor = NSValue(cgPoint: CGPoint(x: 0.5, y: 1.0))
            iconStyle.scale = 1.5
            placemark?.setIconWith(icon, style: iconStyle)
        }
    }
    
    func onMapTap(with map: YMKMap, point: YMKPoint) {
        selectedPoint = point
        updatePlacemark()
        reverseGeocode(point: point)
    }
    
    func onMapLongTap(with map: YMKMap, point: YMKPoint) {}
    
    private func reverseGeocode(point: YMKPoint) {
        self.selectedAddress = "Определение адреса..."
        searchSession?.cancel()
        
        searchSession = searchManager.submit(with: point, zoom: nil, searchOptions: YMKSearchOptions()) { [weak self] (response, error) in
            if let firstResult = response?.collection.children.first?.obj {
                self?.selectedAddress = firstResult.name ?? "Адрес не найден"
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneTapped() {
        let newLocation = SavedLocation(
            latitude: selectedPoint.latitude,
            longitude: selectedPoint.longitude,
            radius: 0,
            address: self.selectedAddress
        )
        delegate?.didFinishPickingPetLocation(location: newLocation)
        dismiss(animated: true)
    }
    
    
    private func createZoomButton(systemImageName: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: systemImageName), for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        button.tintColor = .black
        button.layer.cornerRadius = 22
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    @objc private func zoomInTapped() {
        changeZoom(by: 1.0)
    }
    
    @objc private func zoomOutTapped() {
        changeZoom(by: -1.0)
    }
    
    private func changeZoom(by amount: Float) {
        let currentPosition = mapView.mapWindow.map.cameraPosition
        let newPosition = YMKCameraPosition(
            target: currentPosition.target,
            zoom: currentPosition.zoom + amount,
            azimuth: currentPosition.azimuth,
            tilt: currentPosition.tilt
        )
        mapView.mapWindow.map.move(
            with: newPosition,
            animation: YMKAnimation(type: .linear, duration: 0.2)
        )
    }
}
