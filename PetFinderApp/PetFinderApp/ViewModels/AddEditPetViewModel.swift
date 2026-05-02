//
//  AddEditPetViewModel.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 06.09.2025.
//

import UIKit
import Combine

enum PetPhoto {
    case existing(url: URL)
    case new(image: UIImage)
}

struct UpsertPet: Codable {
    let name: String
    let breed: String
    let description: String
    let location: String
    let imageUrls: [String]
    let externalSigns: String?
    let latitude: Double?
    let longitude: Double?
    let age: Int?
    let type: String
    let contactPhone: String?
    let contactName: String?
    let lostDate: Date?

    enum CodingKeys: String, CodingKey {
        case name, breed, age, type
        case location = "address" 
        case imageUrls
        case externalSigns
        case latitude, longitude
        case contactPhone
        case contactName
        case lostDate
        case description
    }
}

enum PetType: String, CaseIterable, Codable {
    case cat = "кошка"
    case dog = "собака"
}

@MainActor
class AddEditPetViewModel: ObservableObject {

    // MARK: - Form data

    @Published var petName: String = ""
    @Published var petType: PetType = .dog
    @Published var petBreed: String = ""
    @Published var petAge: String = ""
    @Published var lostDate: Date = Date()
    @Published var petExternalSigns: String = ""
    @Published var petDescription: String = "" 
    @Published var contactPhone: String = ""
    @Published var contactName: String = ""
    @Published var petLocation: SavedLocation?

    // MARK: - UI

    @Published var photos: [PetPhoto] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didSavePet = false

    private let petToEdit: Pet?
    private let repository: PetRepositoryProtocol

    // MARK: - Breed List

    let dogBreeds = [
        "Дворняжка", "Австралийская овчарка", "Акита-ину", "Алабай",
        "Аляскинский маламут", "Американский бульдог", "Английский бульдог",
        "Басенджи", "Бассет-хаунд", "Бельгийская овчарка", "Бернский зенненхунд",
        "Бигль", "Бишон фризе", "Бобтейл", "Боксер", "Бордер-колли", "Бостон-терьер",
        "Брюссельский гриффон", "Бульмастиф", "Бультерьер", "Веймаранер",
        "Вельш-корги", "Вест-хайленд-уайт-терьер", "Грейхаунд", "Далматин",
        "Джек-рассел-терьер", "Доберман", "Золотистый ретривер", "Ирландский сеттер",
        "Йоркширский терьер", "Кавказская овчарка", "Кане-корсо", "Кокер-спаниель",
        "Колли", "Лабрадор-ретривер", "Мальтипу", "Мопс", "Немецкая овчарка",
        "Немецкий дог", "Папильон", "Пекинес", "Пинчер", "Питбуль", "Померанский шпиц", "Пти-брабансон",
        "Пудель", "Ризеншнауцер", "Ротвейлер", "Русский той-терьер", "Самоед",
        "Сенбернар", "Сиба-ину", "Сибирский хаски", "Стаффордширский терьер",
        "Такса", "Тибетский мастиф", "Уиппет", "Французский бульдог", "Цвергшнауцер",
        "Чау-чау", "Чихуахуа", "Шарпей", "Ши-тцу", "Шпиц", "Эрдельтерьер", "Ягдтерьер"
    ]

    let catBreeds = [
        "Беспородная", "Абиссинская", "Бенгальская", "Бирманская", "Бомбейская",
        "Британская короткошерстная", "Бурманская", "Девон-рекс", "Донской сфинкс",
        "Египетская мау", "Канадский сфинкс", "Корниш-рекс", "Курильский бобтейл",
        "Мейн-кун", "Невская маскарадная", "Ориентальная", "Персидская",
        "Петерболд", "Русская голубая", "Рэгдолл", "Селкирк-рекс",
        "Сиамская", "Сибирская", "Шотландская вислоухая", "Сомали", "Тайская",
        "Турецкая ангора", "Чаузи", "Шартрез", "Экзотическая короткошерстная"
    ]

    var availableBreeds: [String] {
        switch petType {
        case .cat: return catBreeds
        case .dog: return dogBreeds
        }
    }

    var isEditing: Bool {
        return petToEdit != nil
    }

    // MARK: - Initialization

    init(petToEdit: Pet? = nil, repository: PetRepositoryProtocol = APIClientPetRepository()) {
        self.petToEdit = petToEdit
        self.repository = repository

        let user = AuthManager.shared.currentUser
        self.contactName = user?.name ?? ""
        self.contactPhone = user?.phone ?? ""

        if let pet = petToEdit {
            self.petName = pet.name
            self.petBreed = pet.breed
            self.petDescription = pet.description
            self.petExternalSigns = pet.externalSigns ?? ""
            self.petAge = pet.age != nil ? "\(pet.age!)" : ""
            self.petType = PetType(rawValue: pet.type) ?? .dog
            self.lostDate = pet.lostDate ?? Date()
            if let phone = pet.contactPhone, !phone.isEmpty { self.contactPhone = phone }
            if let name = pet.contactName, !name.isEmpty { self.contactName = name }
            if let lat = pet.latitude, let lon = pet.longitude {
                self.petLocation = SavedLocation(latitude: lat, longitude: lon, radius: 1, address: pet.location)
            }
            self.photos = pet.imageUrls.compactMap { URL(string: $0).map { .existing(url: $0) } }
        }
    }

    // MARK: - Public Methods

    func add(newImage: UIImage) {
        DispatchQueue.main.async {
            self.photos.append(.new(image: newImage))
        }
    }

    func removePhoto(at index: Int) {
        guard index < photos.count else { return }
        photos.remove(at: index)
    }

    func savePet() async {

        var missing: [String] = []
        if petName.trimmingCharacters(in: .whitespaces).isEmpty  { missing.append("кличку") }
        if petBreed.isEmpty                                       { missing.append("породу") }
        if petExternalSigns.trimmingCharacters(in: .whitespaces).isEmpty { missing.append("приметы") }
        if photos.isEmpty && !isEditing                          { missing.append("хотя бы одно фото") }
        if petLocation == nil && !isEditing                      { missing.append("местоположение") }

        if !missing.isEmpty {
            errorMessage = "Пожалуйста, укажите: \(missing.joined(separator: ", "))."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let finalImageUrls = try await withThrowingTaskGroup(of: String.self, returning: [String].self) { group in
                var existingUrls: [String] = []
                for photo in self.photos {
                    switch photo {
                    case .existing(let url):
                        existingUrls.append(url.absoluteString)
                    case .new(let image):
                        group.addTask {
                            let newUrl = try await StorageManager.shared.uploadPetImage(image: image, bucketName: "pet_images")
                            return newUrl
                        }
                    }
                }

                var newUrls: [String] = []
                for try await urlString in group {
                    newUrls.append(urlString)
                }
                return existingUrls + newUrls
            }

            let upsertData = UpsertPet(
                name: petName,
                breed: petBreed,
                description: petDescription,
                location: petLocation?.address ?? "Не указано",
                imageUrls: finalImageUrls,
                externalSigns: petExternalSigns.isEmpty ? nil : petExternalSigns,
                latitude: petLocation?.latitude,
                longitude: petLocation?.longitude,
                age: Int(petAge),
                type: petType.rawValue,
                contactPhone: contactPhone.isEmpty ? nil : contactPhone,
                contactName: contactName.isEmpty ? nil : contactName,
                lostDate: lostDate
            )

            if let pet = petToEdit {
                try await repository.updatePet(id: pet.id, upsertData)
            } else {
                let petID = try await repository.createPet(upsertData)
            }

            didSavePet = true

        } catch {
            if case APIError.server(let msg) = error {
                errorMessage = msg
            } else {
                errorMessage = "Не удалось сохранить анкету. Проверьте соединение и попробуйте снова."
            }
        }

        isLoading = false
    }
}

