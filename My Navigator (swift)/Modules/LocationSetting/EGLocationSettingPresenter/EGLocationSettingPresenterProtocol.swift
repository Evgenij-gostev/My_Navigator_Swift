//
//  EGLocationSettingPresenterProtocol.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 08.09.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation
import GoogleMaps

protocol EGLocationSettingPresenterProtocol: class {
  var router: EGLocationSettingRouterProtocol! { set get }
  func startRecognizingText()
  func cancelTextRecognition()
  func closeSettingViewController()
  func searchForPlace(byAddress address: String)
  func selectMarker(byIndexPath indexPath: IndexPath,
                               myLocation: CLLocationCoordinate2D?)
}
