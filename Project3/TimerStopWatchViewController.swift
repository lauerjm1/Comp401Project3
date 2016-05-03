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
    
    var timerTimer = NSTimer()
    var timerStarted: Bool = false
    var timerRunning: Bool = false
    var stopWatchTimer = NSTimer()
    var stopWatchStarted: Bool = false
    var stopWatchRunning: Bool = false
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var hoursTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var secondsTextField: UITextField!
    @IBOutlet weak var startAndStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            if !timerStarted {
                toggleTextFieldsEnabled(true)
            } else {
                toggleTextFieldsEnabled(false)
            }
            if timerRunning {
                startAndStopButton.setTitle("Stop", forState: .Normal)
            } else {
                startAndStopButton.setTitle("Start", forState: .Normal)
            }
        } else {
            toggleTextFieldsEnabled(false)
            if stopWatchRunning {
                startAndStopButton.setTitle("Stop", forState: .Normal)
            } else {
                startAndStopButton.setTitle("Start", forState: .Normal)
            }
        }
        updateTextInTextFields()
    }
    
    @IBAction func startAndStopButtonPressed(sender: UIButton) {
        if segmentedControl.selectedSegmentIndex == 0 {
            let totalTimeLeft = timerSeconds + (60 * (timerMinutes + (60 * timerHours)))
            if totalTimeLeft > 0 {
                timerRunning = !timerRunning
                
                if timerRunning {
                    startAndStopButton.setTitle("Stop", forState: .Normal)
                } else {
                    startAndStopButton.setTitle("Start", forState: .Normal)
                }
                
                if !timerStarted {
                    timerTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(TimerStopWatchViewController.updateTimer), userInfo: nil, repeats: true)
                    toggleTextFieldsEnabled(false)
                    let note = UILocalNotification()
                    note.fireDate = NSDate(timeIntervalSinceNow: Double(totalTimeLeft))
                    note.alertAction = "Timer ended"
                    note.alertBody = "\(totalTimeLeft) seconds elapsed"
                    UIApplication.sharedApplication().scheduleLocalNotification(note)
                    timerStarted = true
                }
            }
        } else {
            stopWatchRunning = !stopWatchRunning
            
            if stopWatchRunning {
                startAndStopButton.setTitle("Stop", forState: .Normal)
            } else {
                startAndStopButton.setTitle("Start", forState: .Normal)
            }
            
            if !stopWatchStarted {
                stopWatchTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(TimerStopWatchViewController.updateStopWatch), userInfo: nil, repeats: true)
                stopWatchStarted = true
            }
        }
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        if segmentedControl.selectedSegmentIndex == 0 {
            resetTimer()
        } else {
            resetStopWatch()
        }
    }
    
    func resetTimer() {
        timerHours = 0
        timerSeconds = 0
        timerMinutes = 0
        updateTextInTextFields()
        
        timerRunning = false
        timerStarted = false
        if segmentedControl.selectedSegmentIndex == 0 {
            toggleTextFieldsEnabled(true)
            startAndStopButton.setTitle("Start", forState: .Normal)
        }
        timerTimer.invalidate()
    }
    
    func resetStopWatch() {
        stopWatchHours = 0
        stopWatchMinutes = 0
        stopWatchSeconds = 0
        updateTextInTextFields()
        
        stopWatchRunning = false
        stopWatchStarted = false
        if segmentedControl.selectedSegmentIndex == 1 {
            toggleTextFieldsEnabled(false)
            startAndStopButton.setTitle("Start", forState: .Normal)
        }
        stopWatchTimer.invalidate()
    }
    
    func updateTimer() {
        if timerRunning {
            timerSeconds -= 1
            let totalTimeLeft = timerSeconds + (60 * (timerMinutes + (60 * timerHours)))
            if totalTimeLeft <= 0 {
                resetTimer()
                // TODO: - Fire notification here or something
            } else if timerSeconds == -1 {
                timerMinutes -= 1
                timerSeconds = 59
                if timerMinutes == -1 {
                    timerHours -= 1
                    timerMinutes = 59
                }
            }
        }
        if segmentedControl.selectedSegmentIndex == 0 {
            updateTextInTextFields()
        }
    }
    
    func updateStopWatch() {
        if stopWatchRunning {
            stopWatchSeconds += 1
            let totalTimePassed = stopWatchSeconds + (60 * (stopWatchMinutes + (60 * stopWatchHours)))
            if totalTimePassed <= (59 + (60 * (59 + (60 * 99)))) {
                if stopWatchSeconds > 59 {
                    stopWatchSeconds = 0
                    stopWatchMinutes += 1
                    if stopWatchMinutes > 59 {
                        stopWatchMinutes = 0
                        stopWatchHours += 1
                    }
                }
            } else {
                resetStopWatch()
            }
        }
        if segmentedControl.selectedSegmentIndex == 1 {
            updateTextInTextFields()
        }
    }
    
    func updateTextInTextFields() {
        var hoursText = 0
        var minutesText = 0
        var secondsText = 0
        if segmentedControl.selectedSegmentIndex == 0 {
            hoursText = timerHours
            minutesText = timerMinutes
            secondsText = timerSeconds
        } else {
            hoursText = stopWatchHours
            minutesText = stopWatchMinutes
            secondsText = stopWatchSeconds
        }
        if hoursText < 10 {
            hoursTextField.text = "0\(hoursText)"
        } else {
            hoursTextField.text = "\(hoursText)"
        }
        if minutesText < 10 {
            minutesTextField.text = "0\(minutesText)"
        } else {
            minutesTextField.text = "\(minutesText)"
        }
        if secondsText < 10 {
            secondsTextField.text = "0\(secondsText)"
        } else {
            secondsTextField.text = "\(secondsText)"
        }
    }

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
    
    func toggleTextFieldsEnabled (enabled: Bool) {
        hoursTextField.enabled = enabled
        minutesTextField.enabled = enabled
        secondsTextField.enabled = enabled
        if enabled {
            hoursTextField.borderStyle = .RoundedRect
            minutesTextField.borderStyle = .RoundedRect
            secondsTextField.borderStyle = .RoundedRect
        } else {
            hoursTextField.borderStyle = .None
            minutesTextField.borderStyle = .None
            secondsTextField.borderStyle = .None
        }
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
            if textField != hoursTextField && number > 59 {
                newValue = 59
                textField.text = "59"
            } else {
                newValue = number
            }
            if number < 10 {
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
