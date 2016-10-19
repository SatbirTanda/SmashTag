//
//  TweetMentionsTableViewController.swift
//  SmashTag
//
//  Created by Satbir Tanda on 5/1/15.
//  Copyright (c) 2015 Satbir Tanda. All rights reserved.
//

import UIKit

class TweetMentionsTableViewController: UITableViewController {

    
    var tweet: Tweet? {
        didSet {
            if (tweet?.urls.count > 0) {
                mentionsInTweet.append(ItemType.NonMedia(tweet!.urls, TweetTypeConstant.Url))
            }
            if (tweet?.hashtags.count > 0) {
                mentionsInTweet.append(ItemType.NonMedia(tweet!.hashtags, TweetTypeConstant.Hashtag))
            }
            if (tweet?.userMentions.count > 0) {
                mentionsInTweet.append(ItemType.NonMedia(tweet!.userMentions, TweetTypeConstant.UserMention))
            }
            if (tweet?.media.count > 0) {
                mentionsInTweet.append(ItemType.Media(tweet!.media, TweetTypeConstant.MediaItem))
            }
        }
    }
    
    private var mentionsInTweet = [ItemType]()
    
    private enum ItemType: Printable {
        case NonMedia([Tweet.IndexedKeyword], String)
        case Media([MediaItem], String)
        
        var description: String {
            switch self {
            case .NonMedia(_, let type):
                return type
            case .Media(_, let type):
                return type
            }
        }
        
        func count() -> Int {
            switch self {
            case .NonMedia(let nonMediaItem, _):
                return nonMediaItem.count
            case .Media(let mediaItem, _):
                return mediaItem.count
            }
        }
        
        func keywordForItem(row: Int) -> String? {
            switch self {
            case .NonMedia(let keywords, _):
                return keywords[row].keyword
            case .Media(let mediaItem, _):
                return String(stringInterpolationSegment: mediaItem[row].url)
            }
        }
        
        subscript(index: Int) -> Any {
            get {
                switch self {
                case .NonMedia(let keywords, _):
                    return keywords[index]
                case .Media(let mediaItems, _):
                    return mediaItems[index]
                }
            }
        }
    }
    
    private struct TweetTypeConstant {
        static let Url = "URLs"
        static let Hashtag = "HashTags"
        static let UserMention = "UserMentions"
        static let MediaItem = "MediaItems"
        static let UnknownItem = "Unknown Item"
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return mentionsInTweet.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return mentionsInTweet[section].count()
    }

    private struct CellIdentifiers {
        static let NonMediaItem = "NonMediaItem"
        static let MediaItem = "MediaItem"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if mentionsInTweet[indexPath.section].description == TweetTypeConstant.MediaItem {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.MediaItem, forIndexPath: indexPath) as! TweetImageTableViewCell
            if let image = mentionsInTweet[indexPath.section][indexPath.row] as? MediaItem {
                cell.imageURL = image.url
                cell.aspectRatio = image.aspectRatio
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.NonMediaItem, forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = mentionsInTweet[indexPath.section].keywordForItem(indexPath.row)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentionsInTweet[section].description
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if mentionsInTweet[indexPath.section].description == TweetTypeConstant.MediaItem {
            if let mediaItem = mentionsInTweet[indexPath.section][indexPath.row] as? MediaItem {
                return CGFloat(250*mediaItem.aspectRatio)
                //resize image to aspectRatio
                //figure out how to resize cell to height of image
            }
        }
        return UITableViewAutomaticDimension
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if mentionsInTweet[indexPath.section].description == TweetTypeConstant.Url {
            if let urlKey = mentionsInTweet[indexPath.section].keywordForItem(indexPath.row) {
                if let url = NSURL(string: urlKey) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
        }
    }
    
    // MARK: - Navigation

    private struct SegueIdentifiers {
        static let RecentTweets = "Recent Tweets"
        static let ShowImage = "Show Twitter Picture"
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let cell = sender as? UITableViewCell {
            if let indexPath = tableView .indexPathForCell(cell) {
                if mentionsInTweet[indexPath.section].description == TweetTypeConstant.Url {
                    return false
                }
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? TweetImageTableViewCell {
            if let identifer = segue.identifier {
                if identifer == SegueIdentifiers.ShowImage {
                    if let tpvc = segue.destinationViewController as? TwitterPictureViewController {
                        if cell.imageViewForTweet.image != nil {
                            tpvc.image = cell.imageViewForTweet.image
                        }
                        if cell.imageURL != nil {
                            tpvc.title =  String(stringInterpolationSegment: cell.imageURL!)
                        } else {
                            tpvc.title = "Nil"
                        }
                        tpvc.navigationController?.navigationItem.backBarButtonItem?.title = self.title
                    }
                }
            }
        } else if let cell = sender as? UITableViewCell {
            if let identifer = segue.identifier {
                if identifer == SegueIdentifiers.RecentTweets {
                    if let ttvc = segue.destinationViewController as? TweetTableViewController {
                        ttvc.searchText = cell.textLabel?.text
                    }
                }
            }
        }
    }

}
