//
//  Profile.swift
//  DisplayOrganizer
//
//  Created by Lawrence Bensaid on 5/29/22.
//
//

import Foundation
import CoreData

@objc(Profile)
class Profile: NSManagedObject, Identifiable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        NSFetchRequest<Profile>(entityName: "Profile")
    }
    
    @NSManaged public var name: String
    @NSManaged public var configuration: String
    @NSManaged public var timestamp: Date?
    
    public var displays: [Display] {
        configuration.components(separatedBy: ";").compactMap(Display.init)
    }
    
}
