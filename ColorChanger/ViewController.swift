//
//  ViewController.swift
//  ColorChanger
//
//  Created by Mac on 26.03.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var colorRect: UIView!
    @IBOutlet var controlPanel: UIView!

    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!

    @IBOutlet var redValueText: UILabel!
    @IBOutlet var greenValueText: UILabel!
    @IBOutlet var blueValueText: UILabel!

    private var currentRedValue: Float = 0.0
    private var currentGreenValue: Float = 0.0
    private var currentBlueValue: Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        redValueText.text = String(redSlider.value)
        greenValueText.text = String(greenSlider.value)
        blueValueText.text = String(blueSlider.value)

        currentRedValue = redSlider.value
        currentGreenValue = greenSlider.value
        currentBlueValue = blueSlider.value

        changeColorRect()
    }

    override func viewWillLayoutSubviews() {
        controlPanel.layer.cornerRadius = 10
        colorRect.layer.cornerRadius = 10
    }

    @IBAction func changeColorValue(_ sender: UISlider) {
        switch sender {
        case redSlider:
            currentRedValue = sender.value
            redValueText.text = String(format: "%.2f", sender.value)
            changeColorRect()
        case greenSlider:
            currentGreenValue = sender.value
            greenValueText.text = String(format: "%.2f", sender.value)
            changeColorRect()
        case blueSlider:
            currentBlueValue = sender.value
            blueValueText.text = String(format: "%.2f", sender.value)
            changeColorRect()
        default:
            break
        }
    }

    private func changeColorRect() {
        let color = UIColor(
            red: CGFloat(currentRedValue),
            green: CGFloat(currentGreenValue),
            blue: CGFloat(currentBlueValue),
            alpha: 1
        )

        colorRect.backgroundColor = color
        colorRect.layer.shadowColor = color.cgColor
        colorRect.layer.shadowRadius = 30
        colorRect.layer.shadowOpacity = 1
    }
}
