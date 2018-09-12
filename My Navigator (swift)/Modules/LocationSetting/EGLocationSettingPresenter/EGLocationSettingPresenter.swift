//
//  EGLocationSettingPresenter.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 02.09.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class EGLocationSettingPresenter: EGLocationSettingPresenterProtocol {
  
  var interactor: EGLocationSettingInteractorProtocol!
  var router: EGLocationSettingRouterProtocol!

  
  // MARK: - Router Methods

  func searchForPlace(byAddress address: String) {
    interactor.searchForPlace(byAddress: address)
  }
  
  // MARK: - Interactor Methods
  
  func startRecognizingText() {
    router.showSpeechView()
    interactor.startRecognitionText()
  }
  
  func selectMarker(byIndexPath indexPath: IndexPath,
                               myLocation: CLLocationCoordinate2D?) {
    interactor.selectMarker(byIndexPath: indexPath,
                             myLocation: myLocation)
  }
  
  func cancelTextRecognition() {
    router.hideSpeechView()
    interactor.stopRecognizingText()
  }
  
  func closeSettingViewController() {
    interactor.stopRecognizingText()
    router.closeSettingViewController()
  } 
}
