//
//  PhotoConnection.swift
//  FourthColor
//
//  Created by Natalia Wcisło on 06/06/2020.
//  Copyright © 2020 Natalia Wcisło. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PhotoConnection {
    var managedContext: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    private func saveContext() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public func fetchPhotos() -> [Photo] {
        do {
            return try managedContext.fetch(Photo.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    public func insertPhoto(name: String, image: Data, color: Int64, description: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Photo", in: managedContext)!
        let photo = NSManagedObject(entity: entity, insertInto: managedContext)
    
        photo.setValue(name, forKeyPath: "name")
        photo.setValue(image, forKeyPath: "image")
        photo.setValue(color, forKeyPath: "color")
        photo.setValue(description, forKeyPath: "color_description")
        
        saveContext()
    }
    
    public func clearPhotos() {
        if let result = try? managedContext.fetch(Photo.fetchRequest()) {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
        }
        
        saveContext()
    }
    
    public func deletePhoto(where predicate: (Photo) throws -> Bool) {
        if let result = try? managedContext.fetch(Photo.fetchRequest()) {
            for object in result {
                do {
                    if try predicate(object as! Photo) {
                        managedContext.delete(object as! NSManagedObject)
                    }
                } catch let error as NSError {
                    print("Could not test for delete. \(error), \(error.userInfo)")
                }
            }
        }
        
        saveContext()
    }
}
