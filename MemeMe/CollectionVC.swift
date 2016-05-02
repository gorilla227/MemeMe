//
//  CollectionVC.swift
//  MemeMe_1.0
//
//  Created by Andy on 16/5/1.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}


class CollectionVC: UICollectionViewController {
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var memeOperation: MemeOperation {
        return (tabBarController as! TabBarController).memeOperation!
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupFlowLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        setupFlowLayout()
    }
    
    func setupFlowLayout() {
        let orientation = UIDevice.currentDevice().orientation
        let space: CGFloat = 3
        let dimension = (view.frame.size.width - 2 * space) / (orientation.isPortrait ? 3.0 : 6.0)
        
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewMeme" {
            let detailVC = segue.destinationViewController as! DetailVC
            let indexPath = collectionView!.indexPathForCell(sender as! UICollectionViewCell)
            detailVC.meme = memeOperation.fetchResultController?.objectAtIndexPath(indexPath!) as? Meme
            detailVC.memeOperation = memeOperation
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let allMemes = memeOperation.fetchResultController?.fetchedObjects {
            return allMemes.count
        } else {
            return 0
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionCell
        let cellData: Meme = memeOperation.fetchResultController?.objectAtIndexPath(indexPath) as! Meme
        // Configure the cell
        cell.imageView?.image = UIImage(data: cellData.memedImage!)
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
