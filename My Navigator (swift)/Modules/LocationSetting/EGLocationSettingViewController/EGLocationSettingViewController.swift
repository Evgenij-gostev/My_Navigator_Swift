//
//  EGFetcherSampleViewController.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 12.08.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


enum EGLocationType {
  case OriginLocationType
  case DestinationLocationType
}


class EGLocationSettingViewController: UIViewController {

  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchTextFieldConstraintTop: NSLayoutConstraint!
  @IBOutlet weak var speechView: UIView!
  @IBOutlet weak var recognizedTextLabel: UILabel!
  @IBOutlet weak var speechButton: UIButton!
  
  
  var presenter: EGLocationSettingPresenterProtocol!
  let configurator: EGLocationSettingConfiguratorProtocol = EGLocationSettingConfigurator()
  
  weak var delegate: EGLocationSettingViewControllerDelegate?
  var locationType: EGLocationType?
  var isMyLocationEnabled = false
  var myLocation: CLLocationCoordinate2D?
  var _arrayPlace = [GMSPlace]()


  override func viewDidLoad() {
    super.viewDidLoad()
    configurator.configure(with: self)
    presenter.router.configureView()

    if locationType == .OriginLocationType {
      searchTextFieldConstraintTop.constant = 15
    } else if locationType == .DestinationLocationType {
      searchTextFieldConstraintTop.constant = 65
    }
  }
  
// MARK: - Touches

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    presenter.closeSettingViewController()
  }
 
// MARK: - Actions
  
  @IBAction func actionCancelTextRecognition(_ sender: UIButton) {
    presenter.cancelTextRecognition()
  }
  
  @IBAction func actionStartRecognizingText(_ sender: UIButton) {
    presenter.startRecognizingText()
  }
}

// MARK: - UItextFieldDelegate

extension EGLocationSettingViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let address = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
    presenter.searchForPlaceByAddress(address)
    return true
  }
}

// MARK: - UITableViewDataSource

extension EGLocationSettingViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return isMyLocationEnabled ? 2 : 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isMyLocationEnabled && section == 0 ? 1 : _arrayPlace.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = "Cell"
    var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
    
    if (!cell!.isFocused) {
      cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
    }
    
    if CLLocation.EGLocationNoNullCoordinate(location: myLocation)
      && indexPath.section == 0 {
      cell?.textLabel?.text = "Мое местоположение"
      cell?.imageView?.image = UIImage(named: "My Location.png")
    } else {
      let place: GMSPlace = _arrayPlace[indexPath.row]
      cell?.textLabel?.text = place.name
      cell?.detailTextLabel?.text = place.formattedAddress
      cell?.imageView?.image = UIImage(named: "location.png")
    }
  
    return cell!
  }

}

// MARK: - UITableViewDelegate

extension EGLocationSettingViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    presenter.selectMarkerByIndexPath(indexPath,
                                      myLocation: myLocation)
  }
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 45.0;
  }
}
