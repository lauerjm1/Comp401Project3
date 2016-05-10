//
//  RemdinersTableViewController.swift
//  Project3
//
//  Created by Jon Lauer on 4/22/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import UIKit

class RemdinersTableViewController: UITableViewController {
    
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
            deleteReminder(ReminderRepo.singleton.list[indexPath.row])
            ReminderRepo.singleton.list.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReminderRepo.singleton.list.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentRow = indexPath.row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("editReminder", sender: tableView.cellForRowAtIndexPath(indexPath))
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reminderCell", forIndexPath: indexPath) as! ReminderCell
        if indexPath.row < ReminderRepo.singleton.list.count {
            let rem = ReminderRepo.singleton.list[indexPath.row]
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .ShortStyle
            cell.dateLabel.text = formatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: rem.time))
            cell.titleLabel.text = rem.title
            if rem.activated {
                cell.dateLabel.textColor = activeColor
                cell.titleLabel.textColor = activeColor
            } else {
                cell.dateLabel.textColor = inactiveColor
                cell.titleLabel.textColor = inactiveColor
            }
        }
        return cell
    }

    @IBAction func saveReminderToTable(segue:UIStoryboardSegue) {
        let source = segue.sourceViewController as! ReminderVC
        if source.creating {
            setUpReminder(source.reminder)
        } else {
            updateReminder(source.reminder)
        }
        tableView.reloadData()
    }
    
    func setUpReminder(reminder:Reminder) {
        reminder.uid = NSUUID().UUIDString
        if reminder.activated {
            createNotification(forReminder: reminder)
        }
        ReminderRepo.singleton.list.append(reminder)
    }
    
    func updateReminder(reminder:Reminder) {
        if reminder.activated {
            deleteNotification(forReminder: reminder)
            createNotification(forReminder: reminder)
        } else {
            deleteNotification(forReminder: reminder)
        }
        ReminderRepo.singleton.list[currentRow] = reminder
    }
    
    func deleteReminder(reminder:Reminder) {
        if reminder.activated {
            deleteNotification(forReminder: reminder)
        }
    }
    
    func createNotification(forReminder reminder:Reminder) {
        let note = UILocalNotification()
        note.fireDate = NSDate(timeIntervalSinceReferenceDate: reminder.time)
        note.alertAction = "Reminder!"
        note.alertBody = reminder.title
        note.userInfo?.updateValue(reminder.uid, forKey: "uid")
        UIApplication.sharedApplication().scheduleLocalNotification(note)
    }
    
    func deleteNotification(forReminder reminder:Reminder) {
        for note in UIApplication.sharedApplication().scheduledLocalNotifications! {
            if note.userInfo?["uid"] != nil {
                if reminder.uid == note.userInfo!["uid"] as! String {
                    UIApplication.sharedApplication().cancelLocalNotification(note)
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! ReminderVC
        if segue.identifier == "newReminder" {
            dest.creating = true
        } else if segue.identifier == "editReminder" {
            dest.creating = false
            let rem = ReminderRepo.singleton.list[currentRow]
            dest.reminder = rem
        }
    }

}
