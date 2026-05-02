//
//  LocationPickerViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 01.09.2025.
//
import UIKit
import YandexMapsMobile
import CoreLocation


final class LocationPickerViewController: UIViewController, YMKMapInputListener, UITextFieldDelegate {

    // MARK: - Mode

    enum Mode {
        case search
        case sighting
    }

    // MARK: - Properties

    weak var delegate: LocationPickerDelegate?
    private let mode: Mode
    private var mapView: YMKMapView!

    private lazy var searchManager: YMKSearchManager = YMKSearchFactory.instance().createSearchManager(with: .combined)
    private var searchSession: YMKSearchSession?

    private var radiusStackView: UIStackView!
    private let radiusOptions: [Float] = [1, 2, 3, 5, 10, 15, 25, 50]

    private var selectedPoint: YMKPoint
    private var selectedRadius: Float
    private var selectedAddress: String
    
    private var placemark: YMKPlacemarkMapObject?
    private var circle: YMKCircleMapObject?
    
    private lazy var zoomInButton: UIButton = createZoomButton(systemImageName: "plus")
    private lazy var zoomOutButton: UIButton = createZoomButton(systemImageName: "minus")

    // MARK: - UI Elements
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Поиск по локации"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray5
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private let radiusButtonsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Радиус поиска, км"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let showButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Показать объявления", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .accent
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    // MARK: - Initialization

    init(mode: Mode = .search, initialLocation: CLLocation? = nil) {
        self.mode = mode
        if let loc = initialLocation {
            self.selectedPoint = YMKPoint(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
            self.selectedRadius = 1
            self.selectedAddress = ""
        } else if let saved = LocationService.shared.loadLocation() {
            self.selectedPoint = YMKPoint(latitude: saved.latitude, longitude: saved.longitude)
            self.selectedRadius = saved.radius
            self.selectedAddress = saved.address
        } else {
            let `default` = LocationService.shared.getDefaultLocation()
            self.selectedPoint = YMKPoint(latitude: `default`.latitude, longitude: `default`.longitude)
            self.selectedRadius = `default`.radius
            self.selectedAddress = `default`.address
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Местоположение"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )

        if mode == .sighting {
            title = "Укажите место"
            showButton.setTitle("Выбрать место", for: .normal)
        }

        setupUI()
        setupMap()
        updateMapObjects()

        if mode == .sighting {
            radiusButtonsTitleLabel.isHidden = true
            radiusStackView.isHidden = true
        }

        showButton.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }
    
    // MARK: - Setup

    private func setupUI() {
        mapView = YMKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTextField)
        
        radiusButtonsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(radiusButtonsTitleLabel)
        
        radiusStackView = createRadiusButtons()
        radiusStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(radiusStackView)
        
        showButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(showButton)
        
        NSLayoutConstraint.activate([
            showButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            showButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            showButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            showButton.heightAnchor.constraint(equalToConstant: 50),

            radiusStackView.bottomAnchor.constraint(equalTo: showButton.topAnchor, constant: -16),
            radiusStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            radiusStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            radiusButtonsTitleLabel.bottomAnchor.constraint(equalTo: radiusStackView.topAnchor, constant: -8),
            radiusButtonsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            radiusButtonsTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            mapView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // В режиме .sighting радиус-элементы скрыты — тянем карту прямо к кнопке
            mapView.bottomAnchor.constraint(equalTo: mode == .sighting
                ? showButton.topAnchor
                : radiusButtonsTitleLabel.topAnchor,
                constant: -16)
        ])
        
        view.addSubview(zoomInButton)
        view.addSubview(zoomOutButton)
        
        NSLayoutConstraint.activate([
            zoomInButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16),
            zoomInButton.bottomAnchor.constraint(equalTo: zoomOutButton.topAnchor, constant: -12),
            zoomInButton.widthAnchor.constraint(equalToConstant: 44),
            zoomInButton.heightAnchor.constraint(equalToConstant: 44),
            
            zoomOutButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16),
            zoomOutButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -16),
            zoomOutButton.widthAnchor.constraint(equalToConstant: 44),
            zoomOutButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    private func setupMap() {
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: selectedPoint, zoom: 10, azimuth: 0, tilt: 0)
        )

        mapView.mapWindow.map.addInputListener(with: self)
    }
    
    // MARK: - Map Logic
    
    private func updateMapObjects() {
        mapView.mapWindow.map.mapObjects.clear()
        placemark = mapView.mapWindow.map.mapObjects.addPlacemark()
        placemark?.geometry = selectedPoint

        if let icon = UIImage(systemName: "mappin.circle.fill")?
            .withTintColor(.label, renderingMode: .alwaysOriginal) {
            let iconStyle = YMKIconStyle()
            iconStyle.anchor = NSValue(cgPoint: CGPoint(x: 0.5, y: 1.0))
            iconStyle.scale = NSNumber(value: 1.5)
            placemark?.setIconWith(icon, style: iconStyle)
        }

        if mode == .search {
            let circle = YMKCircle(center: selectedPoint, radius: selectedRadius * 1000)
            self.circle = mapView.mapWindow.map.mapObjects.addCircle(with: circle)
            self.circle?.strokeColor = .accent
            self.circle?.strokeWidth = 2
            self.circle?.fillColor = UIColor.accent.withAlphaComponent(0.2)
        }
    }
    
    func onMapTap(with map: YMKMap, point: YMKPoint) {
        self.selectedPoint = point
        submitReverseGeocoding(point: point)
        updateMapObjects()
    }
    
    func onMapLongTap(with map: YMKMap, point: YMKPoint) { }
    
    // MARK: - Search Logic

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = textField.text, !query.isEmpty {
            submitSearch(query: query)
        }
        textField.resignFirstResponder()
        return true
    }

    @objc private func searchTextChanged() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performDelayedSearch), object: nil)
        perform(#selector(performDelayedSearch), with: nil, afterDelay: 0.6)
    }

    @objc private func performDelayedSearch() {
        guard let query = searchTextField.text, !query.isEmpty else { return }
        submitSearch(query: query)
    }
    
    private func submitSearch(query: String) {
        let responseHandler = { [weak self] (searchResponse: YMKSearchResponse?, error: Error?) -> Void in
            guard let self = self else { return }
            if let response = searchResponse, let firstResult = response.collection.children.first?.obj, let point = firstResult.geometry.first?.point {
                self.selectedPoint = point
                self.selectedAddress = firstResult.name ?? "Неизвестный адрес"
                self.mapView.mapWindow.map.move(
                    with: YMKCameraPosition(target: point, zoom: 12, azimuth: 0, tilt: 0),
                    animation: YMKAnimation(type: .smooth, duration: 1.0)
                )
                self.updateMapObjects()
            }
        }
        
        let visibleRegion = mapView.mapWindow.map.visibleRegion
        searchSession = searchManager.submit(withText: query, geometry: YMKGeometry(boundingBox: visibleRegion.toBoundingBox()), searchOptions: YMKSearchOptions(), responseHandler: responseHandler)
    }
    
    private func submitReverseGeocoding(point: YMKPoint) {
        searchSession?.cancel()
        searchSession = searchManager.submit(with: point, zoom: nil, searchOptions: YMKSearchOptions()) { [weak self] (response, error) in
            if let response = response, let firstResult = response.collection.children.first?.obj {
                self?.selectedAddress = firstResult.name ?? "Неизвестный адрес"
            }
        }
    }
    
    // MARK: - Radius Buttons
    private func createRadiusButtons() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        
        for (index, radius) in radiusOptions.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle("\(Int(radius))", for: .normal)
            button.tag = index
            button.layer.cornerRadius = 15
            button.heightAnchor.constraint(equalToConstant: 30).isActive = true
            button.addTarget(self, action: #selector(radiusButtonTapped(_:)), for: .touchUpInside)
            updateRadiusButtonAppearance(button, isSelected: radius == selectedRadius)
            stackView.addArrangedSubview(button)
        }
        return stackView
    }
    
    
    private func updateRadiusButtonAppearance(_ button: UIButton, isSelected: Bool) {
        if isSelected {
            button.backgroundColor = .black
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        } else {
            button.backgroundColor = .systemGray5
            button.setTitleColor(.label, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        }
    }
    
    @objc private func radiusButtonTapped(_ sender: UIButton) {
        selectedRadius = radiusOptions[sender.tag]
        
        radiusStackView.arrangedSubviews.forEach { view in
            if let button = view as? UIButton {
                updateRadiusButtonAppearance(button, isSelected: button.tag == sender.tag)
            }
        }
        
        updateMapObjects()
    }
        private func createZoomButton(systemImageName: String) -> UIButton {
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
            
            if systemImageName == "plus" {
                button.addTarget(self, action: #selector(zoomInTapped), for: .touchUpInside)
            } else {
                button.addTarget(self, action: #selector(zoomOutTapped), for: .touchUpInside)
            }
            
            return button
        }

        // MARK: - Zoom Actions
        
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
    
    // MARK: - Actions

    @objc private func cancelButtonTapped() {
        if navigationController != nil && mode == .sighting {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }

    @objc private func showButtonTapped() {
        let newLocation = SavedLocation(
            latitude: selectedPoint.latitude,
            longitude: selectedPoint.longitude,
            radius: selectedRadius,
            address: selectedAddress
        )
        if mode == .search {
            LocationService.shared.saveLocation(newLocation)
            delegate?.didFinishPickingLocation(location: newLocation)
            dismiss(animated: true)
        } else {
            delegate?.didFinishPickingLocation(location: newLocation)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension YMKVisibleRegion {
    func toBoundingBox() -> YMKBoundingBox {
        return YMKBoundingBox(
            southWest: YMKPoint(latitude: self.bottomLeft.latitude, longitude: self.bottomLeft.longitude),
            northEast: YMKPoint(latitude: self.topRight.latitude, longitude: self.topRight.longitude)
        )
    }
}
