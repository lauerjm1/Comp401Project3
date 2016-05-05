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
            formatter.timeStyle = .MediumStyle
            cell.dateLabel.text = formatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: rem.time))
            cell.titleLabel.text = rem.title
            if rem.activated {
                cell.dateLabel.textColor = activeColor
                cell.dateLabel.textColor = activeColor
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
            ReminderRepo.singleton.list.append(source.reminder)
        } else {
            ReminderRepo.singleton.list[currentRow] = source.reminder
        }
        tableView.reloadData()
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
