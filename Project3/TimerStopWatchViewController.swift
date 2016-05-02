//
//  TimerStopWatchViewController.swift
//  Project3
//
//  Created by Jon Lauer on 4/30/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import UIKit

class TimerStopWatchViewController: UIViewController {
    
    var timerHours: Int = 0
    var timerMinutes: Int = 0
    var timerSeconds: Int = 0
    var stopWatchHours: Int = 0
    var stopWatchMinutes: Int = 0
    var stopWatchSeconds: Int = 0
    
    @IBOutlet weak var hoursTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var secondsTextField: UITextField!
    @IBOutlet weak var startAndStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!

    override func viewDidLoad() {
        hoursTextField.text = "00"
        minutesTextField.text = "00"
        secondsTextField.text = "00"
        super.viewDidLoad()
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

}

extension TimerStopWatchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // FIXME: - Make so right after putting to numbers in, it goes to next textfield
        if textField.text?.characters.count == 2 {
            if textField == hoursTextField {
                hoursTextField.resignFirstResponder()
                minutesTextField.becomeFirstResponder()
            } else if textField == minutesTextField {
                minutesTextField.resignFirstResponder()
                secondsTextField.becomeFirstResponder()
            } else {
                secondsTextField.resignFirstResponder()
                hoursTextField.becomeFirstResponder()
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        var newValue = 0
        if textField.text == "" {
            textField.text = "00"
            newValue = 0
        } else if let number = Int(textField.text!) {
            newValue = number
            if number > 10 {
                textField.text = "0\(number)"
            }
        } else {
            textField.text = "00"
            newValue = 0
        }
        
        if textField == hoursTextField {
            timerHours = newValue
        } else if textField == minutesTextField {
            timerMinutes = newValue
        } else {
            timerSeconds = newValue
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == hoursTextField {
            minutesTextField.becomeFirstResponder()
        } else if textField == minutesTextField {
            secondsTextField.becomeFirstResponder()
        } else {
            hoursTextField.becomeFirstResponder()
        }
        return true
    }
}
