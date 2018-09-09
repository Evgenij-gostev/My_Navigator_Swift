//
//  EGLocationSettingProtocols.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 02.09.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces








protocol EGLocationSettingRouterProtocol: class {
  func configureView()
  func showSpeechView()
  func hideSpeechView()
  func closeSettingViewController()
  func setRecognizedTextLabel(_ text: String)
  func setSearchTextField(_ text: String)
  func setArrayPlace(_ arrayPlace: [GMSPlace])
  func reloadDataTableView()
  func autocompleteWithMarker(_ marker: GMSMarker)
}

// Mark: - Delegates

protocol EGLocationSettingViewControllerDelegate: class {
  func autocompleteWithMarker(_ marker: GMSMarker, andLocationType locationType: EGLocationType)
}
