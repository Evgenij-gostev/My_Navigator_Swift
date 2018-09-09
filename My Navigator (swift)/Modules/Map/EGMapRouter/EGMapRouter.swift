//
//  EGMapRouter.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 02.09.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class EGMapRouter: EGMapRouterProtocol {

  weak var viewController: EGMapViewController!
//  private let _locationManager = CLLocationManager()
  var position: GMSCameraPosition?
  var isMyLocationEnabled = false
  
  init(viewController: EGMapViewController) {
    self.viewController = viewController
  }
  
  func configureView() {
    viewController.informationView.isHidden = true
    viewController.informationView.layer.cornerRadius = 5
    viewController.informationView.layer.shadowColor = UIColor.black.cgColor
    viewController.informationView.layer.shadowOffset = CGSize(width: 3, height: 3)
    viewController.informationView.layer.shadowOpacity = 0.7
    viewController.informationView.layer.shadowRadius = 4.0
    loadMapView()
    if !isMyLocationEnabled {
      viewController.myLocationButton.isHidden = true
      let startLocation = CLLocationCoordinate2DMake(0, 10)
      scalingLocation(startLocation, andZoom: 1)
    }
    
  }
  
  func establishOriginTextField(_ text: String?) {
    viewController.originTextField.text = text
  }
  
  func establishDestinationTextField(_ text: String?) {
    viewController.destinationTextField.text = text
  }
  
  func getMyLocation() -> CLLocationCoordinate2D? {
    return viewController.mapView.myLocation?.coordinate
  }
  
  func scaling(tag: Int) {
    var zoom = position!.zoom
    if tag == 1 {
      zoom -= 1.0
    } else {
      zoom += 1.0
    }
    viewController.mapView.animate(toZoom: zoom)
  }
  
  func scalingLocation(_ location: CLLocationCoordinate2D, andZoom zoom: Float) {
    let camera = GMSCameraPosition.camera(withTarget: location, zoom: zoom)
    viewController.mapView.camera = camera
  }
  
//  func locationManager(_ manager: CLLocationManager) {
//    _locationManager.startUpdatingLocation()
//    viewController.mapView.isMyLocationEnabled = true
//  }
  
  func presentController(_ controller: UIViewController) {
    viewController.present(controller, animated: true, completion: nil)
  }
  
  func addMarkerToMapView(_ marker: GMSMarker) {
    marker.map = viewController.mapView
  }
  
  func addPolylineToMapView(_ polyline: GMSPolyline?) {
    polyline?.map = viewController.mapView
  }
  
  func loadInformationView(duration: String?, distance: String?) {
    viewController.informationRouteLabel.text = "\(duration!) (\(distance!))"
    viewController.informationView.isHidden = false
    UIView.transition(with: viewController.informationView,
                  duration: 0.5,
                   options: [.curveEaseIn, .transitionFlipFromBottom],
                animations: nil,
                completion: nil)
  }
  
  func showTheWholeRoute(forBounds bounds: GMSCoordinateBounds) {
    let mapInsets = UIEdgeInsetsMake(120.0, 40.0, 80.0, 60.0)
    let camera = viewController.mapView.camera(for: bounds, insets: mapInsets)
    viewController.mapView.camera = camera!
  }
  
  // MARK: - Private Methods
  
  private func loadMapView() {
    viewController.mapView.isMyLocationEnabled = true
    viewController.mapView.mapType = .normal
    viewController.mapView.delegate = viewController.self
  }

}
