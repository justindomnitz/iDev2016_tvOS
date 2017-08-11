//
//  TwitterInterface.swift
//  restaurant-reports
//
//  Created by Justin Domnitz on 7/31/16.
//  Copyright © 2016 Lowyoyo, LLC. All rights reserved.
//
//  This Twitter Interface leverage app-level access to query Twitter.
//  This is required for tvOS since access no native Twitter account access.

import Foundation

class TwitterInterface {
    
    /******************************************************************************/
    /*                                                                            */
    /* requestTwitterSearchResults                                                */
    /*                                                                            */
    /******************************************************************************/
    
    func requestTwitterSearchResults(twitterSearch:String, completion: (tweets: [Tweet]?, error: NSError?) -> Void) {
        
        //
        //Get the bearer token...
        //
        
        let sessionConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()

        //idev2016
        
        let consumerKey = "6S4NXilPssIavciPF1cjbGPHH"
        let consumerSecret = "y8GLmeOvwu8WUMm2PxL7TB5buQhnoX4ltnQDHnlVoz0k81CR4N"
        let escapedString = consumerKey + ":" + consumerSecret
        let data = escapedString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64encoded = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
        
        sessionConfig.HTTPAdditionalHeaders =
            ["Authorization": "Basic \(base64encoded!)"]
        
        let session = NSURLSession(configuration: sessionConfig)
        let serviceUrl = NSURL(string:"https://api.twitter.com/oauth2/token")
        let request = NSMutableURLRequest.init(URL: serviceUrl!)
        request.HTTPMethod = "POST"
        let dataString = "grant_type=client_credentials"
        let theData = dataString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        let _ = session.uploadTaskWithRequest(request, fromData: theData,  completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("Twitter returned error: \(error!.localizedDescription); \(error!)")
                completion(tweets: nil, error: error)
                return
            }
            do {
                let tokenJson = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                self.parseTwitterToken(tokenJson, completion:{ bearerToken, error in
                    //TO-DO: Improved errr handling
                    
                    if bearerToken != nil {
                    
                        //
                        //Get the Twitter search results using the bearer token...
                        //
                        
                        let sessionConfigSearch = NSURLSessionConfiguration.ephemeralSessionConfiguration()

                        sessionConfigSearch.HTTPAdditionalHeaders =
                            ["Authorization": "Bearer \(bearerToken!)"]
                        let sessionSearch = NSURLSession(configuration: sessionConfigSearch)
                        let serviceUrlSearch =
                            NSURL(string:"https://api.twitter.com/1.1/search/tweets.json?q=" +
                                twitterSearch.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
                        let requestSearch = NSMutableURLRequest.init(URL: serviceUrlSearch!)
                        requestSearch.HTTPMethod = "GET"
                        let _ = sessionSearch.dataTaskWithRequest(requestSearch, completionHandler: { (data, response, error) -> Void in
                            if (error != nil) {
                                print("Twitter returned error: \(error!.localizedDescription); \(error!)")
                                completion(tweets: nil, error: error)
                                return
                            }
                            do {
                                let searchJson = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                                self.parseTwitterSearchResults(searchJson, completion:{ tweets, error in
                                    //TO-DO: Error handling
                                    
                                    //print(tweets)
                                    completion(tweets: tweets, error: nil)
                                })
                            }
                            catch let caught { // JSONObjectWithData failed
                                let strData = NSString.init(data: data!, encoding: NSUTF8StringEncoding)
                                print(strData)
                                let error = NSError(domain: "Error - \("TBD") \(caught)", code: 0, userInfo: nil)
                                completion(tweets: nil, error: error)
                                return
                            }
                        })
                        .resume()
                        
                    }
                    
                })
            }
            catch let caught { // JSONObjectWithData failed
                let strData = NSString.init(data: data!, encoding: NSUTF8StringEncoding)
                print(strData)
                let error = NSError(domain: "Error - \("TBD") \(caught)", code: 0, userInfo: nil)
                completion(tweets: nil, error: error)
                return
            }
        })
        .resume()
    }
    
    /******************************************************************************/
    /*                                                                            */
    /* parseTwitterToken                                                          */
    /*                                                                            */
    /******************************************************************************/
    
    func parseTwitterToken(json: NSDictionary, completion: (token: String?, error: NSError?) -> Void) {
        if let token = json["access_token"] as? String {
            completion(token: token, error: nil)
        }
        else {
            completion(token: nil, error: nil)
        }
    }
    
    /******************************************************************************/
    /*                                                                            */
    /* parseTwitterSearchResults                                                  */
    /*                                                                            */
    /******************************************************************************/
    
    func parseTwitterSearchResults(json: NSDictionary, completion: (tweets: [Tweet]?, error: NSError?) -> Void) {
        var tweets = [Tweet]()
        var tweetArray: NSArray?
        if let tweets = json[TwitterKey.Tweets] as? NSArray {
            tweetArray = tweets
        } else if let tweet = Tweet(data: json) {
            tweets = [tweet]
        }
        if tweetArray != nil {
            for tweetData in tweetArray! {
                if let tweet = Tweet(data: tweetData as? NSDictionary) {
                    tweets.append(tweet)
                }
            }
        }
        completion(tweets: tweets, error: nil)
    }
    
}
