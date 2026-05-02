//
//  AddEditViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 06.09.2025.
//
import UIKit
import Combine
import YandexMapsMobile
import Kingfisher
import PhotosUI

class AddEditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, PHPickerViewControllerDelegate, PetLocationPickerDelegate, UICollectionViewDataSource, UITextFieldDelegate {

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
        button.backgroundColor = .systemGray5
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()

    private lazy var nameTextField = self.createTextField(placeholder: "Кличка животного *")
    private lazy var ageTextField = self.createTextField(placeholder: "Полных лет", keyboardType: .numberPad)
    private lazy var lostDateTextField = self.createTextField(placeholder: "дд.мм.гггг *")
    private lazy var signsTextView = self.createTextView(placeholder: "")
    private lazy var descriptionTextView = self.createTextView(placeholder: "")
    
    private lazy var catRadioButton = self.createRadioButton(title: "кошка")
    private lazy var dogRadioButton = self.createRadioButton(title: "собака")
    
    private lazy var breedTextField = self.createTextField(placeholder: "Выберите породу")
    private let breedPicker = UIPickerView()
    
    private lazy var locationTitleLabel: UILabel = {
        let label = UILabel()
        label.setLocationText("укажите место")
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
        button.backgroundColor = .accent
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
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
        
        let breedLabel = createLabel(text: "порода *")
        let breedStack = UIStackView(arrangedSubviews: [breedLabel, breedTextField])

        let ageLabel = createLabel(text: "возраст")
        let ageStack = UIStackView(arrangedSubviews: [ageLabel, ageTextField])

        let lostDateLabel = createLabel(text: "дата пропажи *")
        let lostDateStack = UIStackView(arrangedSubviews: [lostDateLabel, lostDateTextField])

        let signsLabel = createLabel(text: "приметы *")
        let signsStack = UIStackView(arrangedSubviews: [signsLabel, signsTextView])
        signsStack.axis = .vertical
        signsStack.spacing = 6

        let descriptionLabel = createLabel(text: "описание")
        let descriptionStack = UIStackView(arrangedSubviews: [descriptionLabel, descriptionTextView])
        descriptionStack.axis = .vertical
        descriptionStack.spacing = 6

        let mainStack = UIStackView(arrangedSubviews: [
            nameTextField, radioStack, breedStack, ageStack,
            lostDateStack, signsStack, descriptionStack,
            locationTitleLabel, mapView
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
            
            addPhotoButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 24),
            addPhotoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addPhotoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 50),
            
            photosCollectionView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 12),
            photosCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            photosCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            photosCollectionView.heightAnchor.constraint(equalToConstant: 140),
            photosCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        [breedStack, ageStack, lostDateStack].forEach {
            ($0 as UIStackView).distribution = .fillEqually
        }
    }
    
    private func setupBindings() {
        if viewModel.isEditing {
            nameTextField.text = viewModel.petName
            ageTextField.text = viewModel.petAge
            signsTextView.setText(viewModel.petExternalSigns)
            descriptionTextView.setText(viewModel.petDescription)
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

        viewModel.$errorMessage.compactMap { $0 }.receive(on: DispatchQueue.main).sink { [weak self] message in
            guard let self else { return }
            let isValidation = message.hasPrefix("Пожалуйста, укажите")
            if isValidation {
                self.highlightEmptyRequiredFields()
            }
            let title = isValidation ? "Заполните поля" : "Не удалось сохранить"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }.store(in: &cancellables)
            
        viewModel.$photos.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.photosCollectionView.reloadData()
        }.store(in: &cancellables)

        viewModel.$isLoading.receive(on: DispatchQueue.main).sink { [weak self] loading in
            guard let self else { return }
            self.createButton.isEnabled = !loading
            self.createButton.alpha = loading ? 0.5 : 1.0
            self.createButton.setTitle(loading ? "Сохранение..." : (self.viewModel.isEditing ? "Сохранить" : "Создать"), for: .normal)
        }.store(in: &cancellables)
        
        updateLocationUI(location: viewModel.petLocation)
    }
    
    private func setupPickers() {
        breedPicker.delegate = self
        breedPicker.dataSource = self
        breedTextField.inputView = breedPicker
        breedTextField.delegate = self      // запрещаем ручной ввод
        lostDateTextField.delegate = self   // только через датапикер
        nameTextField.delegate = self       // ограничение 30 символов
        ageTextField.delegate = self        // только цифры, не более 2 символов
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.maximumDate = Date()
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
        guard !viewModel.isLoading else { return }   // блокируем повторный тап во время сохранения
        view.endEditing(true)

        viewModel.petName = nameTextField.text ?? ""
        viewModel.petAge = ageTextField.text ?? ""
        viewModel.petExternalSigns = signsTextView.realText
        viewModel.petDescription = descriptionTextView.realText

        Task { await viewModel.savePet() }
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
                Task { @MainActor [weak self] in
                    self?.viewModel.add(newImage: image)
                }
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
                self.locationTitleLabel.setLocationText("укажите место")
                return
            }
            self.locationTitleLabel.setLocationText(location.address)
            let point = YMKPoint(latitude: location.latitude, longitude: location.longitude)
            self.mapView.mapWindow.map.move(with: YMKCameraPosition(target: point, zoom: 15, azimuth: 0, tilt: 0))
            self.mapView.mapWindow.map.mapObjects.clear()
            let placemark = self.mapView.mapWindow.map.mapObjects.addPlacemark()
            placemark.geometry = point
            if let icon = UIImage(systemName: "mappin.circle.fill")?
                .withTintColor(.label, renderingMode: .alwaysOriginal) {
                let iconStyle = YMKIconStyle()
                iconStyle.anchor = NSValue(cgPoint: CGPoint(x: 0.5, y: 1.0))
                iconStyle.scale = NSNumber(value: 1.5)
                placemark.setIconWith(icon, style: iconStyle)
            }
        }
    }
    
    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == breedTextField || textField == lostDateTextField { return false }

        let current = (textField.text ?? "") as NSString
        let newString = current.replacingCharacters(in: range, with: string)

        if textField == nameTextField {
            return newString.count <= 30
        }

        if textField == ageTextField {
            let allowedChars = CharacterSet.decimalDigits
            guard string.unicodeScalars.allSatisfy({ allowedChars.contains($0) }) else { return false }
            return newString.count <= 2
        }

        return true
    }

    // MARK: - UIPickerViewDataSource / Delegate

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
    
    // MARK: - Validation Highlight

    private func highlightEmptyRequiredFields() {
        let textFields: [(UIView, Bool)] = [
            (nameTextField,  viewModel.petName.trimmingCharacters(in: .whitespaces).isEmpty),
            (breedTextField, viewModel.petBreed.isEmpty),
            (signsTextView,  viewModel.petExternalSigns.trimmingCharacters(in: .whitespaces).isEmpty)
        ]
        for (view, isEmpty) in textFields {
            view.layer.cornerRadius = 8
            view.layer.borderWidth = isEmpty ? 1.5 : 0
            view.layer.borderColor = isEmpty ? UIColor.systemRed.cgColor : UIColor.clear.cgColor
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            textFields.forEach { $0.0.layer.borderWidth = 0 }
        }
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
        button.tintColor = .accent
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
    
    private func createTextView(placeholder: String) -> PlaceholderTextView {
        let tv = PlaceholderTextView(placeholder: placeholder)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = .systemFont(ofSize: 18)
        tv.backgroundColor = .systemGray6
        tv.layer.cornerRadius = 10
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        tv.isScrollEnabled = false
        tv.heightAnchor.constraint(greaterThanOrEqualToConstant: 90).isActive = true
        return tv
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

// MARK: - PlaceholderTextView

final class PlaceholderTextView: UITextView, UITextViewDelegate {

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor.placeholderText
        return label
    }()

    init(placeholder: String) {
        super.init(frame: .zero, textContainer: nil)
        placeholderLabel.text = placeholder
        placeholderLabel.font = font ?? .systemFont(ofSize: 18)
        delegate = self
        addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func setText(_ text: String) {
        self.text = text
        placeholderLabel.isHidden = !text.isEmpty
    }

    var realText: String {
        return placeholderLabel.isHidden ? (text ?? "") : ""
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !(text?.isEmpty ?? true)
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !(text?.isEmpty ?? true)
    }
}
