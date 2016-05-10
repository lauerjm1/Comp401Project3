//
//  Reminder.swift
//  Project3
//
//  Created by Jon Lauer on 4/22/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import UIKit

extension NSDate {
    func timeIntervalFromReferenceDateToThisDate() -> NSTimeInterval {
        return self.timeIntervalSinceDate(NSDate(timeIntervalSinceReferenceDate: 0))
    }
}

class Reminder: NSObject {
    var time:NSTimeInterval = 0
    var title:String!
    var activated:Bool = false
    var uid:String!
    
    var volume: Int = 0
}

class ReminderRepo {
    var list = Array<Reminder>() {
        didSet {
            if(saving) {
                let pathName = libPath.stringByAppendingPathComponent("reminders.dat")
                do {
                    var dictList = Array<Dictionary<String,AnyObject>>()
                    for rem in list {
                        dictList.append(interpretReminderToDict(rem))
                    }
                    let data = try NSJSONSerialization.dataWithJSONObject(dictList, options: NSJSONWritingOptions())
                    data.writeToFile(pathName, atomically: true)
                } catch {}
            }
        }
    }
    
    var saving = false
    let libPath:NSString = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
    
    static let singleton = ReminderRepo()
    
    private init() {
        let pathName = libPath.stringByAppendingPathComponent("reminders.dat")
        if NSFileManager.defaultManager().fileExistsAtPath(pathName) {
            let dat = NSData(contentsOfFile: pathName)
            do {
                let obj = try NSJSONSerialization.JSONObjectWithData(dat!, options: NSJSONReadingOptions.MutableContainers) as! Array<Dictionary<String,AnyObject>>
                for dict in obj {
                    list.append(interpretDictToReminder(dict))
                }
            } catch {}
        }
        saving = true
    }
    
    func interpretDictToReminder(dict:Dictionary<String,AnyObject>) -> Reminder {
        let rem = Reminder()
        for (k,v) in dict {
            if rem.respondsToSelector(NSSelectorFromString(k)) {
                rem.setValue(v, forKey: k)
            }
        }
        return rem
    }
    
    func interpretReminderToDict(rem:Reminder) -> Dictionary<String,AnyObject> {
        var dict = Dictionary<String,AnyObject>()
        dict.updateValue(rem.time, forKey: "time")
        dict.updateValue(rem.title, forKey: "title")
        dict.updateValue(rem.activated, forKey: "activated")
        dict.updateValue(rem.uid, forKey: "uid")
        dict.updateValue(rem.volume, forKey: "volume")
        return dict
    }
    
}