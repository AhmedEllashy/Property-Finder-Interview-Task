//
//  SettingsViewController.swift
//  Tahudu
//
//  Created by Ahmad Ellashy on 19/10/2026.
//

import UIKit

/// A single row on the Settings screen. Adding a row means adding a case here and placing it in `SettingsViewController.sections`.
private enum SettingsRow {
    case language
    case country
    case notifications
    case about
    case feedback

    var title: String {
        switch self {
        case .language: return "Language"
        case .country: return "Country"
        case .notifications: return "Notifications"
        case .about: return "About"
        case .feedback: return "Feedback"
        }
    }

    var systemImageName: String {
        switch self {
        case .language: return "textformat"
        case .country: return "globe"
        case .notifications: return "app.badge"
        case .about: return "info.circle"
        case .feedback: return "text.bubble"
        }
    }

    var accessibilityIdentifier: String {
        "SettingsCell_\(self)"
    }
}

class SettingsViewController: UITableViewController {
    private static let cellIdentifier = "SettingsCell"

    private let sections: [[SettingsRow]] = [
        [.language, .country, .notifications],
        [.about, .feedback]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
    }

    override func numberOfSections(in _: UITableView) -> Int {
        sections.count
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)

        var content = UIListContentConfiguration.valueCell()
        content.image = UIImage(systemName: row.systemImageName)
        content.text = row.title
        content.secondaryText = detailText(for: row)

        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        cell.accessibilityIdentifier = row.accessibilityIdentifier
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch sections[indexPath.section][indexPath.row] {
        case .language: openSystemSettings()
        case .country: showCountrySelectionScreen()
        case .notifications: showNotificationScreen()
        case .about: showAboutScreen()
        case .feedback: showFeedbackScreen()
        }
    }

    private func detailText(for row: SettingsRow) -> String? {
        switch row {
        case .language:
            return Bundle.main.preferredLocalizations.first.flatMap(Locale.current.localizedString(forLanguageCode:))
        case .country:
            return "United Arab Emirates"
        case .notifications, .about, .feedback:
            return nil
        }
    }
}

// ===============================

/// NO NEED TO TUOCH THIS!!!
extension SettingsViewController {
    private func openSystemSettings() {
        print(#function)
    }

    private func showCountrySelectionScreen() {
        print(#function)
    }

    private func showNotificationScreen() {
        print(#function)
    }

    private func showAboutScreen() {
        print(#function)
    }

    private func showFeedbackScreen() {
        print(#function)
    }
}
