//
//  AppSettings.swift
//  Pin code (Vezdekod)
//
//  Created by Alex Yatsenko on 24.04.2021.
//

import Foundation

final class AppSettings {
  
  private enum StorageKeys: String {
    case pin
  }
  
  static let shared = AppSettings()
  
  private let storage = UserDefaults.standard
  
  var pin: String? {
    get {
      storage.string(forKey: StorageKeys.pin.rawValue)
    }
    set {
      storage.setValue(newValue, forKey: StorageKeys.pin.rawValue)
      storage.synchronize()
    }
  }
  
  private init() {}
}
