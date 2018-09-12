//
//  EGMapInteractor.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 02.09.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces


class EGMapInteractor: NSObject, EGMapInteractorProtocol {
  
  weak var presenter: EGMapPresenterProtocol!
  private let _locationManager = CLLocationManager()
  private var _originLocation: CLLocationCoordinate2D?
  private var _destinationLocation: CLLocationCoordinate2D?
  private var _originMarker: GMSMarker?
  private var _destinationMarker: GMSMarker?
  private var _polyline: GMSPolyline?
  private var _addressLocation: String?
  private var _distance: String?
  private var _duration: String?
  private let _routeData = EGRouteData()
  
  required init(presenter: EGMapPresenterProtocol) {
    super.init()
    self.presenter = presenter
    loadRouteData()
  }
  
  func configure() {
    loadLocationManager()
  }

  func buildRoute() {
    _polyline = nil
    establishOriginLocation()
    if let originLocation = _originLocation,
      let destinationLocation = _destinationLocation {
      _routeData.routeDataFromServerAndTheRoute(withOrigin: originLocation,
                                            andDestination: destinationLocation)
    }
  }
  
  func cancelRoute() {
    _polyline?.map = nil
  }
  
  func saveRoute() {
    
  }

// MARK: - Private Methods

  private func loadLocationManager() {
    _locationManager.delegate = self
    _locationManager.requestWhenInUseAuthorization()
  }

  private func establishOriginLocation() {
    if presenter.router.isMyLocationEnabled {
      _originLocation = presenter.router.getMyLocation()
    }
  }

  func addMarker(_ marker: GMSMarker, andLocationType locationType: EGLocationType) {
    if locationType == EGLocationType.OriginLocationType {
      addOriginMarker(marker)
    } else if locationType == EGLocationType.DestinationLocationType {
      addDestinationMarker(marker)
    }
    presenter.router.scalingLocation(marker.position, andZoom: 15)
    if CLLocation.EGLocationNoNullCoordinate(location: _originLocation) && CLLocation.EGLocationNoNullCoordinate(location: _destinationLocation) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.presenter.showSimpleAlert(withMessege: "Построить маршрут?",
                                       isOneButton: false)
      }
    }
  }

  private func addOriginMarker(_ marker: GMSMarker) {
    _originMarker?.map = nil
    presenter.router.establishOriginTextField(marker.snippet)
    _originLocation = marker.position
    _originMarker = marker
    _originMarker?.icon = UIImage(named: "OriginLocation(64x64).png")
    presenter.router.addMarkerToMapView(_originMarker!)
  }

  private func addDestinationMarker(_ marker: GMSMarker) {
    _destinationMarker?.map = nil
    presenter.router.establishDestinationTextField(marker.snippet)
    _addressLocation = marker.snippet
    _destinationLocation = marker.position
    _destinationMarker = marker
    _destinationMarker?.icon = UIImage(named: "DestinationLocation(64x64).png")
    presenter.router.addMarkerToMapView(_destinationMarker!)
  }

  private func loadInformationViewAndScaling() {
    establishOriginLocation()
    let bounds = GMSCoordinateBounds.init(path: (_polyline?.path)!)
    presenter.router.showTheWholeRoute(forBounds: bounds)
    presenter.router.loadInformationView(withDuration: _duration,
                                          andDistance: _distance)
  }

  // MARK: - EGRouteDataDelegate
  
  private func loadRouteData() {
    _routeData.delegateCall.delegate(to: self) { (self, arg1) in
      let (polyline, distance, duration, messageError) = arg1
      if let polyline = polyline {
        self._distance = distance
        self._duration = duration
        self._polyline = polyline
        self.presenter.router.addPolylineToMapView(self._polyline)
        self.loadInformationViewAndScaling()
      } else {
        self.presenter.showSimpleAlert(withMessege: messageError!,
                                       isOneButton: true)
      }
    }
  }
}

// MARK: - CLLocationManagerDelegate

extension EGMapInteractor: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      _locationManager.startUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      let snippet = "Мое местоположение"
      presenter.router.establishOriginTextField(snippet)
      presenter.router.scalingLocation(location.coordinate, andZoom: 12)
      _locationManager.stopUpdatingLocation()
      _originLocation = manager.location?.coordinate
      _originMarker = GMSMarker.init(position: manager.location!.coordinate)
      _originMarker?.snippet = snippet
      presenter.router.isMyLocationEnabled = true
    }
  }
}

// MARK: - EGLocationSettingViewControllerDelegate

extension EGMapInteractor: EGLocationSettingViewControllerDelegate {
  func autocomplete(withMarker marker: GMSMarker,
                              andLocationType locationType: EGLocationType) {
    addMarker(marker, andLocationType: locationType)
  }
}
