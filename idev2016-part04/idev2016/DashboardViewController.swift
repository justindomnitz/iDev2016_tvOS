//
//  DashboardViewController.swift
//  idev2016
//
//  Created by Justin Domnitz on 7/31/16.
//  Copyright © 2016 Lowyoyo, LLC. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Collection View
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("dashboardCollectionCell", forIndexPath: indexPath) as? DashboardCollectionViewCell {
            
            cell.backgroundColor = UIColor.brownColor()
            cell.number.text = "\(indexPath.row)"

            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    // MARK: - UIFocusEnvironment
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
        
        if let previousItem = context.previouslyFocusedView as? DashboardCollectionViewCell {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                previousItem.backgroundColor = UIColor.brownColor()
            })
        }
        if let nextItem = context.nextFocusedView as? DashboardCollectionViewCell {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                nextItem.backgroundColor = UIColor(red: 51 / 100, green: 67 / 100, blue: 49 / 100, alpha: 0.8)
            })
        }
    }

}
