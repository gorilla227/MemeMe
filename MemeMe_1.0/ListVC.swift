//
//  ListVC.swift
//  MemeMe_1.0
//
//  Created by Andy Xu on 16/4/26.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit
import CoreData

class ListVC: UITableViewController, NSFetchedResultsControllerDelegate {
    var memeOperation: MemeOperation {
        return (tabBarController as! TabBarController).memeOperation!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)

//        loadMemes()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
//    func loadMemes() {
//        memeOperation = MemeOperation(delegate: self)
//        let queue = NSOperationQueue()
//        let fetchOP = NSBlockOperation { 
//            self.memeOperation?.fetchMeme()
//        }
//        let refreshOP = NSBlockOperation { 
//            self.tableView.reloadData()
//        }
//    
//        refreshOP.addDependency(fetchOP)
//        queue.addOperation(fetchOP)
//        NSOperationQueue.mainQueue().addOperation(refreshOP)
//    }
    
//    func controllerDidChangeContent(controller: NSFetchedResultsController) {
//        tableView.reloadData()
//    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let allMemes = memeOperation.fetchResultController?.fetchedObjects {
            return allMemes.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell", forIndexPath: indexPath)
        let cellData: Meme = memeOperation.fetchResultController?.objectAtIndexPath(indexPath) as! Meme
        // Configure the cell...
        cell.textLabel?.text = cellData.topText
        cell.detailTextLabel?.text = cellData.bottomText
        cell.imageView?.image = UIImage(data: cellData.memedImage!)
        
        cell.textLabel?.font = UIFont(name: cellData.topTextFont!, size: CGFloat(cellData.topTextFontSize!))
        cell.detailTextLabel?.font = UIFont(name: cellData.bottomTextFont!, size: CGFloat(cellData.bottomTextFontSize!))
        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let meme = memeOperation.fetchResultController?.objectAtIndexPath(indexPath) as! Meme
            memeOperation.deleteMeme(meme)
        } 
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "ViewMemo":
            let detailVC = segue.destinationViewController as! DetailVC
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            detailVC.meme = memeOperation.fetchResultController?.objectAtIndexPath(indexPath!) as? Meme
            detailVC.memeOperation = memeOperation
            
        case "AddMeme":
            let detailVC = segue.destinationViewController as! DetailVC
            detailVC.memeOperation = memeOperation
        default:
            break
        }
    }
}
