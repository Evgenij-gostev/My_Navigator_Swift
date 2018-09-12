//
//  EGMapPresenter.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 02.09.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import UIKit
import GoogleMaps


class EGMapPresenter: EGMapPresenterProtocol {
  
  var interactor: EGMapInteractorProtocol!
  var router: EGMapRouterProtocol!
  
  
  // MARK: - Router Methods
  
  func configure() {
    interactor.configure()
    router.configureView()
  }
  
  func scaling(tag: Int) {
    router.scaling(tag: tag)
  }
  
  func buildRoute() {
    interactor.buildRoute()
  }
  
  func cancelRoute() {
    interactor.cancelRoute()
  }
  
  func choiceOfLocation(_ coordinate: CLLocationCoordinate2D) {
    cancelRoute()
    let markers = EGMarkers(withCoordinate: coordinate)
    let marker = markers.getMarker()
    let message = "Выбор старта или финиша"
    let alert = UIAlertController(title: nil,
                                  message: message,
                                  preferredStyle: .alert)
    let startButton = UIAlertAction(title: "Старт", style: .default) { (_) in
      self.interactor.addMarker(marker,
                                andLocationType: EGLocationType.OriginLocationType)
    }
    let finishButton = UIAlertAction(title: "Финиш", style: .default) { (_) in
      self.interactor.addMarker(marker,
                                andLocationType: EGLocationType.DestinationLocationType)
    }
    alert.addAction(startButton)
    alert.addAction(finishButton)
    router.presentController(alert)
  }
  
  func showSimpleAlert(withMessege message: String, isOneButton: Bool) {
    let alert = UIAlertController(title: nil,
                                  message: message,
                                  preferredStyle: .actionSheet)
    if !isOneButton {
      let yesButton = UIAlertAction(title: "OK", style: .default) { (_) in
        self.interactor.buildRoute()
        self.interactor.saveRoute()
      }
      alert.addAction(yesButton)
    }
    let noButton = UIAlertAction(title: "Отмена", style: .default, handler: nil)
    alert.addAction(noButton)
    router.presentController(alert)
  }
  
  func startLocationSettingViewController(withLocationType locationType: EGLocationType) {
    interactor.cancelRoute()
    let locationSettingVC: EGLocationSettingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EGLocationSettingViewController") as! EGLocationSettingViewController
    locationSettingVC.modalTransitionStyle = .crossDissolve
    locationSettingVC.modalPresentationStyle = .custom
    locationSettingVC.isMyLocationEnabled = router.isMyLocationEnabled
    locationSettingVC.myLocation = router.getMyLocation()
    locationSettingVC.locationType = locationType
    router.presentController(locationSettingVC)
    locationSettingVC.delegate = interactor.self as? EGLocationSettingViewControllerDelegate
  }
}
