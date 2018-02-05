//
//  CoreDataHandler.swift
//  AppCoreData
//
//  Created by IosDeveloper on 28/12/17.
//  Copyright © 2017 iOSDeveloper. All rights reserved.
//

import Foundation
import CoreData

class AudioDetail {
    
    ///Common Context
    var context: NSManagedObjectContext
    
    //MARK:- Initialise Context
    init(context: NSManagedObjectContext)
    {
        self.context = context
    }
    
    //MARK:- Create New Record
    func create(fileName: String, duration: String, uploadedStatus: String) -> Audio
    {
        //Create Reference for New AudioFile
        let newAudioDetail = NSEntityDescription.insertNewObject(forEntityName: "Audio", into: context) as! Audio

        //Set Values
        newAudioDetail.fileName = fileName
        newAudioDetail.duration = duration
        newAudioDetail.uploadedStatus = uploadedStatus
        
        //Save Context here
        self.saveChanges()
        
        //Return Audio Detail Reference
        return newAudioDetail
    }
    
    //MARK:- Gets a Audio by its id
    func getById(id: NSManagedObjectID) -> Audio?
    {
        //get audio by id and return
        return context.object(with: id) as? Audio
    }
    
    //MARK:- Gets all Audio Stored Status Array
    func getAll() -> [Audio]
    {
        //returns array
        return get(withPredicate: NSPredicate(value:true))
    }
    
    //MARK:- Gets all that fulfill the specified predicate.
    func get(withPredicate queryPredicate: NSPredicate) -> [Audio]
    {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Audio")
        fetchRequest.predicate = queryPredicate
        
        //Handler
        do
        {
            let response = try context.fetch(fetchRequest)
            return response as! [Audio]
            
        }
        catch let error as NSError
        {
            // failure
            print(error)
            return [Audio]()
        }
    }
    
    //MARK:- Updates a Audio File Record
    typealias CompletionHandler = (_ success:Bool) -> Void
    func update(updatedPerson: Audio,completionHandler: CompletionHandler)
    {
        ///get audio file that is to be deleted by managed object id
        if let audio = getById(id: updatedPerson.objectID)
        {
            audio.fileName = updatedPerson.fileName
            audio.duration = updatedPerson.duration
            audio.uploadedStatus = updatedPerson.uploadedStatus
            completionHandler(true)
        }
        else
        {
            completionHandler(false)
        }
    }
    
    //MARK:- Deletes a person
    func delete(id: NSManagedObjectID)
    {
        if let audioToDelete = getById(id: id){
            context.delete(audioToDelete)
        }
    }
    
    //MARK:- Delete all records saved at once
    typealias CompletionHandlerr = (_ success:Bool) -> Void
    func deleteAllData(entity: String,completionHandlerr: CompletionHandler)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
                completionHandlerr(true)
            }
        } catch let error as NSError {
            completionHandlerr(false)
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    //MARK:- Saves all changes
    func saveChanges()
    {
        do{
            try context.save()
        }
        catch let error as NSError
        {
            // failure
            print(error)
        }
    }
}
