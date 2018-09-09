//
//  EGMapConfigurator.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 06.09.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation

class EGMapConfigurator: EGMapConfiguratorProtocol {
  
  func configure(with viewController: EGMapViewController) {
    let presenter = EGMapPresenter()
    let interactor = EGMapInteractor(presenter: presenter)
    let router = EGMapRouter(viewController: viewController)
    
    viewController.presenter = presenter
    presenter.interactor = interactor
    presenter.router = router
  }
  
}
