//
//  PetDetailViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 11.09.2025.
//

import UIKit
import YandexMapsMobile
import Kingfisher

final class PetDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let pet: Pet
    
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
    
    private let petImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
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
    
    private let locationTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let mapView: YMKMapView = {
        let map = YMKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.layer.cornerRadius = 16
        map.clipsToBounds = true
        // Отключаем все жесты, чтобы карта была просто статичной картинкой
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
        // TODO: Добавить target/action для звонка
        return button
    }()
    
    private let chatButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 200/255, green: 220/255, blue: 255/255, alpha: 1.0)
        button.setImage(UIImage(systemName: "message.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 20
        // TODO: Добавить target/action для открытия чата
        return button
    }()
    
    // MARK: - Initialization
    
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
        
        setupNavigationBar()
        setupUI()
        configureData()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        /*if AuthManager.shared.currentUser?.id == pet.ownerId {
         navigationItem.rightBarButtonItem = UIBarButtonItem(
         title: "Редактировать",
         style: .plain,
         target: self,
         action: #selector(editButtonTapped)
         )
         }
         */
        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(shareButtonTapped)
        )
        
        let generateButton = UIBarButtonItem(
            image: UIImage(systemName: "wand.and.stars"),
            style: .plain,
            target: self,
            action: #selector(generateButtonTapped)
        )
        
        let subscribeButton = UIBarButtonItem(
            image: UIImage(systemName: "bell.fill"),
            style: .plain,
            target: self,
            action: #selector(subscribeButtonTapped)
        )
        navigationItem.rightBarButtonItems = [shareButton, generateButton, subscribeButton]
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [petImageView, titleLabel, nameLabel, ownerImageView, descriptionLabel, externalSignsLabel, ageLabel, locationTitleLabel, mapView].forEach(contentView.addSubview)
        
        [callButton, chatButton].forEach(view.addSubview)
        
        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        mapView.addGestureRecognizer(mapTapGesture)
        mapView.isUserInteractionEnabled = true
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            callButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            callButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            callButton.heightAnchor.constraint(equalToConstant: 60),
            
            chatButton.leadingAnchor.constraint(equalTo: callButton.trailingAnchor, constant: padding),
            chatButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            chatButton.bottomAnchor.constraint(equalTo: callButton.bottomAnchor),
            chatButton.heightAnchor.constraint(equalTo: callButton.heightAnchor),
            chatButton.widthAnchor.constraint(equalTo: callButton.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: callButton.topAnchor, constant: -padding),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            petImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            petImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            petImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            petImageView.heightAnchor.constraint(equalTo: petImageView.widthAnchor, multiplier: 0.8),
            
            titleLabel.topAnchor.constraint(equalTo: petImageView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            ownerImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            ownerImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: padding),
            ownerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ownerImageView.widthAnchor.constraint(equalToConstant: 50),
            ownerImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: ownerImageView.leadingAnchor, constant: -padding),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            externalSignsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: padding),
            externalSignsLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            externalSignsLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            
            ageLabel.topAnchor.constraint(equalTo: externalSignsLabel.bottomAnchor, constant: padding),
            ageLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            ageLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            
            locationTitleLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 24),
            locationTitleLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            locationTitleLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            
            mapView.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor, constant: padding),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            mapView.heightAnchor.constraint(equalToConstant: 200),
            mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    private func configureData() {
        if let firstImageUrl = pet.imageUrls.first, let url = URL(string: firstImageUrl) {
            petImageView.kf.setImage(with: url)
        }
        
        ownerImageView.image = UIImage(systemName: "person.circle")
        
        titleLabel.text = pet.breed
        nameLabel.text = "Кличка: \(pet.name)"
        descriptionLabel.text = pet.description
        externalSignsLabel.text = "Внешние признаки: \(pet.externalSigns ?? "не указаны")"
        
        if let age = pet.age {
            ageLabel.text = "Возраст: \(age) лет"
        } else {
            ageLabel.text = "Возраст: не указан"
        }
        
        locationTitleLabel.text = "📍 Локация: \(pet.location)"
        
        if let lat = pet.latitude, let lon = pet.longitude {
            let point = YMKPoint(latitude: lat, longitude: lon)
            mapView.mapWindow?.map.move(with: YMKCameraPosition(target: point, zoom: 15, azimuth: 0, tilt: 0))
            let placemark = mapView.mapWindow?.map.mapObjects.addPlacemark()
            placemark?.geometry = point
        }
    }
    
    // MARK: - Actions
    
    @objc private func editButtonTapped() {
        let viewModel = AddEditPetViewModel(petToEdit: self.pet)
        let vc = AddEditViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func mapTapped() {
        guard let lat = pet.latitude, let lon = pet.longitude else {
            let alert = UIAlertController(title: "Ошибка", message: "Координаты не указаны.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
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
    @objc private func shareButtonTapped() {}
    @objc private func generateButtonTapped() {}
    @objc private func subscribeButtonTapped() {}
}

