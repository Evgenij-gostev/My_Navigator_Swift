//
//  EGLocationSettingConfigurator.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 04.09.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import Foundation


class EGLocationSettingConfigurator: EGLocationSettingConfiguratorProtocol {
  
  func configure(with viewController: EGLocationSettingViewController) {
    let presenter = EGLocationSettingPresenter()
    let interactor = EGLocationSettingInteractor(presenter: presenter)
    let router = EGLocationSettingRouter(viewController: viewController)
    
    viewController.presenter = presenter
    presenter.interactor = interactor
    presenter.router = router
  }
}
