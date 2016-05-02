//
//  MemeOperation.swift
//  MemeMe_1.0
//
//  Created by Andy Xu on 16/4/27.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MemeOperation: NSObject {
    var fetchResultController: NSFetchedResultsController?
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    convenience init(delegate: NSFetchedResultsControllerDelegate) {
        self.init()
        let fetchRequest = NSFetchRequest(entityName: "Meme")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "topText", ascending: true)]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController!.delegate = delegate
    }
    
    func fetchMeme() {
        try! fetchResultController?.performFetch()
    }
    
    func save() {
        try! moc.save()
    }
    
    func insertMeme(topText: String?, bottomText: String?, rawImage: UIImage, memedImage: UIImage, topTextFont: String, topTextFontSize: CGFloat, bottomTextFont: String, bottomTextFontSize: CGFloat) {
        let meme = NSEntityDescription.insertNewObjectForEntityForName("Meme", inManagedObjectContext: moc) as! Meme
        
        meme.topText = topText
        meme.bottomText = bottomText
        meme.rawImage = UIImagePNGRepresentation(rawImage)
        meme.memedImage = UIImagePNGRepresentation(memedImage)
        meme.topTextFont = topTextFont
        meme.topTextFontSize = NSNumber(float: Float(topTextFontSize))
        meme.bottomTextFont = bottomTextFont
        meme.bottomTextFontSize = NSNumber(float: Float(bottomTextFontSize))
        
        moc.insertObject(meme)

        save()
    }
    
    func updateMeme(meme: Meme, topText: String?, bottomText: String?, rawImage: UIImage, memedImage: UIImage, topTextFont: String, topTextFontSize: CGFloat, bottomTextFont: String, bottomTextFontSize: CGFloat) {
        meme.topText = topText
        meme.bottomText = bottomText
        meme.rawImage = UIImagePNGRepresentation(rawImage)
        meme.memedImage = UIImagePNGRepresentation(memedImage)
        meme.topTextFont = topTextFont
        meme.topTextFontSize = NSNumber(float: Float(topTextFontSize))
        meme.bottomTextFont = bottomTextFont
        meme.bottomTextFontSize = NSNumber(float: Float(bottomTextFontSize))
        
        save()
    }
    
    func deleteMeme(meme: Meme) {
        moc.deleteObject(meme)
        
        save()
    }
}