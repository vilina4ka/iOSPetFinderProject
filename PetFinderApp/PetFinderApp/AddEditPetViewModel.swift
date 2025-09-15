//
//  AddEditPetViewModel.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 12.09.2025.
//

import UIKit
import Combine
import Supabase

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
        case name, breed, description, location, imageUrls, age, type
        case externalSigns, latitude, longitude
        case contactPhone, contactName, lostDate
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
    @Published var petCharacter: String = ""
    @Published var petExternalSigns: String = ""
    @Published var contactPhone: String = ""
    @Published var contactName: String = ""
    @Published var petLocation: SavedLocation?
    
    // MARK: - UI
    @Published var photos: [PetPhoto] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didSavePet = false
    
    private let petToEdit: Pet?
    
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
    
    init(petToEdit: Pet? = nil) {
        self.petToEdit = petToEdit
        
        if let pet = petToEdit {
            self.petName = pet.name
            self.petBreed = pet.breed
            self.petCharacter = pet.description
            self.petExternalSigns = pet.externalSigns ?? ""
            self.petAge = pet.age != nil ? "\(pet.age!)" : ""
            self.petType = PetType(rawValue: pet.type) ?? .dog
            self.lostDate = pet.lostDate ?? Date()
            self.contactPhone = pet.contactPhone ?? ""
            self.contactName = pet.contactName ?? ""
            if let lat = pet.latitude, let lon = pet.longitude {
                self.petLocation = SavedLocation(latitude: lat, longitude: lon, radius: 1, address: pet.location)
            }
            
            self.photos = pet.imageUrls.compactMap { urlString in
                if let url = URL(string: urlString) {
                    return .existing(url: url)
                }
                return nil
            }
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
        guard !petName.isEmpty, !petBreed.isEmpty, petLocation != nil else {
            errorMessage = "Пожалуйста, укажите кличку, породу и местоположение."
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
                            return newUrl.absoluteString
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
                description: petCharacter,
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
                try await supabase.from("Pets").update(upsertData).eq("id", value: pet.id).execute()
            } else {
                try await supabase.from("Pets").insert(upsertData).execute()
            }
            
            didSavePet = true
            
        } catch {
            errorMessage = error.localizedDescription
            print("🔴 Ошибка сохранения анкеты: \(error)")
        }
        
        isLoading = false
    }
}
