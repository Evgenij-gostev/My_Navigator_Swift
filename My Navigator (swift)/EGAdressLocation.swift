//
//  EGAdressLocation.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 23.08.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation

struct EGAdressLocation: Decodable {
  var results: [Results]
}

struct Results: Decodable {
  var formatted_address: String
}


