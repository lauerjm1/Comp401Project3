//
//  Reminder.swift
//  Project3
//
//  Created by Jon Lauer on 4/22/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import UIKit

class Reminder: NSObject {

    // FIXME: - Should this be a date? I couldn't remember.
    var time: Int!
    var title: String!
    // FIXME: - Again, double or int?
    var volume: Int!

}

class ReminderRepo {
    var list = Dictionary<String,Dictionary<String,AnyObject>>()
    let libPath:NSString = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
    
    static let singleton = ReminderRepo()
    
    private init() {
        let pathName = libPath.stringByAppendingPathComponent("reminders.dat")
        if NSFileManager.defaultManager().fileExistsAtPath(pathName) {
            let dat = NSData(contentsOfFile: pathName)
            do {
                let obj = try NSJSONSerialization.JSONObjectWithData(dat!, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String,Dictionary<String,AnyObject>>
                list = obj
            } catch {}
        }
    }
    
    func interpretReminder(dict:Dictionary<String,AnyObject>) -> Reminder {
        let rem = Reminder()
        for (k,v) in dict {
            if rem.respondsToSelector(NSSelectorFromString(k)) {
                rem.setValue(v, forKey: k)
            }
        }
        return rem
    }
    
    func addReminderToRepo(rem:Reminder) {
        list.removeValueForKey(rem.title)
        var keyVal = Dictionary<String,AnyObject>()
        keyVal.updateValue(rem.time, forKey: "time")
        keyVal.updateValue(rem.title, forKey: "title")
        keyVal.updateValue(rem.volume, forKey: "volume")
        list.updateValue(keyVal, forKey: rem.title)
        let pathName = libPath.stringByAppendingPathComponent("reminders.dat")
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(list, options: NSJSONWritingOptions())
            data.writeToFile(pathName, atomically: true)
        } catch {}
    }
    
    func deleteReminderFromRepo(name:String) {
        list.removeValueForKey(name)
        let pathName = libPath.stringByAppendingPathComponent("reminders.dat")
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(list, options: NSJSONWritingOptions())
            data.writeToFile(pathName, atomically: true)
        } catch {}
    }
}