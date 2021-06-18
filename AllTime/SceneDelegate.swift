//
//  SceneDelegate.swift
//  Calendar
//
//  Created by Mi Yan on 10/31/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    /*@available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        
        //test to see if it works
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //fetch request
            let fetchRequest =
              NSFetchRequest<NSManagedObject>(entityName: "Categories")
            
            let dictionaryRequest = NSFetchRequest<NSManagedObject>(entityName: "DayDict")
        
            //parse and apply to Singleton
            do {
                let request = try managedContext.fetch(fetchRequest)
                let dictRequest = try managedContext.fetch(dictionaryRequest)
                
                if request.count > 0{
                    //setting everything for categories
                    
                    Singleton.attributes = request[0].value(forKey: "attributes") as? [[String]] ?? []
                    Singleton.attributesN = request[0].value(forKey: "attributesName") as? [String] ?? []
                    Singleton.categories = request[0].value(forKey: "categorynames") as? [String] ?? []
                    Singleton.colorsC = request[0].value(forKey: "colorsC") as? [UIColor] ?? []
                    Singleton.displayTime = request[0].value(forKey: "displayTime") as? [Double] ?? []
                    Singleton.hue = request[0].value(forKey: "hue") as? [Int] ?? []
                    Singleton.timeData = request[0].value(forKey: "timeData") as? [[Date]] ?? []
                   // Singleton.dateTracker = request[0].value(forKey: "dateTracker") as? String ?? ""
                    Singleton.displayT = request[0].value(forKey: "displayT") as? Double ?? 0
                    Singleton.secondC = request[0].value(forKey: "secondC") as? Int ?? 0
                    Singleton.colorPath = request[0].value(forKey: "colorPath") as? [[Int]] ?? []
                    Singleton.lastReset = request[0].value(forKey: "lastReset") as? Date ?? Date.distantPast
                }
                if dictRequest.count > 0{
                    
                    Singleton.dayDict = dictRequest[0].value(forKey: "dictionary") as? [String:[[Any?]]] ?? ["":[]]
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
    }
    */
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    /*
    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene){
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        //get appdelegate
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        // get container
        let managedContext = appDelegate.persistentContainer.viewContext
        // create entity
        let entityCategories =
          NSEntityDescription.entity(forEntityName: "Categories", in: managedContext)!
        let entityDict = NSEntityDescription.entity(forEntityName: "DayDict", in: managedContext)!
        
        //delete all objects in core data then recreate them
        
        //-------------------------- DELETION --------
        
        
        
        // create the delete request for the specified entity
        let fetchRequestC = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        let fetchRequestD = NSFetchRequest<NSFetchRequestResult>(entityName: "DayDict")
        
        let deleteRequestC = NSBatchDeleteRequest(fetchRequest: fetchRequestC)
        let deleteRequestD = NSBatchDeleteRequest(fetchRequest: fetchRequestD)

        // get reference to the persistent container

        let persistentContainer = appDelegate.persistentContainer
        
        // perform the delete
        do {
            try persistentContainer.viewContext.execute(deleteRequestC)
            try persistentContainer.viewContext.execute(deleteRequestD)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
        
        //------------CREATION------
        
        let categories = NSManagedObject(entity: entityCategories,
                                     insertInto: managedContext)
        let dictionary = NSManagedObject(entity: entityDict, insertInto: managedContext)
        
        //setting all values for Categories
        categories.setValue(Singleton.categories, forKey: "categorynames")
        categories.setValue(Singleton.attributes, forKey: "attributes")
        categories.setValue(Singleton.attributesN, forKey: "attributesName")
        categories.setValue(Singleton.colorsC, forKey: "colorsC")
        categories.setValue(Singleton.displayTime, forKey: "displayTime")
        categories.setValue(Singleton.hue, forKey: "hue")
        categories.setValue(Singleton.timeData, forKey: "timeData")
        categories.setValue(Singleton.displayT, forKey: "displayT")
        categories.setValue(Singleton.secondC, forKey: "secondC")
        categories.setValue(Singleton.colorPath, forKey: "colorPath")
        categories.setValue(Singleton.lastReset, forKey: "lastReset")

        
        //setting the dictionary for dayDict
        dictionary.setValue(Singleton.dayDict, forKey: "dictionary")
        
        // update coredata
        do {
          try managedContext.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
 */

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }


}

