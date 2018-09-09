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

  static let shared = EGSamplesPlaces()

  private var _fetcher: GMSAutocompleteFetcher?
  private var _arrayPlace = [GMSPlace]()
  private var _predictions = [GMSAutocompletePrediction]()
  
  
  private override init() {
    super.init()
    let filter = GMSAutocompleteFilter()
    filter.type = .establishment
    _fetcher = GMSAutocompleteFetcher(bounds: nil, filter: filter)
    _fetcher?.delegate = self
  }

// MARK: - Methods
  
  func setRequest(_ request: String) {
    _fetcher?.sourceTextHasChanged(request)
  }
  
  func getSamplesPlaces() -> [GMSPlace] {
    return _arrayPlace
  }
  
}

// MARK: - GMSAutocompleteFetcherDelegate

extension EGSamplesPlaces: GMSAutocompleteFetcherDelegate {
  
  func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
    _arrayPlace.removeAll()

    for prediction in predictions {
      GMSPlacesClient.shared().lookUpPlaceID(prediction.placeID!) { (place, error) in
        if let error = error {
          print("Place Details error \(error.localizedDescription)")
        }
        if let place = place {
          self._arrayPlace.append(place)
        } else {
          print("No place details for \(prediction.placeID!)")
        }
      }
    }
  }

  func didFailAutocompleteWithError(_ error: Error) {
    print("ERROR: \(error.localizedDescription)")
  }
  
}


