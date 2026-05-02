//
//  FilterSheetViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 03.03.2026.
//
import UIKit

// MARK: - Model

struct PetFilter {
    var petType: String?
    var breed: String?
    var lostFrom: Date?
    var lostTo: Date?

    var isActive: Bool {
        petType != nil || breed != nil || lostFrom != nil || lostTo != nil
    }
}

// MARK: - Delegate

protocol FilterSheetDelegate: AnyObject {
    func filterSheetDidApply(_ filter: PetFilter)
}

// MARK: - FilterSheetViewController

final class FilterSheetViewController: UIViewController {

    weak var delegate: FilterSheetDelegate?
    private var currentFilter: PetFilter

    // MARK: - Breeds

    private static let dogBreeds = [
        "Дворняжка", "Австралийская овчарка", "Акита-ину", "Алабай",
        "Аляскинский маламут", "Американский бульдог", "Английский бульдог",
        "Басенджи", "Бассет-хаунд", "Бельгийская овчарка", "Бернский зенненхунд",
        "Бигль", "Бишон фризе", "Бобтейл", "Боксер", "Бордер-колли", "Бостон-терьер",
        "Брюссельский гриффон", "Бульмастиф", "Бультерьер", "Веймаранер",
        "Вельш-корги", "Вест-хайленд-уайт-терьер", "Грейхаунд", "Далматин",
        "Джек-рассел-терьер", "Доберман", "Золотистый ретривер", "Ирландский сеттер",
        "Йоркширский терьер", "Кавказская овчарка", "Кане-корсо", "Кокер-спаниель",
        "Колли", "Лабрадор-ретривер", "Мальтипу", "Мопс", "Немецкая овчарка",
        "Немецкий дог", "Папильон", "Пекинес", "Пинчер", "Питбуль",
        "Померанский шпиц", "Пти-брабансон", "Пудель", "Ризеншнауцер", "Ротвейлер",
        "Русский той-терьер", "Самоед", "Сенбернар", "Сиба-ину", "Сибирский хаски",
        "Стаффордширский терьер", "Такса", "Тибетский мастиф", "Уиппет",
        "Французский бульдог", "Цвергшнауцер", "Чау-чау", "Чихуахуа", "Шарпей",
        "Ши-тцу", "Шпиц", "Эрдельтерьер", "Ягдтерьер"
    ]

    private static let catBreeds = [
        "Беспородная", "Абиссинская", "Бенгальская", "Бирманская", "Бомбейская",
        "Британская короткошерстная", "Бурманская", "Девон-рекс", "Донской сфинкс",
        "Египетская мау", "Канадский сфинкс", "Корниш-рекс", "Курильский бобтейл",
        "Мейн-кун", "Невская маскарадная", "Ориентальная", "Персидская",
        "Петерболд", "Русская голубая", "Рэгдолл", "Селкирк-рекс",
        "Сиамская", "Сибирская", "Шотландская вислоухая", "Сомали", "Тайская",
        "Турецкая ангора", "Чаузи", "Шартрез", "Экзотическая короткошерстная"
    ]

    private var breedsForCurrentType: [String] {
        switch typeSegment.selectedSegmentIndex {
        case 1: return Self.catBreeds
        case 2: return Self.dogBreeds
        default: return []
        }
    }

    // MARK: - UI

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Фильтры"
        l.font = .systemFont(ofSize: 20, weight: .bold)
        return l
    }()

    private let resetButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Сбросить", for: .normal)
        b.setTitleColor(.systemRed, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 16)
        return b
    }()

    private let typeSegment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Все", "Кошка", "Собака"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        return sc
    }()

    private let breedButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 40)
        config.baseForegroundColor = .label
        config.titleAlignment = .leading
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 16)
            return outgoing
        }
        let b = UIButton(configuration: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .systemGray6
        b.layer.cornerRadius = 10
        return b
    }()

    private let breedChevron: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.up.chevron.down"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .secondaryLabel
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private lazy var breedSectionView: UIView = makeSectionView(
        title: "Порода",
        content: breedButtonContainer
    )

    private lazy var breedButtonContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(breedButton)
        v.addSubview(breedChevron)
        NSLayoutConstraint.activate([
            breedButton.topAnchor.constraint(equalTo: v.topAnchor),
            breedButton.bottomAnchor.constraint(equalTo: v.bottomAnchor),
            breedButton.leadingAnchor.constraint(equalTo: v.leadingAnchor),
            breedButton.trailingAnchor.constraint(equalTo: v.trailingAnchor),
            breedButton.heightAnchor.constraint(equalToConstant: 44),
            breedChevron.centerYAnchor.constraint(equalTo: breedButton.centerYAnchor),
            breedChevron.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -14),
            breedChevron.widthAnchor.constraint(equalToConstant: 16),
            breedChevron.heightAnchor.constraint(equalToConstant: 16)
        ])
        return v
    }()

    private let fromDatePicker: UIDatePicker = makeDatePicker()
    private let toDatePicker:   UIDatePicker = makeDatePicker()
    private let fromClearBtn: UIButton = makeClearBtn()
    private let toClearBtn:   UIButton = makeClearBtn()

    private var fromActive = false { didSet { updateClearBtns() } }
    private var toActive   = false { didSet { updateClearBtns() } }

    private lazy var mainStack: UIStackView = {
        let dateSection = makeSectionView(title: "Дата пропажи", content: makeDateStack())
        let sv = UIStackView(arrangedSubviews: [
            makeSectionView(title: "Тип животного", content: typeSegment),
            breedSectionView,
            dateSection
        ])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 20
        return sv
    }()

    private let applyButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Применить", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        b.backgroundColor = .accent
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 14
        return b
    }()

    // MARK: - Init

    init(currentFilter: PetFilter) {
        self.currentFilter = currentFilter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        populateFromFilter()
        wireActions()
    }

    // MARK: - Layout

    private func setupLayout() {
        let p: CGFloat = 20
        [titleLabel, resetButton, mainStack, applyButton].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: p),

            resetButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -p),

            mainStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: p),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -p),

            applyButton.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 28),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: p),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -p),
            applyButton.heightAnchor.constraint(equalToConstant: 54),
        ])
    }

    // MARK: - Wire

    private func wireActions() {
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)
        typeSegment.addTarget(self, action: #selector(typeChanged), for: .valueChanged)
        breedButton.addTarget(self, action: #selector(breedTapped), for: .touchUpInside)
        fromDatePicker.addTarget(self, action: #selector(fromChanged), for: .valueChanged)
        toDatePicker.addTarget(self, action: #selector(toChanged), for: .valueChanged)
        fromClearBtn.addTarget(self, action: #selector(clearFrom), for: .touchUpInside)
        toClearBtn.addTarget(self, action: #selector(clearTo), for: .touchUpInside)
    }

    // MARK: - Populate

    private func populateFromFilter() {
        switch currentFilter.petType {
        case "кошка":  typeSegment.selectedSegmentIndex = 1
        case "собака": typeSegment.selectedSegmentIndex = 2
        default:       typeSegment.selectedSegmentIndex = 0
        }
        updateBreedSection()
        breedButton.setTitle(currentFilter.breed ?? "Любая порода", for: .normal)

        if let d = currentFilter.lostFrom { fromDatePicker.date = d; fromActive = true }
        if let d = currentFilter.lostTo   { toDatePicker.date   = d; toActive   = true }
        updateClearBtns()
    }

    // MARK: - Helpers

    private func updateBreedSection() {
        let hasType = typeSegment.selectedSegmentIndex != 0
        breedSectionView.isHidden = !hasType
        if !hasType { breedButton.setTitle("Любая порода", for: .normal) }
    }

    private func updateClearBtns() {
        fromClearBtn.isHidden = !fromActive
        toClearBtn.isHidden   = !toActive
    }

    // MARK: - Actions

    @objc private func typeChanged() {
        breedButton.setTitle("Любая порода", for: .normal)
        currentFilter.breed = nil
        updateBreedSection()
    }

    @objc private func breedTapped() {
        let breeds = breedsForCurrentType
        guard !breeds.isEmpty else { return }
        let vc = BreedPickerViewController(breeds: breeds, selected: currentFilter.breed) { [weak self] sel in
            self?.breedButton.setTitle(sel ?? "Любая порода", for: .normal)
            self?.currentFilter.breed = sel
        }
        let nav = UINavigationController(rootViewController: vc)
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        present(nav, animated: true)
    }

    @objc private func fromChanged() {
        fromActive = true
        if toActive, fromDatePicker.date > toDatePicker.date {
            toDatePicker.date = fromDatePicker.date
        }
    }

    @objc private func toChanged() {
        toActive = true
        if fromActive, toDatePicker.date < fromDatePicker.date {
            fromDatePicker.date = toDatePicker.date
        }
    }

    @objc private func clearFrom() { fromActive = false; fromDatePicker.date = Date() }
    @objc private func clearTo()   { toActive   = false; toDatePicker.date   = Date() }

    @objc private func resetTapped() {
        typeSegment.selectedSegmentIndex = 0
        updateBreedSection()
        fromActive = false; toActive = false
        fromDatePicker.date = Date(); toDatePicker.date = Date()
    }

    @objc private func applyTapped() {
        let idx = typeSegment.selectedSegmentIndex
        let petType: String? = idx == 1 ? "кошка" : (idx == 2 ? "собака" : nil)
        let breedTitle = breedButton.title(for: .normal)
        let breed: String? = (breedTitle == "Любая порода" || breedTitle == nil) ? nil : breedTitle

        delegate?.filterSheetDidApply(PetFilter(
            petType:  petType,
            breed:    breed,
            lostFrom: fromActive ? fromDatePicker.date : nil,
            lostTo:   toActive   ? toDatePicker.date   : nil
        ))
        dismiss(animated: true)
    }

    // MARK: - Factory helpers

    private func makeSectionView(title: String, content: UIView) -> UIView {
        let titleLbl = UILabel()
        titleLbl.text = title
        titleLbl.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLbl.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [titleLbl, content])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }

    private func makeDateStack() -> UIView {
        let fromRow = makeDateRow(label: "С:", picker: fromDatePicker, clear: fromClearBtn)
        let toRow   = makeDateRow(label: "По:", picker: toDatePicker,   clear: toClearBtn)
        let sv = UIStackView(arrangedSubviews: [fromRow, toRow])
        sv.axis = .vertical
        sv.spacing = 10
        return sv
    }

    private func makeDateRow(label: String, picker: UIDatePicker, clear: UIButton) -> UIView {
        let lbl = UILabel()
        lbl.text = label
        lbl.font = .systemFont(ofSize: 16)
        lbl.textColor = .secondaryLabel
        lbl.setContentHuggingPriority(.required, for: .horizontal)

        let row = UIStackView(arrangedSubviews: [lbl, picker, clear])
        row.axis = .horizontal
        row.spacing = 8
        row.alignment = .center
        return row
    }

    private static func makeDatePicker() -> UIDatePicker {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .compact
        dp.maximumDate = Date()
        return dp
    }

    private static func makeClearBtn() -> UIButton {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        b.tintColor = .systemGray3
        b.isHidden = true
        b.setContentHuggingPriority(.required, for: .horizontal)
        return b
    }
}

// MARK: - BreedPickerViewController

final class BreedPickerViewController: UITableViewController {

    private let breeds: [String]
    private let selected: String?
    private let onSelect: (String?) -> Void

    init(breeds: [String], selected: String?, onSelect: @escaping (String?) -> Void) {
        self.breeds   = breeds
        self.selected = selected
        self.onSelect = onSelect
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Выберите породу"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отмена", style: .plain, target: self, action: #selector(cancelTapped)
        )
    }

    @objc private func cancelTapped() { dismiss(animated: true) }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        breeds.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "Любая порода"
            cell.textLabel?.textColor = .secondaryLabel
            cell.accessoryType = selected == nil ? .checkmark : .none
        } else {
            let breed = breeds[indexPath.row - 1]
            cell.textLabel?.text = breed
            cell.textLabel?.textColor = .label
            cell.accessoryType = breed == selected ? .checkmark : .none
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelect(indexPath.row == 0 ? nil : breeds[indexPath.row - 1])
        dismiss(animated: true)
    }
}
