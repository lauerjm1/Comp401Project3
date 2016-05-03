//
//  AlarmVC.swift
//  Project3
//
//  Created by Michael Boom on 4/30/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import UIKit

class AlarmVC: UIViewController {

    @IBOutlet weak var timePicker:UIDatePicker!
    @IBOutlet weak var activeSwitch:UISwitch!
    @IBOutlet weak var titleField:UITextField!
    @IBOutlet weak var sunBut:UIButton!
    @IBOutlet weak var monBut:UIButton!
    @IBOutlet weak var tueBut:UIButton!
    @IBOutlet weak var wedBut:UIButton!
    @IBOutlet weak var thuBut:UIButton!
    @IBOutlet weak var friBut:UIButton!
    @IBOutlet weak var satBut:UIButton!
    
    @IBAction func sunTap(sender:UIButton!) {
        days[0] = !(days[0])
        if days[0] {
            sunBut.setTitleColor(UIColor.blueColor(), forState: .Normal)
        } else {
            sunBut.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
    }
    @IBAction func monTap(sender:UIButton!) {
        days[1] = !(days[1])
        if days[1] {
            monBut.setTitleColor(UIColor.blueColor(), forState: .Normal)
        } else {
            monBut.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
    }
    @IBAction func tueTap(sender:UIButton!) {
        days[2] = !(days[2])
        if days[2] {
            tueBut.setTitleColor(UIColor.blueColor(), forState: .Normal)
        } else {
            tueBut.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
    }
    @IBAction func wedTap(sender:UIButton!) {
        days[3] = !(days[3])
        if days[3] {
            wedBut.setTitleColor(UIColor.blueColor(), forState: .Normal)
        } else {
            wedBut.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
    }
    @IBAction func thuTap(sender:UIButton!) {
        days[4] = !(days[4])
        if days[4] {
            thuBut.setTitleColor(UIColor.blueColor(), forState: .Normal)
        } else {
            thuBut.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
    }
    @IBAction func friTap(sender:UIButton!) {
        days[5] = !(days[5])
        if days[5] {
            friBut.setTitleColor(UIColor.blueColor(), forState: .Normal)
        } else {
            friBut.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
    }
    @IBAction func satTap(sender:UIButton!) {
        days[6] = !(days[6])
        if days[6] {
            satBut.setTitleColor(UIColor.blueColor(), forState: .Normal)
        } else {
            satBut.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
    }
    
    @IBAction func screenTap(sender:UIControl) {
        titleField.resignFirstResponder()
    }
    @IBAction func titleTap(sender:UITextField) {
        titleField.becomeFirstResponder()
    }
    
    var creating:Bool = true
    var alarm = Alarm()
    var days = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.creating {
            days = [false,false,false,false,false,false,false]
        } else {
            let comps = NSDateComponents()
            comps.hour = alarm.hour
            comps.minute = alarm.minute
            timePicker.date = NSCalendar.currentCalendar().dateFromComponents(comps)!
            days = alarm.daysOfWeek
            activeSwitch.on = alarm.activated
            titleField.text = alarm.title
        }
        if !days[0] {
            sunBut.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
        if !days[1] {
            monBut.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
        if !days[2] {
            tueBut.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
        if !days[3] {
            wedBut.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
        if !days[4] {
            thuBut.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
        if !days[5] {
            friBut.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
        if !days[6] {
            satBut.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let dest = segue.destinationViewController
        let alm = Alarm()
        let unitFlags: NSCalendarUnit = [.Hour, .Minute]
        let components = NSCalendar.currentCalendar().components(unitFlags, fromDate: timePicker.date)
        alm.hour = components.hour
        alm.minute = components.minute
        //NSLog("\(components.hour)")
        alm.daysOfWeek[0] = days[0]
        alm.daysOfWeek[1] = days[1]
        alm.daysOfWeek[2] = days[2]
        alm.daysOfWeek[3] = days[3]
        alm.daysOfWeek[4] = days[4]
        alm.daysOfWeek[5] = days[5]
        alm.daysOfWeek[6] = days[6]
        alm.activated = activeSwitch.on
        alm.title = titleField.text
        alarm = alm
    }

}
