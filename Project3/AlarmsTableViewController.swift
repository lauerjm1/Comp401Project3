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
            AlarmRepo.singleton.list.append(source.alarm)
        } else {
            AlarmRepo.singleton.list[currentRow] = source.alarm
        }
        tableView.reloadData()
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
