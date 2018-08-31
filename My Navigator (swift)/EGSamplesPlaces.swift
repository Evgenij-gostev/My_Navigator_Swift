//
//  EGSamplesPlaces.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 13.08.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation
import GooglePlaces


class EGSamplesPlaces: NSObject {
  
  private override init() { }
  static let shared = EGSamplesPlaces()

  private var _fetcher = GMSAutocompleteFetcher(bounds: nil, filter: nil)
  private var _placesClient = GMSPlacesClient.shared()
  private var _arrayPlace = [GMSPlace]()
  private var _predictions = [GMSAutocompletePrediction]()
  
  
//  private override init() {
//    super.init()
//    let filter = GMSAutocompleteFilter()
//    filter.type = .noFilter
    // Create the fetcher.
//    _fetcher = GMSAutocompleteFetcher(bounds: nil, filter: filter)
//    _fetcher?.delegate = self
//    _placesClient = GMSPlacesClient.shared()
//  }

// MARK: - Methods
  
  func setRequest(_ request: String) {
    _fetcher.delegate = self
    _fetcher.sourceTextHasChanged(request)
//    let fetcher = GMSAutocompleteFetcher(bounds: nil, filter: nil)
    
//    fetcher.sourceTextHasChanged(request)
  }
  
  func getSamplesPlaces() -> [GMSPlace] {
    return _arrayPlace
  }
  
}

// MARK: - GMSAutocompleteFetcherDelegate

extension EGSamplesPlaces: GMSAutocompleteFetcherDelegate {
  
  func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
//    _arrayPlace.removeAll()
//    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
//
//    for prediction in predictions {
//      self?._placesClient?.lookUpPlaceID(prediction.placeID!, callback: { (place, error) in
//        if let error = error {
//          print("Place Details error \(error.localizedDescription)")
//        }
//        if let place = place {
//          self?._arrayPlace.append(place)
////          print(place)
////          print(arrayPlace)
//        } else {
//          print("No place details for \(prediction.placeID!)")
//        }
//      })
//    }
//    }
    _predictions = predictions
    print("predictions: \(_predictions.count)")
    
  }

  func didFailAutocompleteWithError(_ error: Error) {
    print("ERROR: \(error.localizedDescription)")
  }

// MARK: - Private Methods
  
  func createArraySamplesPlaces() -> [GMSPlace] {
    _arrayPlace.removeAll()
    var arrayPlace = [GMSPlace]()
    
    DispatchQueue.global(qos: .userInteractive).sync {
      for prediction in self._predictions {
        self._placesClient.lookUpPlaceID(prediction.placeID!, callback: { (place, error) in
          if let error = error {
            print("Place Details error \(error.localizedDescription)")
          }
          if let place = place {
//              arrayPlace.append(place)
//            self.eree(place: place)
            print("l;l: \(place)")
//                      print(arrayPlace)
          } else {
            print("No place details for \(prediction.placeID!)")
          }
        })
      }
    }
//    DispatchQueue.main.async {
      print(self._arrayPlace)
      return self._arrayPlace
  }
  
  
  func eree(place: GMSPlace) {
    print(place)
    self._arrayPlace.append(place)
    print(self._arrayPlace.count)
  }
  
}


