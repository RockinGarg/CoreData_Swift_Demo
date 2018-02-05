//
//  Audio+CoreDataProperties.swift
//  AppCoreData
//
//  Created by IosDeveloper on 28/12/17.
//  Copyright © 2017 iOSDeveloper. All rights reserved.
//
//

import Foundation
import CoreData


extension Audio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Audio> {
        return NSFetchRequest<Audio>(entityName: "Audio")
    }

    @NSManaged public var fileName: String?
    @NSManaged public var duration: String?
    @NSManaged public var uploadedStatus: String?

}
