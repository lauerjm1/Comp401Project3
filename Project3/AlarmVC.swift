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
