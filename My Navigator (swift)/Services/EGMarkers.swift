//
//  EGMarkers.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 14.08.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces


class EGMarkers {
  
  private var _marker: GMSMarker?

  init(withPlace place: GMSPlace?, andMyLocation myLocation:CLLocationCoordinate2D) {
    createMarker(fromPlace: place, andMyLocation: myLocation)
  }

  init(withCoordinate coordinate: CLLocationCoordinate2D) {
    createMarker(fromCoordinate: coordinate)
  }

  func getMarker() -> GMSMarker {
    return _marker!
  }

// MARK: - Private Metods
  
  func createMarker(fromPlace place: GMSPlace?,
           andMyLocation myLocation: CLLocationCoordinate2D) {
    if place == nil && myLocation.latitude != 0 {
      _marker = GMSMarker.init(position: myLocation)
      _marker?.snippet = "Мое местоположение"
    } else {
      _marker = GMSMarker.init(position: place!.coordinate)
      _marker?.snippet = place?.formattedAddress
    }
  }
  
  func createMarker(fromCoordinate coordinate: CLLocationCoordinate2D) {
    _marker = GMSMarker.init(position: coordinate)
    EGServerManager.shared.getAddress(forCoordinate: coordinate,
       onSuccess: { (address) in
        DispatchQueue.main.async {
          self._marker?.snippet = address
        }
    }) { (error) in
      print("ERROR: \(error)")
    }
  }
}

