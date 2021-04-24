//
//  MainViewController.swift
//  Pin code (Vezdekod)
//
//  Created by Alex Yatsenko on 24.04.2021.
//

import UIKit

final class MainViewController: UIViewController {
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
      if AppSettings.shared.pin == nil {
        self?.showAlert(title: "Please create pin code") {
          self?.performSegue(withIdentifier: "showPin", sender: nil)
        }
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "changePin",
       let pinVC = segue.destination as? PinViewController {
      pinVC.isChange = true
    }
  }
  
  private func showAlert(title: String? = nil,
                         message: String? = nil,
                         completion: (() -> Void)? = nil) {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK",
                                  style: .default,
                                  handler: { _ in
                                    completion?()
                                  }))
    present(alert, animated: true)
  }
}
