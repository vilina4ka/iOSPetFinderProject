//
//  AddEditViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 11.09.2025.
//

import UIKit
import Combine
import YandexMapsMobile
import Kingfisher
import PhotosUI

class AddEditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, PHPickerViewControllerDelegate, PetLocationPickerDelegate, UICollectionViewDataSource {

    // MARK: - Properties
    
    let viewModel: AddEditPetViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Elements
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var photosCollectionView: UICollectionView!
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+ добавить фото", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.backgroundColor = .systemGray5 // Серый цвет
        button.setTitleColor(.label, for: .normal) // Цвет текста по умолчанию (черный/белый)
        button.layer.cornerRadius = 16
        return button
    }()
    
    private lazy var nameTextField = self.createTextField(placeholder: "Кличка животного")
    private lazy var ageTextField = self.createTextField(placeholder: "Возраст", keyboardType: .numberPad)
    private lazy var lostDateTextField = self.createTextField(placeholder: "дд.мм.гггг")
    private lazy var characterTextField = self.createTextField(placeholder: "Характер")
    private lazy var signsTextField = self.createTextField(placeholder: "Приметы")
    private lazy var phoneTextField = self.createTextField(placeholder: "Телефон", keyboardType: .phonePad)
    private lazy var contactNameTextField = self.createTextField(placeholder: "Ваше имя")
    
    private lazy var catRadioButton = self.createRadioButton(title: "кошка")
    private lazy var dogRadioButton = self.createRadioButton(title: "собака")
    
    private lazy var breedTextField = self.createTextField(placeholder: "Выберите породу")
    private let breedPicker = UIPickerView()
    
    private lazy var locationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "📍 укажите место"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var mapView: YMKMapView = {
        let map = YMKMapView()
        map.layer.cornerRadius = 16
        map.clipsToBounds = true
        map.mapWindow?.map.isZoomGesturesEnabled = false
        map.mapWindow?.map.isScrollGesturesEnabled = false
        return map
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(viewModel.isEditing ? "Сохранить" : "Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 28
        return button
    }()

    // MARK: - Initialization & Lifecycle
    
    init(viewModel: AddEditPetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.isEditing ? "Редактирование" : "Новая анкета"
        
        setupUI()
        setupBindings()
        setupPickers()
        setupTapGestures()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 140)
        layout.minimumLineSpacing = 12
        
        photosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photosCollectionView.dataSource = self
        photosCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        photosCollectionView.backgroundColor = .clear
        photosCollectionView.showsHorizontalScrollIndicator = false
        
        let radioStack = UIStackView(arrangedSubviews: [catRadioButton, dogRadioButton, UIView()])
        radioStack.spacing = 20
        
        let breedLabel = createLabel(text: "порода:")
        let breedStack = UIStackView(arrangedSubviews: [breedLabel, breedTextField])
        
        let ageLabel = createLabel(text: "возраст:")
        let ageStack = UIStackView(arrangedSubviews: [ageLabel, ageTextField])

        let lostDateLabel = createLabel(text: "дата пропажи")
        let lostDateStack = UIStackView(arrangedSubviews: [lostDateLabel, lostDateTextField])

        let characterLabel = createLabel(text: "характер")
        let characterStack = UIStackView(arrangedSubviews: [characterLabel, characterTextField])

        let signsLabel = createLabel(text: "приметы")
        let signsStack = UIStackView(arrangedSubviews: [signsLabel, signsTextField])

        let phoneLabel = createLabel(text: "телефон")
        let phoneStack = UIStackView(arrangedSubviews: [phoneLabel, phoneTextField])

        let nameLabel = createLabel(text: "ваше имя")
        let nameStack = UIStackView(arrangedSubviews: [nameLabel, contactNameTextField])
        
        // Убираем блок с фото из основного стека
        let mainStack = UIStackView(arrangedSubviews: [
            nameTextField, radioStack, breedStack, ageStack,
            lostDateStack, characterStack, signsStack, phoneStack,
            nameStack, locationTitleLabel, mapView
        ])
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.spacing = 24
        mainStack.setCustomSpacing(16, after: locationTitleLabel)

        contentView.addSubview(mainStack)
        contentView.addSubview(addPhotoButton) // Добавляем кнопку фото отдельно
        contentView.addSubview(photosCollectionView) // Добавляем галерею отдельно
        view.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -16),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),
            
            mapView.heightAnchor.constraint(equalToConstant: 150),
            
            // Новые констрейнты для блока с фото
            addPhotoButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 24),
            addPhotoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addPhotoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 50),
            
            photosCollectionView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 12),
            photosCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            photosCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            photosCollectionView.heightAnchor.constraint(equalToConstant: 140),
            photosCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            // Констрейнты для кнопки "Создать"
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        [breedStack, ageStack, lostDateStack, characterStack, signsStack, phoneStack, nameStack].forEach {
            ($0 as UIStackView).distribution = .fillEqually
        }
    }
    
    private func setupBindings() {
        if viewModel.isEditing {
            nameTextField.text = viewModel.petName
            ageTextField.text = viewModel.petAge
            characterTextField.text = viewModel.petCharacter
            signsTextField.text = viewModel.petExternalSigns
            phoneTextField.text = viewModel.contactPhone
            contactNameTextField.text = viewModel.contactName
            breedTextField.text = viewModel.petBreed
        }
        
        viewModel.$petType.receive(on: DispatchQueue.main).sink { [weak self] type in
            self?.catRadioButton.isSelected = (type == .cat)
            self?.dogRadioButton.isSelected = (type == .dog)
            self?.breedPicker.reloadAllComponents()
            if !(self?.viewModel.isEditing ?? false) {
                self?.viewModel.petBreed = ""
                self?.breedTextField.text = ""
            }
        }.store(in: &cancellables)
            
        viewModel.$didSavePet.filter { $0 }.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)
            
        viewModel.$photos.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.photosCollectionView.reloadData()
        }.store(in: &cancellables)
        
        updateLocationUI(location: viewModel.petLocation)
    }
    
    private func setupPickers() {
        breedPicker.delegate = self
        breedPicker.dataSource = self
        breedTextField.inputView = breedPicker
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.date = viewModel.lostDate
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        lostDateTextField.inputView = datePicker
        lostDateTextField.inputAccessoryView = createToolbar()
        breedTextField.inputAccessoryView = createToolbar()
        
        updateLostDateTextField()
    }
    
    private func setupTapGestures() {
        catRadioButton.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        dogRadioButton.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        addPhotoButton.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        
        let locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(locationTapped))
        mapView.addGestureRecognizer(locationTapGesture)
        
        let locationLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(locationTapped))
        locationTitleLabel.addGestureRecognizer(locationLabelTapGesture)
    }
    
    // MARK: - Actions & Logic
    
    @objc private func radioButtonTapped(_ sender: UIButton) {
        viewModel.petType = (sender == catRadioButton) ? .cat : .dog
    }
    
    @objc private func datePickerChanged(_ sender: UIDatePicker) {
        viewModel.lostDate = sender.date
        updateLostDateTextField()
    }
    
    @objc private func saveButtonTapped() {
        viewModel.petName = nameTextField.text ?? ""
        viewModel.petAge = ageTextField.text ?? ""
        viewModel.petCharacter = characterTextField.text ?? ""
        viewModel.petExternalSigns = signsTextField.text ?? ""
        viewModel.contactPhone = phoneTextField.text ?? ""
        viewModel.contactName = contactNameTextField.text ?? ""
        
        Task {
            await viewModel.savePet()
        }
    }
    
    private func updateLostDateTextField() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        lostDateTextField.text = formatter.string(from: viewModel.lostDate)
    }
    
    @objc private func addPhotoTapped() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 5
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func locationTapped() {
        let petLocationPicker = PetLocationPickerViewController(initialLocation: viewModel.petLocation)
        petLocationPicker.delegate = self
        let navController = UINavigationController(rootViewController: petLocationPicker)
        present(navController, animated: true)
    }
    
    // MARK: - Delegate Implementations
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                guard let image = image as? UIImage else { return }
                self?.viewModel.add(newImage: image)
            }
        }
    }
    
    func didFinishPickingPetLocation(location: SavedLocation) {
        viewModel.petLocation = location
        updateLocationUI(location: location)
    }
    
    private func updateLocationUI(location: SavedLocation?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let location = location else {
                self.locationTitleLabel.text = "📍 укажите место"
                return
            }
            self.locationTitleLabel.text = "📍 \(location.address)"
            let point = YMKPoint(latitude: location.latitude, longitude: location.longitude)
            self.mapView.mapWindow.map.move(with: YMKCameraPosition(target: point, zoom: 15, azimuth: 0, tilt: 0))
            self.mapView.mapWindow.map.mapObjects.clear()
            let placemark = self.mapView.mapWindow.map.mapObjects.addPlacemark()
            placemark.geometry = point
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { viewModel.availableBreeds.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { viewModel.availableBreeds[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedBreed = viewModel.availableBreeds[row]
        viewModel.petBreed = selectedBreed
        breedTextField.text = selectedBreed
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        let photo = viewModel.photos[indexPath.item]
        
        switch photo {
        case .existing(let url):
            cell.imageView.kf.setImage(with: url)
        case .new(let image):
            cell.imageView.image = image
        }
        
        cell.deleteButtonAction = { [weak self] in
            self?.viewModel.removePhoto(at: indexPath.item)
        }
        
        return cell
    }
    
    // MARK: - UI Factory Methods
    
    private func createTextField(placeholder: String, keyboardType: UIKeyboardType = .default) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 18)
        textField.keyboardType = keyboardType
        return textField
    }

    private func createRadioButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("  \(title)", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        button.tintColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 18)
        return button
    }

    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label
        return label
    }
    
    private func createButton(title: String? = nil, imageName: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: imageName), for: .normal)
        if let title = title {
            button.setTitle(title, for: .normal)
        }
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .systemGray5
        button.tintColor = .label
        button.layer.cornerRadius = 12
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(dismissKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        return toolbar
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
