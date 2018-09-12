//
//  EGRouteData.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 18.08.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation
import GoogleMaps


class EGRouteData {
  
  var delegateCall = DelegatedCall<(polyline: GMSPolyline?, distance: String?,
                                   duration: String?, messageError: String?)>()
  
  func routeDataFromServerAndTheRoute(withOrigin originLocation: CLLocationCoordinate2D,
                          andDestination destinationLocation: CLLocationCoordinate2D) {
    EGServerManager.shared.getRoute(withOrigin: originLocation,
                                andDestination: destinationLocation,
                                     onSuccess: { (routeInformation) in
      if let legs = routeInformation?.routes.first?.legs.first {
        let distance = legs.distance.text
        let duration = legs.duration.text
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
          let polyline = self.createPolyline(fromPath: path)
          self.delegateCall.callback?((polyline, distance, duration, nil))
        }
      } else {
        let messageError = "Маршрут невозможно построить:("
        self.delegateCall.callback?((nil, nil, nil, messageError))
      }
    }) { (error) in
      let messageError = "error = \(error)"
      self.delegateCall.callback?((nil, nil, nil, messageError))
    }
  }
  
  // MARK: - Private Metods
  
  private func createPolyline(fromPath path: GMSMutablePath) -> GMSPolyline {
    let polyline = GMSPolyline(path: path)
    polyline.strokeColor = UIColor.orange
    polyline.strokeWidth = 5.0
    return polyline
  }
}




