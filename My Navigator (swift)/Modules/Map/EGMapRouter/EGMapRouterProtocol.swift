//
//  EGMapProtocols.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 02.09.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation
import GoogleMaps

protocol EGMapRouterProtocol: class {
  var position: GMSCameraPosition? { set get }
  var isMyLocationEnabled: Bool { set get }
  func configureView()
  func scaling(tag: Int)
  func scalingLocation(_ location: CLLocationCoordinate2D, andZoom zoom: Float)
  func establishOriginTextField(_ text: String?)
  func establishDestinationTextField(_ text: String?)
  func getMyLocation() -> CLLocationCoordinate2D?
  func presentController(_ controller: UIViewController)
  func addMarkerToMapView(_ marker: GMSMarker)
  func addPolylineToMapView(_ polyline: GMSPolyline?)
  func loadInformationView(withDuration duration: String?,
                            andDistance distance: String?)
  func showTheWholeRoute(forBounds bounds: GMSCoordinateBounds)
}
