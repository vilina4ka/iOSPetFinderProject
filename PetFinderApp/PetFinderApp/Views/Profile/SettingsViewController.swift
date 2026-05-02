//
//  SettingsViewController.swift
//  PetFinderApp
//
//  Created by Вилина Ольховская on 10.04.2026.
//

import UIKit
import UserNotifications

final class SettingsViewController: UIViewController {

    // MARK: - UI

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        return tv
    }()

    private let notificationsSwitch: UISwitch = {
        let sw = UISwitch()
        return sw
    }()

    // MARK: - Sections

    private enum Section: Int, CaseIterable {
        case notifications
        case about
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        view.backgroundColor = .systemGroupedBackground

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        checkNotificationStatus()
        notificationsSwitch.addTarget(self, action: #selector(notificationsSwitchChanged), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkNotificationStatus()
    }

    // MARK: - Notifications

    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.notificationsSwitch.isOn = settings.authorizationStatus == .authorized
            }
        }
    }

    @objc private func notificationsSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                DispatchQueue.main.async {
                    sender.isOn = granted
                    if !granted {
                        self?.showSettingsAlert()
                    }
                }
            }
        } else {
            sender.isOn = true
            showSettingsAlert()
        }
    }

    private func showSettingsAlert() {
        let alert = UIAlertController(
            title: "Уведомления",
            message: "Для изменения разрешений перейдите в Настройки → Лапки → Уведомления",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .notifications: return 1
        case .about:         return 2
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .notifications: return "Уведомления"
        case .about:         return "О приложении"
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none

        switch Section(rawValue: indexPath.section)! {

        case .notifications:
            var content = cell.defaultContentConfiguration()
            content.text = "Разрешить уведомления"
            content.image = UIImage(systemName: "bell.fill")
            content.imageProperties.tintColor = .systemBlue
            cell.contentConfiguration = content
            cell.accessoryView = notificationsSwitch

        case .about:
            var content = cell.defaultContentConfiguration()
            if indexPath.row == 0 {
                let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
                let build   = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
                content.text = "Версия"
                content.image = UIImage(systemName: "info.circle")
                content.imageProperties.tintColor = .systemGray
                cell.accessoryView = nil
                cell.selectionStyle = .none
                let valueLabel = UILabel()
                valueLabel.text = "\(version) (\(build))"
                valueLabel.textColor = .secondaryLabel
                valueLabel.font = .systemFont(ofSize: 15)
                valueLabel.sizeToFit()
                cell.accessoryView = valueLabel
            } else {
                content.text = "Разработчик"
                content.image = UIImage(systemName: "person.fill")
                content.imageProperties.tintColor = .systemGray
                let valueLabel = UILabel()
                valueLabel.text = "Вилина Ольховская"
                valueLabel.textColor = .secondaryLabel
                valueLabel.font = .systemFont(ofSize: 15)
                valueLabel.sizeToFit()
                cell.accessoryView = valueLabel
            }
            cell.contentConfiguration = content
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
