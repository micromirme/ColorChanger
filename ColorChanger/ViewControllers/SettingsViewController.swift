//
//  ViewController.swift
//  ColorChanger
//
//  Created by Mac on 26.03.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var colorRect: UIView!

    @IBOutlet var colorSliders: [UISlider]!
    @IBOutlet var colorsTextsFields: [UITextField]!
    @IBOutlet var colorsTextsLabels: [UILabel]!

    @IBOutlet var doneButton: UIButton!

    var currenMainColor: CGColor!
    var delegate: SettingViewControllerDelegate!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        colorsTextsFields.forEach {
            $0.delegate = self
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        prepareUi()
    }

    @IBAction func changeColorValue(_ sender: UISlider) {
        switch sender.tag {
        case 0:
            changeColorRect(color: prepareColor())
        case 1:
            changeColorRect(color: prepareColor())
        default:
            changeColorRect(color: prepareColor())
        }
        updateTextsFieldsValues()
        updateColorTextLabels()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if view.frame.origin.y == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.frame.origin.y = 0 - keyboardFrame.height / 2
            })
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.frame.origin.y = 0
            })
        }
    }
}

extension SettingsViewController {
    private func prepareUi() {
        guard let colorComponents = currenMainColor.components else { return }

        if colorComponents.first == 1 {
            colorSliders.forEach {
                $0.value = Float(1)
            }
        } else if colorComponents.first == 0 {
            colorSliders.forEach {
                $0.value = Float(0)
            }
        } else {
            for (slider, colorComponent) in zip(colorSliders, colorComponents) {
                slider.value = Float(colorComponent)
            }
        }

        colorsTextsFields.forEach {
            $0.addDoneButtonOnKeyboard()
        }

        changeColorRect(color: prepareColor())
        updateTextsFieldsValues()
        updateColorTextLabels()
    }

    private func prepareColor() -> UIColor {
        let sliderValues = colorSliders.map { $0.value }
        return UIColor(
            red: CGFloat(sliderValues[0]),
            green: CGFloat(sliderValues[1]),
            blue: CGFloat(sliderValues[2]),
            alpha: 1
        )
    }

    private func updateTextsFieldsValues() {
        for (textField, slider) in zip(colorsTextsFields, colorSliders) {
            textField.text = String(format: "%.2f", slider.value)
        }
    }

    private func updateColorTextLabels() {
        for (label, slider) in zip(colorsTextsLabels, colorSliders) {
            label.text = String(format: "%.2f", slider.value)
        }
    }

    private func changeColorRect(color: UIColor) {
        colorRect.backgroundColor = color
        colorRect.layer.shadowColor = color.cgColor
        colorRect.layer.shadowRadius = 30
        colorRect.layer.shadowOpacity = 1
        delegate.setNewViewBackground(with: color)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        for (label, textFromField) in zip(colorsTextsLabels, colorsTextsFields) {
            if textFromField.hasText {
                label.text = textFromField.text ?? "0.0"
            } else {
                label.text = "0.0"
            }
        }

        for (slider, textFromField) in zip(colorSliders, colorsTextsFields) {
            let value = Float("\(textFromField.text ?? "0.0")") ?? 0.0
            slider.value = Float(value)
        }
        changeColorRect(color: prepareColor())
    }
}

extension UITextField {
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let actionDone: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(hideKeyboard))

        doneToolbar.items = [spacer, actionDone]
        doneToolbar.sizeToFit()

        inputAccessoryView = doneToolbar
    }

    @objc func hideKeyboard() {
        resignFirstResponder()
    }
}
