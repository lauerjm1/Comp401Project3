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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
