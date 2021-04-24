//
//  ViewController.swift
//  Pin code (Vezdekod)
//
//  Created by Alex Yatsenko on 24.04.2021.
//

import UIKit
import LocalAuthentication

final class PinViewController: UIViewController {
  
  @IBOutlet private var dotViews: [UIView]! {
    didSet {
      dotViews.forEach { $0.layer.cornerRadius = $0.bounds.midX }
    }
  }
  @IBOutlet private weak var deleteButton: UIButton!
  @IBOutlet private weak var authButton: UIButton!
  
  @IBOutlet private weak var statePinLabel: UILabel! {
    didSet {
      if isChange{
        statePinLabel.text = "Change pin code"
      } else if AppSettings.shared.pin != nil {
        statePinLabel.text = "Emter pin code"
      }
    }
  }
  
  var isChange = false
  private var typedPass = ""
  private var repeatValue = ""
  private var isRepeat = false
  private let context = LAContext()
  
  @IBAction private func authButtonPressed() {
    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                           localizedReason: "Please allow to continue with Touch ID") { (isSuccess, error) in
      if isSuccess, error == nil {
        DispatchQueue.main.async {
          self.showMainScreen()
        }
      }
    }
  }
  
  @IBAction private func touchDigit(_ sender: UIButton) {
    if let digit = sender.currentTitle {
      typedPass.append(digit)
      dotViews.enumerated().first(where: { $0.offset + 1 == typedPass.count })?.element.backgroundColor = .systemTeal
      if typedPass.count == 4 {
        if AppSettings.shared.pin != nil, !isChange {
          if AppSettings.shared.pin == typedPass {
            statePinLabel.text = "Access granted"
            animateDots()
          } else {
            statePinLabel.text = "Try again"
            typedPass = ""
            animateDots(isError: true)
          }
        } else if isRepeat {
          if repeatValue == typedPass {
            AppSettings.shared.pin = typedPass
            if isChange {
              dismiss(animated: true)
            } else {
              animateDots()
            }
          } else {
            animateDots(isError: true)
            statePinLabel.text = "Codes do not match"
            typedPass = ""
          }
        } else {
          isRepeat = true
          repeatValue = typedPass
          typedPass = ""
          dotViews.forEach { $0.backgroundColor = .systemGray3 }
          statePinLabel.text = "Repeat please"
        }
      }
    }
    if typedPass.isEmpty {
      deleteButton.alpha = 0
    } else {
      deleteButton.alpha = 1
    }
  }
  
  @IBAction func deleteButtonPressed() {
    typedPass = String(typedPass.dropLast())
    dotViews.enumerated().first(where: { $0.offset == typedPass.count })?.element.backgroundColor = .systemGray3
    
    if typedPass.isEmpty {
      deleteButton.alpha = 0
    }
  }
  
  private func animateDots(isError: Bool = false) {
    UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseIn) { [weak self] in
      self?.view.isUserInteractionEnabled = false
      self?.dotViews.forEach {
        if isError {
          $0.backgroundColor = .systemRed
        }
        $0.transform = .init(scaleX: 1.2, y: 1.2)
      }
    } completion: { [weak self] _ in
      self?.dotViews.forEach {
        $0.backgroundColor = .systemGray3
        $0.transform = .identity
      }
      self?.view.isUserInteractionEnabled = true
      if !isError {
        self?.showMainScreen()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil), AppSettings.shared.pin != nil, !isChange {
      if context.biometryType == .touchID {
        authButton.setImage(UIImage(systemName: "touchid"), for: .normal)
      }
      authButton.alpha = 1
    }
  }
  
  private func showMainScreen() {
    if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
       let mainVC = storyboard?.instantiateViewController(withIdentifier: String(describing: MainViewController.self)) {
      window.rootViewController = mainVC
    }
  }
  
}

