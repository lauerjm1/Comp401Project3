//
//  Alarm.swift
//  Project3
//
//  Created by Jon Lauer on 4/22/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import UIKit

class Alarm: NSObject {

    var time: Int!
    var daysOfWeek: [String]!
    var activated: Bool!
    var title: String!
    // TODO: - Figure out if this is Double or some other type
    var volume: Int!

}

class AlarmRepo {
    var list = Dictionary<String,Dictionary<String,AnyObject>>()
    let libPath:NSString = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
    
    static let singleton = AlarmRepo()
    
    private init() {
        let pathName = libPath.stringByAppendingPathComponent("alarms.dat")
        if NSFileManager.defaultManager().fileExistsAtPath(pathName) {
            let dat = NSData(contentsOfFile: pathName)
            do {
                let obj = try NSJSONSerialization.JSONObjectWithData(dat!, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String,Dictionary<String,AnyObject>>
                list = obj
            } catch {}
        }
    }
    
    func interpretAlarm(dict:Dictionary<String,AnyObject>) -> Alarm {
        let alm = Alarm()
        for(k,v) in dict {
            if alm.respondsToSelector(NSSelectorFromString(k)) {
                alm.setValue(v, forKey: k)
            }
        }
        return alm
    }
    
    func addAlarmToRepo(name:String,alm:Alarm) {
        list.removeValueForKey(name)
        var keyVal = Dictionary<String,AnyObject>()
        keyVal.updateValue(alm.time, forKey: "time")
        keyVal.updateValue(alm.daysOfWeek, forKey: "daysOfWeek")
        keyVal.updateValue(alm.activated, forKey: "activated")
        keyVal.updateValue(alm.title, forKey: "title")
        keyVal.updateValue(alm.volume, forKey: "volume")
        list.updateValue(keyVal, forKey: name)
        let pathName = libPath.stringByAppendingPathComponent("alarms.dat")
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(list, options: NSJSONWritingOptions())
            data.writeToFile(pathName, atomically: true)
        } catch {}
    }
    
    func deleteAlarmFromRepo(name:String) {
        list.removeValueForKey(name)
        let pathName = libPath.stringByAppendingPathComponent("alarms.dat")
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(list, options: NSJSONWritingOptions())
            data.writeToFile(pathName, atomically: true)
        } catch {}
    }
}
