//
//  ViewController.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 12.08.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class EGMapViewController: UIViewController {
  
  
  private let _locationManager = CLLocationManager()
  private var _originLocation: CLLocationCoordinate2D? = nil
  private var _destinationLocation: CLLocationCoordinate2D? = nil
  private var _isMyLocationEnabled = false
  private var _position: GMSCameraPosition? = nil
  private var _originMarker: GMSMarker? = nil
  private var _destinationMarker: GMSMarker? = nil
  private var _polyline: GMSPolyline? = nil
  private var _addressLocation: String? = nil
  private var _distance: String? = nil
  private var _duration: String? = nil
  private var _place: GMSPlace? = nil


  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var originTextField: UITextField!
  @IBOutlet weak var destinationTextField: UITextField!
  @IBOutlet weak var informationView: UIView!
  @IBOutlet weak var informationRouteLabel: UILabel!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    informationView.layer.cornerRadius = 5
    informationView.layer.shadowColor = UIColor.black.cgColor
    informationView.layer.shadowOffset = CGSize(width: 3, height: 3)
    informationView.layer.shadowOpacity = 0.7
    informationView.layer.shadowRadius = 4.0
    informationView.isHidden = true
    
    if !_isMyLocationEnabled {
      let startLocation = CLLocationCoordinate2DMake(0, 10)
      scalingLocation(startLocation, andZoom: 1)
    }

    loadLocationManager()
    loadMapView()
  }
  
// MARK: - Actions
  
  @IBAction func actionScaling(_ sender: UIButton) {
    var zoom = _position!.zoom
    if sender.tag == 1 {
      zoom -= 1.0
    } else {
      zoom += 1.0
    }
    mapView.animate(toZoom: zoom)
  }
  
  @IBAction func actionMyLocation(_ sender: UIButton) {
    scalingLocation(mapView.myLocation!.coordinate, andZoom: 12)
  }
  
  @IBAction func actionAddRoute(_ sender: UIButton) {
    buildRoute()
    view.addSubview(informationView)
  }
  
  @IBAction func actionCancelRoute(_ sender: UIButton) {
    _polyline?.map = nil
    informationView.isHidden = true
  }
  
  
  @IBAction func actionRouteHistory(_ sender: UIButton) {
    EGServerManager.shared.getAddressForCoordinate(_destinationLocation!,
                                                   onSuccess: { (address) in
      print(address)
    }) { (error) in
      print(error)
    }
  }
  
  

// MARK: - Private Methods
  
  private func loadLocationManager() {
    _locationManager.delegate = self
    _locationManager.requestWhenInUseAuthorization()
  }
  
  private func loadMapView() {
    mapView.isMyLocationEnabled = true
    mapView.mapType = .normal
    mapView.delegate = self
  }
  
  private func scalingLocation(_ location: CLLocationCoordinate2D, andZoom zoom: Float) {
    let camera = GMSCameraPosition.camera(withTarget: location, zoom: zoom)
    mapView.camera = camera
  }
  
  private func addMarker(_ marker: GMSMarker, andLocationType locationType: EGLocationType) {
    if locationType == EGLocationType.OriginLocationType {
      addOriginMarker(marker)
    } else if locationType == EGLocationType.DestinationLocationType {
      addDestinationMarker(marker)
    }
    scalingLocation(marker.position, andZoom: 15)
    if CLLocation.EGCLLocationNoNullCoordinate(location: _originLocation) && CLLocation.EGCLLocationNoNullCoordinate(location: _destinationLocation) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        self.showSimpleAlertWithMessege("Построить маршрут?", isOneButton: false)
      }
//      DispatchQueue.main.async {
//        self.showSimpleAlertWithMessege("Построить маршрут?", isOneButton: false)
//        print("Hi")
//      }
    }
  }

/*
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
  [self _showSimpleAlertWithMessege:@"Построить маршрут?" isOneButton:NO];
*/
  
  private func addOriginMarker(_ marker: GMSMarker) {
    _originMarker?.map = nil
    originTextField.text = marker.snippet
    _originLocation = marker.position
    _originMarker = marker
    _originMarker?.icon = UIImage(named: "OriginLocation(64x64).png")
    _originMarker?.map = mapView
  }

  private func addDestinationMarker(_ marker: GMSMarker) {
    _destinationMarker?.map = nil
    destinationTextField.text = marker.snippet
    _addressLocation = marker.snippet
    _destinationLocation = marker.position
    _destinationMarker = marker
    _destinationMarker?.icon = UIImage(named: "DestinationLocation(64x64).png")
    _destinationMarker?.map = mapView
  }
  
  private func buildRoute() {
    _polyline = nil
    if let originLocation = _originLocation, let destinationLocation = _destinationLocation {
      let routeData = EGRouteData(withOrigin: originLocation,
                                  andDestination: destinationLocation)
      routeData.delegate = self
    }
  }
  
  private func choiceOfLocation(_ coordinate: CLLocationCoordinate2D) {
    let markers = EGMarkers(withCoordinate: coordinate)
    let marker = markers.getMarker()
    let message = "Выбор старта или финиша"
    let alert = UIAlertController(title: nil,
                                  message: message,
                                  preferredStyle: .alert)
    let yesButton = UIAlertAction(title: "Старт", style: .default) { (_) in
      self.addMarker(marker, andLocationType: EGLocationType.OriginLocationType)
    }
    let noButton = UIAlertAction(title: "Финиш", style: .default) { (_) in
      self.addMarker(marker, andLocationType: EGLocationType.DestinationLocationType)
    }
    alert.addAction(yesButton)
    alert.addAction(noButton)
    present(alert, animated: true, completion: nil)
  }

  private func loadInformationViewAndScaling() {
    let bounds = GMSCoordinateBounds(coordinate: _originLocation!, coordinate: _destinationLocation!)
    let mapInsets = UIEdgeInsetsMake(140.0, 100.0, 100.0, 100.0)
    let camera = mapView.camera(for: bounds, insets: mapInsets)
    mapView.camera = camera!
    informationRouteLabel.text = "\(_duration!) (\(_distance!))"
    loadInformationView()
  }
  
  private func loadInformationView() {
    informationView.isHidden = false
    UIView.transition(with: informationView, duration: 0.5, options: [.curveEaseIn, .transitionFlipFromBottom], animations: nil, completion: nil)
  }
  
  private func showSimpleAlertWithMessege(_ message: String, isOneButton: Bool) {
    let alert = UIAlertController(title: nil,
                                  message: message,
                                  preferredStyle: .actionSheet)
    if !isOneButton {
      let yesButton = UIAlertAction(title: "OK", style: .default) { (_) in
        self.buildRoute()
        self.saveRoute()
      }
      alert.addAction(yesButton)
    }
    let noButton = UIAlertAction(title: "Отмена", style: .default, handler: nil)
    alert.addAction(noButton)
    present(alert, animated: true, completion: nil)
  }
  
  private func saveRoute() {
//    if (_addressLocation) {
//      RLMRealm *realm = [RLMRealm defaultRealm];
//      [realm beginWriteTransaction];
//      EGRouteHistory* routeHistory = [[EGRouteHistory alloc] init];
//      routeHistory.name = _addressLocation;
//      [routeHistory setOriginMarker:_originMarker];
//      [routeHistory setDestinationMarker:_destinationMarker];
//      [realm addObject:routeHistory];
//      [realm commitWriteTransaction];
//    }
  }

}

// MARK: - CLLocationManagerDelegate

extension EGMapViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      _locationManager.startUpdatingLocation()
      mapView.isMyLocationEnabled = true
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      scalingLocation(location.coordinate, andZoom: 12)
      _locationManager.stopUpdatingLocation()
      _originLocation = manager.location?.coordinate
      originTextField.text = "Мое местоположение"
      _originMarker = GMSMarker.init(position: manager.location!.coordinate)
      _originMarker?.snippet = "Мое местоположение"
      _isMyLocationEnabled = true
    }
  }
  
}

// MARK: - GMSMapViewDelegate

extension EGMapViewController: GMSMapViewDelegate {

  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    self._position = position
  }
  
  func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
    _polyline?.map = nil
    choiceOfLocation(coordinate)
  }
  
  func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
    dismiss(animated: true, completion: nil)
  }

}

// MARK: - UItextFieldDelegate

extension EGMapViewController: UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    informationView.isHidden = true
    _polyline?.map = nil
    
    let fetcherSampleVC: EGFetcherSampleViewController = storyboard?.instantiateViewController(withIdentifier: "EGFetcherSampleViewController") as! EGFetcherSampleViewController
    fetcherSampleVC.modalTransitionStyle = .crossDissolve
    fetcherSampleVC.modalPresentationStyle = .custom
    fetcherSampleVC.isMyLocationEnabled = _isMyLocationEnabled
    fetcherSampleVC.myLocation = mapView.myLocation?.coordinate

    switch textField.tag {
      case 0:
        fetcherSampleVC.locationType = EGLocationType.OriginLocationType
      case 1:
      fetcherSampleVC.locationType = EGLocationType.DestinationLocationType
      default:
        break
    }
    present(fetcherSampleVC, animated: true, completion: nil)
    fetcherSampleVC.delegate = self
    return false;
  }
}

// MARK: - EGFetcherSampleViewControllerDelegate

extension EGMapViewController: EGFetcherSampleViewControllerDelegate {
  
  func autocompleteWithMarker(_ marker: GMSMarker,
                              andLocationType locationType: EGLocationType) {
    addMarker(marker, andLocationType: locationType)
  }
  
}

// MARK: - EGRouteDataDelegate

extension EGMapViewController: EGRouteDataDelegate {
  func getRouteDataWithPolyline(_ polyline: GMSPolyline?, distance: String?, duration: String?, messageError: String?) {
    if let polyline = polyline {
      _distance = distance
      _duration = duration
      _polyline = polyline
      _polyline?.map = mapView
      loadInformationViewAndScaling()
    } else {
      showSimpleAlertWithMessege(messageError!, isOneButton: true)
    }
  }
  
}
