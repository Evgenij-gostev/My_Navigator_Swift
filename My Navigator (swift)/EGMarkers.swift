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
  
  private var _marker: GMSMarker? = nil
  
  
  init(withPlace place: GMSPlace?,
                     andMyLocation myLocation:CLLocationCoordinate2D) {
    createMarkerFromPlace(place, andMyLocation: myLocation)
  }
  
  init(withCoordinate coordinate: CLLocationCoordinate2D) {
    createMarkerFromCoordinate(coordinate)
  }

  
  func getMarker() -> GMSMarker {
    return _marker!
  }

  
// MARK: - Private Metods
  
  private func createMarkerFromPlace(_ place: GMSPlace?, andMyLocation myLocation: CLLocationCoordinate2D) {
    if place == nil && myLocation.latitude != 0 {
      _marker = GMSMarker.init(position: myLocation)
      _marker?.snippet = "Мое местоположение"
    } else {
      _marker = GMSMarker.init(position: place!.coordinate)
      let arrayString = place?.formattedAddress?.components(separatedBy: ", ")
      var address = ""
      for string in arrayString! {
        address += "\(string) \n"
      }
      _marker?.snippet = address
    }
  }
  
  private func createMarkerFromCoordinate(_ coordinate: CLLocationCoordinate2D) {
    _marker = GMSMarker.init(position: coordinate)
    EGServerManager.shared.getAddressForCoordinate(coordinate,
       onSuccess: { (address) in
        self._marker?.snippet = address
    }) { (error) in
      print("ERROR: \(error)")
    }
  }
  
 
}

