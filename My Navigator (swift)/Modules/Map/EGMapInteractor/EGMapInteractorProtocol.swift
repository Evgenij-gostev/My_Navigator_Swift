//
//  EGMapInteractorProtocol.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 08.09.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation
import GoogleMaps

protocol EGMapInteractorProtocol: class {
  func configure()
  func buildRoute()
  func cancelRoute()
  func addMarker(_ marker: GMSMarker, andLocationType locationType: EGLocationType)
  func saveRoute()
}
