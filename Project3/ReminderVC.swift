//
//  ReminderVC.swift
//  Project3
//
//  Created by Michael Boom on 5/2/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import UIKit

class ReminderVC: UIViewController {

    @IBOutlet weak var titleField:UITextField!
    @IBOutlet weak var activeSwitch:UISwitch!
    @IBOutlet weak var timePicker:UIDatePicker!
    
    @IBAction func screenTap(sender:UIControl) {
        titleField.resignFirstResponder()
    }
    @IBAction func titleTap(sender:UITextField) {
        titleField.becomeFirstResponder()
    }
    
    var creating:Bool = true
    var reminder = Reminder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.minimumDate = NSDate()
        if self.creating {
            reminder = Reminder()
        } else {
            timePicker.date = NSDate(timeIntervalSinceReferenceDate: reminder.time)
            activeSwitch.on = reminder.activated
            titleField.text = reminder.title
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let dest = segue.destinationViewController
        let rem = Reminder()
        rem.time = timePicker.date.timeIntervalFromReferenceDateToThisDate()
        rem.activated = activeSwitch.on
        rem.title = titleField.text
        reminder = rem
    }
 

}
