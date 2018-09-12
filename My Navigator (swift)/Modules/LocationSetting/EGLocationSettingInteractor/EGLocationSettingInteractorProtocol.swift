//
//  EGLocationSettingInteractorProtocol.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 08.09.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation
import GoogleMaps

protocol EGLocationSettingInteractorProtocol: class {
  func startRecognitionText()
  func stopRecognizingText()
  func searchForPlace(byAddress address: String)
  func selectMarker(byIndexPath indexPath: IndexPath,
                               myLocation: CLLocationCoordinate2D?)
}
