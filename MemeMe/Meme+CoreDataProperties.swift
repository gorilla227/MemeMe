//
//  Meme+CoreDataProperties.swift
//  MemeMe_1.0
//
//  Created by Andy Xu on 16/4/27.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Meme {

    @NSManaged var bottomText: String?
    @NSManaged var memedImage: NSData?
    @NSManaged var rawImage: NSData?
    @NSManaged var topText: String?
    @NSManaged var topTextFont: String?
    @NSManaged var topTextFontSize: NSNumber?
    @NSManaged var bottomTextFont: String?
    @NSManaged var bottomTextFontSize: NSNumber?

}
