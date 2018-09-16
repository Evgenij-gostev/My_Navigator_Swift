//
//  AppDelegate.swift
//  My Navigator (swift)
//
//  Created by Евгений Гостев on 12.08.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    GMSServices.provideAPIKey("AIzaSyAMzlz_OA3_nmJ7FzIhTGYVdmLwTLZKsR0")
    GMSPlacesClient.provideAPIKey("AIzaSyCTekSo1h0-r9tjv_GX7it_fjtlChdvaHQ")
    
    return true
  }


//  func applicationWillTerminate(_ application: UIApplication) {
//    self.saveContext()
//  }

//  // MARK: - Core Data stack
//
//  lazy var persistentContainer: NSPersistentContainer = {
//
//      let container = NSPersistentContainer(name: "My_Navigator__swift_")
//      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//          if let error = error as NSError? {
//              fatalError("Unresolved error \(error), \(error.userInfo)")
//          }
//      })
//      return container
//  }()
//
//  // MARK: - Core Data Saving support
//
//  func saveContext () {
//      let context = persistentContainer.viewContext
//      if context.hasChanges {
//          do {
//              try context.save()
//          } catch {
//              let nserror = error as NSError
//              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//          }
//      }
//  }

}

