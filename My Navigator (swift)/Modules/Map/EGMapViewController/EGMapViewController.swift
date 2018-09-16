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

  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var originTextField: UITextField!
  @IBOutlet weak var destinationTextField: UITextField!
  @IBOutlet weak var informationView: UIView!
  @IBOutlet weak var informationRouteLabel: UILabel!
  @IBOutlet weak var myLocationButton: UIButton!
  
  var presenter: EGMapPresenterProtocol!
  let configurator: EGMapConfiguratorProtocol = EGMapConfigurator()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configurator.configure(with: self)
    presenter.configure()
  }
  
// MARK: - Actions
  
  @IBAction func actionScaling(_ sender: UIButton) {
    presenter.scaling(tag: sender.tag)
  }
  
  @IBAction func actionMyLocation(_ sender: UIButton) {
    presenter.router.scalingLocation(mapView.myLocation!.coordinate, andZoom: 14)
  }
  
  @IBAction func actionAddRoute(_ sender: UIButton) {
    presenter.buildRoute()
    view.addSubview(informationView)
  }
  
  @IBAction func actionCancelRoute(_ sender: UIButton) {
    presenter.cancelRoute()
    informationView.isHidden = true
  }
  
  @IBAction func actionRouteHistory(_ sender: UIButton) {
    presenter.startQueryHistoryViewController()
  }
}

// MARK: - GMSMapViewDelegate

extension EGMapViewController: GMSMapViewDelegate {

  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    presenter.router.position = position
  }
  
  func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
    presenter.choiceOfLocation(coordinate)
  }
  
  func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - UItextFieldDelegate

extension EGMapViewController: UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    informationView.isHidden = true
    switch textField.tag {
    case 0:
      presenter.startLocationSettingViewController(withLocationType:
        .OriginLocationType)
    case 1:
      presenter.startLocationSettingViewController(withLocationType:
        .DestinationLocationType)
    default:
      break
    }
    return false
  }
}
