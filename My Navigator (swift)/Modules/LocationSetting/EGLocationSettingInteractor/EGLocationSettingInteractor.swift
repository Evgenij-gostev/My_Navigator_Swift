//
//  EGLocationSettingInteractor.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 02.09.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import Speech

class EGLocationSettingInteractor: EGLocationSettingInteractorProtocol {
  
  weak var presenter: EGLocationSettingPresenterProtocol!
  weak var delegate: EGLocationSettingViewControllerDelegate?
  private let _samplesPlaces = EGSamplesPlaces.shared
  private var _arrayPlace = [GMSPlace]()
  private let _audioEngine = AVAudioEngine()
  private let _speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))
  private let _request = SFSpeechAudioBufferRecognitionRequest()
  private var _recognitionTask: SFSpeechRecognitionTask?
  private var _recognizedText: String?
  
  
  required init(presenter: EGLocationSettingPresenterProtocol) {
    self.presenter = presenter
  }
  
  func startRecognitionText() {
    presenter.router.setRecognizedTextLabel("")
    startRecognition()
    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
      self.stopRecognizingText()
      if let address = self._recognizedText {
        self.presenter.router.setSearchTextField(address)
        self.searchForPlaceByAddress(address)
      }
      self.presenter.router.hideSpeechView()
    }
  }
  
  func stopRecognizingText() {
    _audioEngine.stop()
    _request.endAudio()
    _recognitionTask?.cancel()
  }
  
  func searchForPlaceByAddress(_ address: String) {
    _samplesPlaces.setRequest(address)
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    _arrayPlace = _samplesPlaces.getSamplesPlaces()
    presenter.router.setArrayPlace(_arrayPlace)
    presenter.router.reloadDataTableView()
//    }
  }
  
  func selectMarkerByIndexPath(_ indexPath: IndexPath,
                               myLocation: CLLocationCoordinate2D?) {
    var place: GMSPlace? = nil
    if CLLocation.EGLocationNoNullCoordinate(location: myLocation)
      && indexPath.section != 0 {
      place = _arrayPlace[indexPath.row]
    }
    createMarkerFromPlace(place, myLocation: myLocation!)
    presenter.router.closeSettingViewController()
  }
  
  // MARK: - Private Metods
  
  private func createMarkerFromPlace(_ place: GMSPlace?,
                                     myLocation: CLLocationCoordinate2D) {
    let markers = EGMarkers.init(withPlace: place, andMyLocation: myLocation)
    let marker: GMSMarker = markers.getMarker()
    presenter.router.autocompleteWithMarker(marker)
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
          let resultText = result.bestTranscription.formattedString
          self.presenter.router.setRecognizedTextLabel(resultText)
          self._recognizedText = resultText
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
  
}
