//
//  MainScreenViewController.swift
//  ColorChanger
//
//  Created by Mac on 09.04.2021.
//

import UIKit

protocol SettingViewControllerDelegate {
    func setNewViewBackground(with color: UIColor)
}

class MainScreenViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVc = segue.destination as? SettingsViewController else { return }
        settingsVc.currenMainColor = view.layer.backgroundColor
        settingsVc.delegate = self
    }
    
    @IBAction func unwindTo(_ unwindSegue: UIStoryboardSegue) {}
}

extension MainScreenViewController : SettingViewControllerDelegate {
    func setNewViewBackground(with color: UIColor) {
        view.layer.backgroundColor = color.cgColor
    }
}
