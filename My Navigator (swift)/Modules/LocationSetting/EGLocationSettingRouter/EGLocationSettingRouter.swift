//
//  EGLocationSettingRouter.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 02.09.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class EGLocationSettingRouter: EGLocationSettingRouterProtocol {
  
  weak var viewController: EGLocationSettingViewController!
  
  init(viewController: EGLocationSettingViewController) {
    self.viewController = viewController
  }
  
  func configureView() {
    viewController.tableView.layer.cornerRadius = 5

    viewController.speechView.layer.cornerRadius = 5
    viewController.speechView.layer.shadowColor = UIColor.black.cgColor
    viewController.speechView.layer.shadowOffset = CGSize(width: 3, height: 3)
    viewController.speechView.layer.shadowOpacity = 0.7
    viewController.speechView.layer.shadowRadius = 4.0

    hideSpeechView()
  }
  
  func showSpeechView() {
    viewController.speechView.isHidden = false
  }
  
  func hideSpeechView() {
    viewController.speechView.isHidden = true
  }
  
  func closeSettingViewController() {
    viewController.dismiss(animated: true, completion: nil)
  }
  
  func setRecognizedTextLabel(_ text: String) {
    viewController.recognizedTextLabel.text = text
  }
  
  func setSearchTextField(_ text: String) {
    viewController.searchTextField.text = text
  }
  
  func setArrayPlace(_ arrayPlace: [GMSPlace]) {
    viewController._arrayPlace = arrayPlace
  }
  
  func reloadDataTableView() {
    viewController.tableView.reloadData()
  }
  
  func autocompleteWithMarker(_ marker: GMSMarker) {
    viewController.delegate?.autocompleteWithMarker(marker, andLocationType: viewController.locationType!)
  }
  
}
