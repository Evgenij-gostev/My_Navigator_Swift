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
import Speech


enum EGLocationType {
  case OriginLocationType
  case DestinationLocationType
}


protocol EGFetcherSampleViewControllerDelegate: class {
  func autocompleteWithMarker(_ marker: GMSMarker, andLocationType locationType: EGLocationType)
}


class EGFetcherSampleViewController: UIViewController {

  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchTextFieldConstraintTop: NSLayoutConstraint!
  @IBOutlet weak var speechView: UIView!
  @IBOutlet weak var recognizedTextLabel: UILabel!
  @IBOutlet weak var speechButton: UIButton!
  
  
  weak var delegate: EGFetcherSampleViewControllerDelegate?
  var locationType: EGLocationType? = nil
  var isMyLocationEnabled = false
  var myLocation: CLLocationCoordinate2D? = nil
  
  private var _arrayPlace = [GMSPlace]()
  private let _samplesPlaces = EGSamplesPlaces.shared
  private let _audioEngine = AVAudioEngine()
  private let _speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))
  private let _request = SFSpeechAudioBufferRecognitionRequest()
  private var _recognitionTask: SFSpeechRecognitionTask?

  override func viewDidLoad() {
    super.viewDidLoad()
//    searchTextField.becomeFirstResponder()
    tableView.layer.cornerRadius = 5
    
    speechView.layer.cornerRadius = 5
    speechView.layer.shadowColor = UIColor.black.cgColor
    speechView.layer.shadowOffset = CGSize(width: 3, height: 3)
    speechView.layer.shadowOpacity = 0.7
    speechView.layer.shadowRadius = 4.0
    
    speechView.isHidden = true
    
    if locationType == .OriginLocationType {
      searchTextFieldConstraintTop.constant = 15
    } else if locationType == .DestinationLocationType {
      searchTextFieldConstraintTop.constant = 65
    }
  }
  
// MARK: - Touches

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    dismiss(animated: true, completion: nil)
    stopRecognizingText()
  }
 
// MARK: - Actions
  
  @IBAction func actionCancelTextRecognition(_ sender: UIButton) {
    speechView.isHidden = true
    stopRecognizingText()
  }
  
  @IBAction func actionStartRecognizingText(_ sender: UIButton) {
    speechView.isHidden = false
    recognizedTextLabel.text = ""
    startRecognition()
    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
      self.stopRecognizingText()
      if let address = self.recognizedTextLabel.text {
        self.searchTextField.text = address
        self.searchForPlaceByAddress(address)
      }
      self.speechView.isHidden = true
    }
  }
  
// MARK: - Private Metods

  private func createMarkerFromPlace(_ place: GMSPlace?) {
    let markers = EGMarkers.init(withPlace: place, andMyLocation: myLocation!)
    let marker: GMSMarker = markers.getMarker()
    self.delegate?.autocompleteWithMarker(marker, andLocationType: locationType!)
  }
  
  private func startRecognition() {
    let node = _audioEngine.inputNode
    let recognitionFormat = node.outputFormat(forBus: 0)
    
    node.installTap(onBus: 0, bufferSize: 1024, format: recognitionFormat) { [unowned self](buffer, audioTime) in
      self._request.append(buffer)
    }
    
    _audioEngine.prepare()
    do {
      try _audioEngine.start()
    } catch let error {
      print("\(error.localizedDescription)")
      return
    }
    
    _recognitionTask = _speechRecognizer?.recognitionTask(with: _request, resultHandler: { [unowned self](result, error) in
      if let result = result {
        DispatchQueue.main.async {
          [unowned self] in
          self.recognizedTextLabel.text = result.bestTranscription.formattedString
        }
        if result.isFinal {
          node.removeTap(onBus: 0)
        }
      } else if let error = error {
        print("\(error.localizedDescription)")
        node.removeTap(onBus: 0)
      }
    })
  }
  
  private func stopRecognizingText() {
    _audioEngine.stop()
    _request.endAudio()
    _recognitionTask?.cancel()
  }
  
  private func searchForPlaceByAddress(_ address: String) {

    DispatchQueue.global(qos: .userInteractive).sync {
      self._samplesPlaces.setRequest(address)
    }
  
  

//    self._arrayPlace = self._samplesPlaces.getSamplesPlaces()
//    self._arrayPlace = self._samplesPlaces.createArraySamplesPlaces()
//    self.tableView.reloadData()

//    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//      self._arrayPlace = self._samplesPlaces.getSamplesPlaces()
      self._arrayPlace = self._samplesPlaces.createArraySamplesPlaces()
      self.tableView.reloadData()
//    }
//    self.tableView.reloadData()
  }
}

// MARK: - UItextFieldDelegate

extension EGFetcherSampleViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let address = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
    searchForPlaceByAddress(address)
    return true
  }
  
}

// MARK: - UITableViewDataSource

extension EGFetcherSampleViewController: UITableViewDataSource {
  
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
    
    if CLLocation.EGCLLocationNoNullCoordinate(location: myLocation)
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

extension EGFetcherSampleViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    var place: GMSPlace? = nil
    if CLLocation.EGCLLocationNoNullCoordinate(location: myLocation)
      && indexPath.section != 0 {
      place = _arrayPlace[indexPath.row]
    }
    createMarkerFromPlace(place)
    dismiss(animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 45.0;
  }
}
