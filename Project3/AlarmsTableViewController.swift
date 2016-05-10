//
//  AlarmsTableViewController.swift
//  Project3
//
//  Created by Jon Lauer on 4/22/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import UIKit

class AlarmsTableViewController: UITableViewController {
    
    let activeColor = UIColor.blackColor()
    let inactiveColor = UIColor.lightGrayColor()
    var currentRow:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            deleteAlarm(AlarmRepo.singleton.list[indexPath.row])
            AlarmRepo.singleton.list.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmRepo.singleton.list.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentRow = indexPath.row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("editAlarm", sender: tableView.cellForRowAtIndexPath(indexPath))
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath) as! AlarmCell
        if indexPath.row < AlarmRepo.singleton.list.count {
            let alm = AlarmRepo.singleton.list[indexPath.row]
            cell.hourLabel.text = String(alm.hour)
            cell.minuteLabel.text = String(alm.minute)
            if alm.daysOfWeek[0] == true && alm.activated {
                cell.sunLabel.textColor = activeColor
            } else {
                cell.sunLabel.textColor = inactiveColor
            }
            if alm.daysOfWeek[1] == true && alm.activated {
                cell.monLabel.textColor = activeColor
            } else {
                cell.monLabel.textColor = inactiveColor
            }
            if alm.daysOfWeek[2] == true && alm.activated {
                cell.tueLabel.textColor = activeColor
            } else {
                cell.tueLabel.textColor = inactiveColor
            }
            if alm.daysOfWeek[3] == true && alm.activated {
                cell.wedLabel.textColor = activeColor
            } else {
                cell.wedLabel.textColor = inactiveColor
            }
            if alm.daysOfWeek[4] == true && alm.activated {
                cell.thuLabel.textColor = activeColor
            } else {
                cell.thuLabel.textColor = inactiveColor
            }
            if alm.daysOfWeek[5] == true && alm.activated {
                cell.friLabel.textColor = activeColor
            } else {
                cell.friLabel.textColor = inactiveColor
            }
            if alm.daysOfWeek[6] == true && alm.activated {
                cell.satLabel.textColor = activeColor
            } else {
                cell.satLabel.textColor = inactiveColor
            }
            if alm.activated {
                cell.hourLabel.textColor = activeColor
                cell.colonLabel.textColor = activeColor
                cell.minuteLabel.textColor = activeColor
            } else {
                cell.hourLabel.textColor = inactiveColor
                cell.colonLabel.textColor = inactiveColor
                cell.minuteLabel.textColor = inactiveColor
            }
        }
        return cell
    }
    
    @IBAction func saveAlarmToTable(segue:UIStoryboardSegue) {
        let source = segue.sourceViewController as! AlarmVC
        if source.creating {
            setUpAlarm(source.alarm)
        } else {
            updateAlarm(source.alarm)
        }
        tableView.reloadData()
    }
    
    func setUpAlarm(alarm:Alarm) {
        for i in 0..<7 {
            alarm.uid[i] = NSUUID().UUIDString
        }
        if alarm.activated {
            createNotifications(forAlarm: alarm)
        }
        AlarmRepo.singleton.list.append(alarm)
    }
    
    func updateAlarm(alarm:Alarm) {
        if alarm.activated {
            deleteNotifications(forAlarm: alarm)
            createNotifications(forAlarm: alarm)
        } else {
            deleteNotifications(forAlarm: alarm)
        }
        AlarmRepo.singleton.list[currentRow] = alarm
    }
    
    func deleteAlarm(alarm:Alarm) {
        if alarm.activated {
            deleteNotifications(forAlarm: alarm)
        }
    }
    
    func nextDayOfType(day:Int,hour:Int,minute:Int) -> (year:Int,month:Int,week:Int) {
        let comps = NSDateComponents()
        let flags:NSCalendarUnit = [.WeekOfYear, .Month, .Year]
        let today = NSDate()
        let todayComps = NSCalendar.currentCalendar().components(flags, fromDate: today)
        comps.minute = minute
        comps.hour = hour
        comps.weekday = day+1
        comps.weekOfYear = todayComps.weekOfYear
        comps.month = todayComps.month
        comps.year = todayComps.year
        let thisWeeksDay = NSCalendar.currentCalendar().dateFromComponents(comps)
        let result = today.compare(thisWeeksDay!)
        if result == NSComparisonResult.OrderedAscending {
            //thisWeeksDay is after today
            //alarm should fire *this* week
            return (todayComps.year, todayComps.month, todayComps.weekOfYear)
        } else {
            //thisWeeksDay is before today
            //alarm should fire *next* week
            let oneWeekIncrement = NSDateComponents()
            oneWeekIncrement.weekOfYear = 1
            let nextWeeksDay = NSCalendar.currentCalendar().dateByAddingComponents(oneWeekIncrement, toDate: thisWeeksDay!, options: NSCalendarOptions())
            let nextWeeksDayComps = NSCalendar.currentCalendar().components(flags, fromDate: nextWeeksDay!)
            return (nextWeeksDayComps.year, nextWeeksDayComps.month, nextWeeksDayComps.weekOfYear)
        }
    }
    
    func createNotifications(forAlarm alarm:Alarm) {
        for k in 0..<7 {
            if alarm.daysOfWeek[k] {
                let nextDay = nextDayOfType(k, hour: alarm.hour, minute: alarm.minute)
                let comps = NSDateComponents()
                comps.year = nextDay.year
                comps.month = nextDay.month
                comps.weekOfYear = nextDay.week
                comps.weekday = k+1 // TURNS OUT SWIFT NSDATE WEEKDAYS ARE 1-INDEXED, NOT 0-INDEXED
                comps.hour = alarm.hour
                comps.minute = alarm.minute
                let alarmDate = NSCalendar.currentCalendar().dateFromComponents(comps)
                let note = UILocalNotification()
                note.fireDate = alarmDate
                note.alertAction = "Alarm!"
                note.alertBody = alarm.title
                note.userInfo?.updateValue(alarm.uid[k], forKey: "uid")
                note.repeatInterval = NSCalendarUnit.WeekOfYear
                UIApplication.sharedApplication().scheduleLocalNotification(note)
            }
        }
    }
    
    func deleteNotifications(forAlarm alarm:Alarm) {
        for k in alarm.uid {
            for note in UIApplication.sharedApplication().scheduledLocalNotifications! {
                if note.userInfo?["uid"] != nil {
                    let id = note.userInfo!["uid"] as! String
                    if k == id {
                        UIApplication.sharedApplication().cancelLocalNotification(note)
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! AlarmVC
        if segue.identifier == "newAlarm" {
            dest.creating = true
        } else if segue.identifier == "editAlarm" {
            dest.creating = false
            let alm = AlarmRepo.singleton.list[currentRow]
            dest.alarm = alm
        }
    }

}
