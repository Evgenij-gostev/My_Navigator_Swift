//
//  EGMapPresenterProtocol.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 08.09.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation
import GoogleMaps

protocol EGMapPresenterProtocol: class {
  var router: EGMapRouterProtocol! { set get }
  func configure()
  func scaling(tag: Int)
  func buildRoute()
  func cancelRoute()
  func choiceOfLocation(_ coordinate: CLLocationCoordinate2D)
  func showSimpleAlert(withMessege message: String, isOneButton: Bool)
  func startLocationSettingViewController(withLocationType locationType: EGLocationType)
  func startQueryHistoryViewController()
}
