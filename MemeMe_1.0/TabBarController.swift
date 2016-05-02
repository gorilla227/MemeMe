//
//  TabBarController.swift
//  MemeMe_1.0
//
//  Created by Andy on 16/5/1.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit
import CoreData

class TabBarController: UITabBarController, NSFetchedResultsControllerDelegate {
    var memeOperation: MemeOperation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadMemes()
    }
    
    func loadMemes() {
        memeOperation = MemeOperation(delegate: self)
        let queue = NSOperationQueue()
        let fetchOP = NSBlockOperation {
            self.memeOperation?.fetchMeme()
        }
        let refreshOP = NSBlockOperation {
            self.refreshDataView()
        }
        
        refreshOP.addDependency(fetchOP)
        queue.addOperation(fetchOP)
        NSOperationQueue.mainQueue().addOperation(refreshOP)
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        refreshDataView()
    }
    
    func refreshDataView() {
        for selectedVC in viewControllers! {
            if selectedVC.isMemberOfClass(ListVC) {
                (selectedVC as! ListVC).tableView.reloadData()
            }
            
            if selectedVC.isMemberOfClass(CollectionVC) {
                (selectedVC as! CollectionVC).collectionView?.reloadData()
            }
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddMeme" {
            let detailVC = segue.destinationViewController as! DetailVC
            detailVC.memeOperation = memeOperation
        }
    }
}
