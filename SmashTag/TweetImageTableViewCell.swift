//
//  TweetImageTableViewCell.swift
//  SmashTag
//
//  Created by Satbir Tanda on 5/3/15.
//  Copyright (c) 2015 Satbir Tanda. All rights reserved.
//

import UIKit

class TweetImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewForTweet: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    var imageURL: NSURL? {
        didSet{
            updateUI()
        }
    }
    
    var aspectRatio: Double?
    
    private var tweetImage: UIImage? {
        didSet {
            if self.tweetImage != nil {
                imageViewForTweet.image = self.tweetImage
                imageViewForTweet.sizeToFit()
                activityIndicator.stopAnimating()
            }
        }
    }
    
    private func updateUI()
    {
        if let tweetURL = imageURL {
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                let queue = dispatch_get_global_queue(qos, 0)
                activityIndicator.startAnimating()
                dispatch_async(queue) {
                    if let imageData = NSData(contentsOfURL: tweetURL) {
                        dispatch_async(dispatch_get_main_queue()) {
                            if tweetURL == self.imageURL {
                                self.tweetImage = UIImage(data: imageData)
                            } else {
                                self.tweetImage = nil
                            }
                        }
                    }
                }
        }
    }
    
}
