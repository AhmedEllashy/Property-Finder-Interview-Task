//
//  SettingsView.swift
//  Tahudu
//

import SwiftUI

struct SettingsView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let settingsViewController = SettingsViewController(style: .insetGrouped)
        settingsViewController.title = "My Account"

        let navigationController = UINavigationController(rootViewController: settingsViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
