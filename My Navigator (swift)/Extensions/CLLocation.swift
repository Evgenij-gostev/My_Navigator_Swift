//
//  CLLocation.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 18.08.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation
import GoogleMaps

extension CLLocation {
  
  static func EGCLLocationNoNullCoordinate(location: CLLocationCoordinate2D?) -> Bool {
    if let location = location {
      if location.latitude != 0 && location.longitude != 0 {
        return true
      }
    }
    return false
  }
  
}
