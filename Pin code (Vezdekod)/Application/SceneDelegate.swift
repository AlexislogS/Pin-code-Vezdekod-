//
//  SceneDelegate.swift
//  Pin code (Vezdekod)
//
//  Created by Alex Yatsenko on 24.04.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    let vc: UIViewController
    
    if AppSettings.shared.pin == nil {
      vc = storyboard.instantiateViewController(withIdentifier: String(describing: MainViewController.self))
    } else {
      vc = storyboard.instantiateViewController(withIdentifier: String(describing: PinViewController.self))
    }
    window?.tintColor = .label
    window?.rootViewController = vc
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    let pinVC = storyboard.instantiateViewController(withIdentifier: String(describing: PinViewController.self))
    window?.rootViewController = pinVC
  }
}

