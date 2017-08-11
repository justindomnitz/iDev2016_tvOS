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
    
    var tweets = [[Tweet]]()
    var hashtag = "360idev"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let value = NSUserDefaults.standardUserDefaults().valueForKey("hashtag") as? String {
            hashtag = value
        }
        
        //Table View
        twitterTableView.delegate = self
        twitterTableView.dataSource = self
        
        //Collection View
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        getTwitterData()
    }
    
    func getTwitterData() {
        TwitterInterface().requestTwitterSearchResults(hashtag, completion: { (tweets, error) -> Void in
            //TO-DO: Error handling.
            if error == nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.tweets.insert(tweets!, atIndex: 0)
                    self.twitterTableView.reloadData()
                })
            }
        })
    }

    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows = 0
        if tweets.count > section {
            numRows = tweets[section].count
        }
        return numRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("TwitterCell", forIndexPath: indexPath) as? TweetTableViewCell {
            
            cell.backgroundColor = UIColor.brownColor()
            cell.tweet = tweets[indexPath.section][indexPath.row]
            
            return cell
        }
    
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

