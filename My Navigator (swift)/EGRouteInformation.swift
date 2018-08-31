//
//  EGRouteInformation.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 19.08.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation

struct EGRouteInformation: Decodable {
  var routes: [Routes]
}

struct Routes: Decodable {
  var legs: [Legs]
}

struct Legs: Decodable {
  var distance: Distance
  var duration: Duration
  var steps: [Steps]
}

struct Distance: Decodable {
  var text: String
}

struct Duration: Decodable {
  var text: String
}

struct Steps: Decodable {
  var polyline: Polyline
  
  struct Polyline: Decodable {
    var points: String
  }
}
