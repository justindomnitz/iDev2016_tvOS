//
//  IDevViewController.swift
//  idev2016
//
//  Created by Justin Domnitz on 6/29/16.
//  Copyright © 2016 Lowyoyo, LLC. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var twitterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table View
        twitterTableView.delegate = self
        twitterTableView.dataSource = self
        
        //Collection View
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRows = 0
        return numRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("homeCollectionCell", forIndexPath: indexPath) as? HomeCollectionViewCell {
            
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
        
        if let previousItem = context.previouslyFocusedView as? HomeCollectionViewCell {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                previousItem.backgroundColor = UIColor.brownColor()
            })
        }
        if let nextItem = context.nextFocusedView as? HomeCollectionViewCell {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                nextItem.backgroundColor = UIColor(red: 51 / 100, green: 67 / 100, blue: 49 / 100, alpha: 0.8)
            })
        }
    }
}

