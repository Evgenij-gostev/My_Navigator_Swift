//
//  EGServerManager.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 14.08.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation
import GoogleMaps


class EGServerManager {
  
  static let shared = EGServerManager()
  
  private init() {}
  
  func getRoute(withOrigin origin: CLLocationCoordinate2D,
    andDestination destination: CLLocationCoordinate2D,
             onSuccess success: @escaping (_ routeInformation:EGRouteInformation?) -> (),
             onFailure failure:@escaping (_ error: Error) -> ()) {
    
    let urlComponents = NSURLComponents(string: "https://maps.googleapis.com/maps/api/directions/json")!
    urlComponents.queryItems = [
      NSURLQueryItem(name: "origin",
                    value: String(origin.latitude) + "," + String(origin.longitude)),
      NSURLQueryItem(name: "destination",
                    value: String(destination.latitude) + "," + String(destination.longitude)),
      NSURLQueryItem(name: "mode", value: String("driving")),
      NSURLQueryItem(name: "departure_time", value: String("now")),
      NSURLQueryItem(name: "traffic_model", value: String("pessimistic")),
      NSURLQueryItem(name: "key",
                    value: String("AIzaSyDbPMpz5YN6DbntQcX6XN3mwSee-HeRHIQ"))
      ] as [URLQueryItem]
    
    let session = URLSession.shared
    session.dataTask(with: urlComponents.url!) { (data, response, error) in
      do {
        guard let data = data else { return }
        let routeInformation = try JSONDecoder().decode(EGRouteInformation.self, from: data)
        success(routeInformation)
      } catch {
        print(error)
        failure(error)
      }
      }.resume()
  }

  func getAddress(forCoordinate coordinate: CLLocationCoordinate2D,
                         onSuccess success: @escaping (_ address: String?) -> (),
                         onFailure failure: @escaping (_ error: Error) -> ()) {
    let urlComponents = NSURLComponents(string: "https://maps.googleapis.com/maps/api/geocode/json")!
    urlComponents.queryItems = [
      NSURLQueryItem(name: "latlng",
                    value: String(coordinate.latitude) + "," + String(coordinate.longitude)),
      NSURLQueryItem(name: "key",
                    value: String("AIzaSyAuzyI7se6hI1jNVS_V-RRZlVEW3AXZNsE"))
      ] as [URLQueryItem]
    
    let session = URLSession.shared
    session.dataTask(with: urlComponents.url!) { (data, response, error) in
      do {
        guard let data = data else { return }
        let addressLocation = try JSONDecoder().decode(EGAdressLocation.self, from: data)
        if let address = addressLocation.results.first?.formatted_address {
          success(address)
        }
      } catch {
        failure(error)
      }
      }.resume()
  }  
}
