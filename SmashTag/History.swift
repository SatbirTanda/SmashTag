//
//  RecentTweetsHistory.swift
//  SmashTag
//
//  Created by Satbir Tanda on 5/6/15.
//  Copyright (c) 2015 Satbir Tanda. All rights reserved.
//

import Foundation

struct History {
    
    private static let Key = "History"
    private static var Times: [NSDate] = []
    
    static func GetSearchHistory() -> [String] {
        if let history = NSUserDefaults.standardUserDefaults().objectForKey(Key) as? [String] {
            return history
        } else {
            let history: [String] = []
            NSUserDefaults.standardUserDefaults().setObject(history, forKey: Key)
            return NSUserDefaults.standardUserDefaults().objectForKey(Key) as! [String]
        }
    }
    
    static func AddRecentSearch(search: String) {
        if search != "" {
            if var history = NSUserDefaults.standardUserDefaults().objectForKey(Key) as? [String] {
                if history.count > 100 {
                    history.removeAtIndex(0)
                }
                history.append(search)
                NSUserDefaults.standardUserDefaults().setObject(history, forKey: Key)
            }
        }
    }
    
    static func DeleteRecentSearch(index: Int) {
        if var history = NSUserDefaults.standardUserDefaults().objectForKey(Key) as? [String] {
            history = history.reverse()
            history.removeAtIndex(index)
            NSUserDefaults.standardUserDefaults().setObject(history.reverse(), forKey: Key)
        }
    }

}