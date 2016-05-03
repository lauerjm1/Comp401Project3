//
//  AlarmsTableViewController.swift
//  Project3
//
//  Created by Jon Lauer on 4/22/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import UIKit

class AlarmsTableViewController: UITableViewController {
    
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmRepo.singleton.list.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentRow = indexPath.row
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath) as! AlarmCell
        if indexPath.row < AlarmRepo.singleton.list.count {
            let alm = AlarmRepo.singleton.list[indexPath.row]
            if alm.daysOfWeek[0] == true {
                cell.sunLabel.textColor = UIColor.blackColor()
            } else {
                cell.sunLabel.textColor = UIColor.lightGrayColor()
            }
            if alm.daysOfWeek[1] == true {
                cell.monLabel.textColor = UIColor.blackColor()
            } else {
                cell.monLabel.textColor = UIColor.lightGrayColor()
            }
            if alm.daysOfWeek[2] == true {
                cell.tueLabel.textColor = UIColor.blackColor()
            } else {
                cell.tueLabel.textColor = UIColor.lightGrayColor()
            }
            if alm.daysOfWeek[3] == true {
                cell.wedLabel.textColor = UIColor.blackColor()
            } else {
                cell.wedLabel.textColor = UIColor.lightGrayColor()
            }
            if alm.daysOfWeek[4] == true {
                cell.thuLabel.textColor = UIColor.blackColor()
            } else {
                cell.thuLabel.textColor = UIColor.lightGrayColor()
            }
            if alm.daysOfWeek[5] == true {
                cell.friLabel.textColor = UIColor.blackColor()
            } else {
                cell.friLabel.textColor = UIColor.lightGrayColor()
            }
            if alm.daysOfWeek[6] == true {
                cell.satLabel.textColor = UIColor.blackColor()
            } else {
                cell.satLabel.textColor = UIColor.lightGrayColor()
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
