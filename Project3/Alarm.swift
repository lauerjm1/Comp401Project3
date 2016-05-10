//
//  Alarm.swift
//  Project3
//
//  Created by Jon Lauer on 4/22/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import UIKit

class Alarm: NSObject {
    var hour: Int = 0
    var minute: Int = 0
    var daysOfWeek = [false,false,false,false,false,false,false]
    var activated: Bool = false
    var title: String!
    var uid:[String] = ["","","","","","",""]
    
    var volume: Int = 0
}

class AlarmRepo {
    var list = Array<Alarm>() {
        didSet {
            if(saving) {
                let pathName = libPath.stringByAppendingPathComponent("alarms.dat")
                do {
                    var dictList = Array<Dictionary<String,AnyObject>>()
                    for alm in list {
                        dictList.append(interpretAlarmToDict(alm))
                    }
                    let data = try NSJSONSerialization.dataWithJSONObject(dictList, options: NSJSONWritingOptions())
                    data.writeToFile(pathName, atomically: true)
                } catch {}
            }
        }
    }
    
    var saving = false
    let libPath:NSString = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
    
    static let singleton = AlarmRepo()
    
    private init() {
        let pathName = libPath.stringByAppendingPathComponent("alarms.dat")
        //NSLog(pathName)
        if NSFileManager.defaultManager().fileExistsAtPath(pathName) {
            let dat = NSData(contentsOfFile: pathName)
            do {
                let obj = try NSJSONSerialization.JSONObjectWithData(dat!, options: NSJSONReadingOptions.MutableContainers) as! Array<Dictionary<String,AnyObject>>
                for dict in obj {
                    list.append(interpretDictToAlarm(dict))
                }
            } catch {}
        }
        saving = true
    }
    
    func interpretDictToAlarm(dict:Dictionary<String,AnyObject>) -> Alarm {
        let alm = Alarm()
        for(k,v) in dict {
            if alm.respondsToSelector(NSSelectorFromString(k)) {
                alm.setValue(v, forKey: k)            }
        }
        return alm
    }
    
    func interpretAlarmToDict(alm:Alarm) -> Dictionary<String,AnyObject> {
        var dict = Dictionary<String,AnyObject>()
        dict.updateValue(alm.hour, forKey: "hour")
        dict.updateValue(alm.minute, forKey: "minute")
        dict.updateValue(alm.daysOfWeek, forKey: "daysOfWeek")
        dict.updateValue(alm.activated, forKey: "activated")
        dict.updateValue(alm.title, forKey: "title")
        dict.updateValue(alm.uid, forKey: "uid")
        dict.updateValue(alm.volume, forKey: "volume")
        return dict
    }
    
}
