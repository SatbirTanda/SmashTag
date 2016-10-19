//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Satbir Tanda on 4/18/15.
//  Copyright (c) 2015 Satbir Tanda. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell
{
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameTextLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    private struct Constants {
        static let urlColor = UIColor.blueColor()
        static let hashtagColor = UIColor.orangeColor()
        static let userMentionColor = UIColor.purpleColor()
        static let urlKeyword = "http://"
        static let hashtagKeyword = "#"
        static let userMentionKeyword = "@"
    }
    
    
    private func updateUI() {
        tweetTextLabel?.attributedText = nil
        tweetScreenNameTextLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
                
                let indexedKeywords = tweet.urls + tweet.userMentions + tweet.hashtags
                for indexedKeyword in indexedKeywords {
                    //println(indexedKeyword.description)
                    var attributedString = tweetTextLabel.attributedText as! NSMutableAttributedString
                    if indexedKeyword.keyword.hasPrefix(Constants.urlKeyword) {
                        attributedString.addAttribute(NSForegroundColorAttributeName,
                            value: Constants.urlColor,
                            range: indexedKeyword.nsrange)
                    } else if indexedKeyword.keyword.hasPrefix(Constants.hashtagKeyword) {
                        attributedString.addAttribute(NSForegroundColorAttributeName,
                            value: Constants.hashtagColor,
                            range: indexedKeyword.nsrange)
                    } else if indexedKeyword.keyword.hasPrefix(Constants.userMentionKeyword) {
                        attributedString.addAttribute(NSForegroundColorAttributeName,
                            value: Constants.userMentionColor,
                            range: indexedKeyword.nsrange)

                    }
                    tweetTextLabel.attributedText = attributedString
                }
            }
        }
        
        tweetScreenNameTextLabel?.text = "\(tweet!.user)" // tweet user description
        
        if let profileImageURL = tweet?.user.profileImageURL {
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            let queue = dispatch_get_global_queue(qos, 0)
            dispatch_async(queue) {
                if let imageData = NSData(contentsOfURL: profileImageURL) {
                    dispatch_async(dispatch_get_main_queue()) {
                        tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        let formatter = NSDateFormatter()
        if NSDate().timeIntervalSinceDate(tweet!.created) > 24*60*60 {
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        } else {
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        }
        tweetCreatedLabel?.text = formatter.stringFromDate(tweet!.created)
        
    }
    
    
}
