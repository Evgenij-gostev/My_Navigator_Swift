//
//  EGRouteData.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 18.08.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation
import GoogleMaps


protocol EGRouteDataDelegate: class {
  func getRouteDataWithPolyline(_ polyline: GMSPolyline?,
                                distance: String?,
                                duration: String?,
                                messageError: String?)
}


class EGRouteData {
  
  weak var delegate: EGRouteDataDelegate?

  private var _polyline: GMSPolyline? = nil
  private var _distance: String? = nil
  private var _duration: String? = nil
  private var _messageError: String? = nil

  
  init(withOrigin originLocation: CLLocationCoordinate2D,
       andDestination destinationLocation: CLLocationCoordinate2D) {
    routeDataFromServerAndTheRouteWith(origin: originLocation,
                                       andDestination: destinationLocation)
  }

  
// MARK: - Private Metods
  
  private func routeDataFromServerAndTheRouteWith(origin originLocation: CLLocationCoordinate2D, andDestination destinationLocation: CLLocationCoordinate2D) {
    
    EGServerManager.shared.getRouteWithOrigin(originLocation, andDestination: destinationLocation, onSuccess: { (routeInformation) in
      if let legs = routeInformation?.routes.first?.legs.first {
        self._distance = legs.distance.text
        self._duration = legs.duration.text
        
        let path = GMSMutablePath()
        let arraySteps = legs.steps
        for step in arraySteps {
          let point = step.polyline.points
          let polyLinePath = GMSPath(fromEncodedPath: point)
          for index in 0..<polyLinePath!.count() {
            path.add(polyLinePath!.coordinate(at: index))
          }
        }
        DispatchQueue.main.sync {
          self.createPolylineFromPath(path)
        }
        
      } else {
        self._messageError = "Маршрут невозможно построить:("
        self.callingTheDelegateMethod()
      }
    }) { (error) in
      self._messageError = "error = \(error)"
      self.callingTheDelegateMethod()
    }
    
  }
  
  private func createPolylineFromPath(_ path: GMSMutablePath) {
    _polyline = GMSPolyline(path: path)
    _polyline?.strokeColor = UIColor.orange
    _polyline?.strokeWidth = 5.0
    callingTheDelegateMethod()
  }
  
  private func callingTheDelegateMethod() {
    self.delegate?.getRouteDataWithPolyline(_polyline,
                                            distance: _distance,
                                            duration: _duration,
                                            messageError: _messageError)
  }

}




