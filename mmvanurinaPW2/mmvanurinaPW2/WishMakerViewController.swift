//
//  WishMakerViewController.swift
//  mmvanurinaPW2
//
//  Created by Maria Vanurina on 25.11.2023.
//

import UIKit
import UIKit

final class WishMakerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        configureUI()
    }
    
    enum Constants {
        static let titleFontSize: CGFloat = 32
        static let paragraphFontSize: CGFloat = 17
        static let stackViewSpacing: CGFloat = 20
        static let redSliderMinValue: Double = 0
        static let redSliderMaxValue: Double = 1
        static let stackViewCornerRadius: CGFloat = 20
        static let stackViewBottomConstraint: CGFloat = -40
        static let buttonHeight: CGFloat = 50
        static let buttonBottom: CGFloat = 40
        static let buttonSide: CGFloat = 25
        static let buttonText: String = "Вау"
        static let buttonRadius: CGFloat = 20
    }
    
    internal let h1: UILabel = {
        let h1 = UILabel()
        h1.translatesAutoresizingMaskIntoConstraints = false
        h1.text = "Прикол"
        h1.font = UIFont.boldSystemFont(ofSize: Constants.titleFontSize)
        h1.textColor = .white
        h1.backgroundColor = .darkGray
        return h1
    }()
    
    let sliderRed = CustomSlider(title: "красный", min: Constants.redSliderMinValue, max: Constants.redSliderMaxValue)
    let sliderBlue = CustomSlider(title: "синий", min: Constants.redSliderMinValue, max: Constants.redSliderMaxValue)
    let sliderGreen = CustomSlider(title: "зеленый", min: Constants.redSliderMinValue, max: Constants.redSliderMaxValue)
    
    private let addWishButton: UIButton = UIButton(type: .system)
    
    private func configureAddWishButton() {
        view.addSubview(addWishButton)
        addWishButton.setHeight(Constants.buttonHeight)
        addWishButton.pinBottom(to: view, Constants.buttonBottom)
        addWishButton.pinHorizontal(to: view, Constants.buttonSide)
        addWishButton.backgroundColor = .white
        addWishButton.setTitleColor(.systemPink, for: .normal)
        addWishButton.setTitle(Constants.buttonText, for: .normal)
        addWishButton.layer.cornerRadius = Constants.buttonRadius
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func addWishButtonPressed() {
        present(WishStoringViewController(), animated: true) //добавление одного экрана поверх другого
    }
    
    
    private func configureTitle() {
        view.addSubview(h1)
        NSLayoutConstraint.activate([
            h1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            h1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: WishMakerViewController.Constants.stackViewSpacing),
            h1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: WishMakerViewController.Constants.stackViewSpacing)
        ])
    }
    
    private func configureDescription() {
        let paragraph = UILabel()
        paragraph.translatesAutoresizingMaskIntoConstraints = false
        paragraph.text = "Удивительно, но эта штука работает. Я очень устала"
        paragraph.font = UIFont.systemFont(ofSize: WishMakerViewController.Constants.paragraphFontSize)
        paragraph.numberOfLines = 0
        paragraph.textColor = .white
        
        view.addSubview(paragraph)
        NSLayoutConstraint.activate([
            paragraph.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paragraph.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: WishMakerViewController.Constants.stackViewSpacing),
            paragraph.topAnchor.constraint(equalTo: h1.bottomAnchor, constant: WishMakerViewController.Constants.stackViewSpacing)
        ])
    }
    
    private func configureSliders() {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        view.addSubview(stack)
        stack.layer.cornerRadius = WishMakerViewController.Constants.stackViewCornerRadius
        stack.clipsToBounds = true
        
        for slider in [sliderRed, sliderBlue, sliderGreen] {
            stack.addArrangedSubview(slider)
        }
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: WishMakerViewController.Constants.stackViewSpacing),
            stack.bottomAnchor.constraint(equalTo: addWishButton.topAnchor, constant: WishMakerViewController.Constants.stackViewBottomConstraint)
        ])
        
        for slider in [sliderRed, sliderBlue, sliderGreen] {
            slider.valueChanged = { [weak self] value in
                let red = CGFloat(self?.sliderRed.slider.value ?? 0)
                let blue = CGFloat(self?.sliderBlue.slider.value ?? 0)
                let green = CGFloat(self?.sliderGreen.slider.value ?? 0)
                self?.view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            }
        }
    }
    
    final class CustomSlider: UIView {
        var valueChanged: ((Double) -> Void)?
        var slider = UISlider()
        var titleView = UILabel()
        
        init(title: String, min: Double, max: Double) {
            super.init(frame: .zero)
            titleView.text = title
            slider.minimumValue = Float(min)
            slider.maximumValue = Float(max)
            slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
            configureUI()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configureUI() {
            backgroundColor = .white
            translatesAutoresizingMaskIntoConstraints = false
            
            for view in [slider, titleView] {
                addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
            }
            
            NSLayoutConstraint.activate([
                titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
                titleView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.stackViewSpacing),
                titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.stackViewSpacing),
                slider.topAnchor.constraint(equalTo: titleView.bottomAnchor),
                slider.centerXAnchor.constraint(equalTo: centerXAnchor),
                slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.stackViewSpacing),
                slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.stackViewSpacing),
            ])
        }
        
        @objc
        private func sliderValueChanged() {
            valueChanged?(Double(slider.value))
        }
    }
    
    private func configureUI() {
        configureTitle()
        configureDescription()
        configureAddWishButton()
        configureSliders()
    }
}
