//
//  TimerStopWatchViewController.swift
//  Project3
//
//  Created by Jon Lauer on 5/9/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import UIKit

class TimerStopWatchViewController: UIViewController {
    
    // MARK: - Timer-related variables
    var timerTimer: NSTimer = NSTimer()
    var timerEndTime: NSTimeInterval = NSTimeInterval()
    var timerPauseTime: NSTimeInterval?
    var timeLeftOnTimer: Double = 0.0
    var timerDidStart: Bool = false
    var timerIsPaused: Bool = true
    var timerExpiredNotification: UILocalNotification = UILocalNotification()
    
    // MARK: - Stopwatch-related variables
    var stopWatchTimer: NSTimer = NSTimer()
    var stopWatchStartTime: NSTimeInterval = NSTimeInterval()
    var stopWatchPauseTime: NSTimeInterval?
    var timeElapsedOnStopWatch: Double = 0.0
    var stopWatchDidStart: Bool = false
    var stopWatchIsPaused: Bool = true
    
    // MARK: - IBOutlets
    @IBOutlet weak var hoursTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var secondsTextField: UITextField!
    @IBOutlet weak var startAndStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - IBActions
    @IBAction func startAndStopButtonPressed(sender: UIButton) {
    
        
        let hours = Double(hoursTextField.text!)!
        let minutes = Double(minutesTextField.text!)!
        let seconds = Double(secondsTextField.text!)!
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let totalTimerTime = hours * 3600 + minutes * 60 + seconds
            print(totalTimerTime)
            
            if totalTimerTime > 0.0 {
                timerIsPaused = !timerIsPaused
                
                if timerIsPaused {
                    startAndStopButton.setTitle("Start", forState: .Normal)
                    timerPauseTime = NSDate.timeIntervalSinceReferenceDate()
                    UIApplication.sharedApplication().cancelLocalNotification(timerExpiredNotification)
                } else {
                    startAndStopButton.setTitle("Stop", forState: .Normal)
                }
                
                if !timerDidStart {
                    timerDidStart = true
                    toggleTextFieldsEnabled(false)
                    
                    let currentTime = NSDate.timeIntervalSinceReferenceDate()
                    timerEndTime = currentTime + totalTimerTime
                    timeLeftOnTimer = totalTimerTime
                    timerTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(TimerStopWatchViewController.updateTimer), userInfo: nil, repeats: true)
                    
                    timerExpiredNotification  = UILocalNotification()
                    timerExpiredNotification.fireDate = NSDate(timeIntervalSinceReferenceDate: timerEndTime)
                    timerExpiredNotification.alertAction = "Timer ended"
                    timerExpiredNotification.alertBody = "\(Int(totalTimerTime)) seconds passed"
                    UIApplication.sharedApplication().scheduleLocalNotification(timerExpiredNotification)
                }
            }
        } else {
            stopWatchIsPaused = !stopWatchIsPaused
            
            if stopWatchIsPaused {
                startAndStopButton.setTitle("Start", forState: .Normal)
                stopWatchPauseTime = NSDate.timeIntervalSinceReferenceDate()
            } else {
                startAndStopButton.setTitle("Stop", forState: .Normal)
            }
            
            if !stopWatchDidStart {
                stopWatchDidStart = true
                stopWatchStartTime = NSDate.timeIntervalSinceReferenceDate()
                stopWatchTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(TimerStopWatchViewController.updateStopWatch), userInfo: nil, repeats: true)
            }
        }
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        if segmentedControl.selectedSegmentIndex == 0 {
            resetTimer()
            UIApplication.sharedApplication().cancelLocalNotification(timerExpiredNotification)
        } else {
            resetStopWatch()
        }
        updateTextFields()
    }
    
    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            if timerDidStart {
                toggleTextFieldsEnabled(false)
            } else {
                toggleTextFieldsEnabled(true)
            }
            if timerIsPaused {
                startAndStopButton.setTitle("Start", forState: .Normal)
            } else {
                startAndStopButton.setTitle("Stop", forState: .Normal)
            }
        } else {
            toggleTextFieldsEnabled(false)
            if stopWatchIsPaused {
                startAndStopButton.setTitle("Start", forState: .Normal)
            } else {
                startAndStopButton.setTitle("Stop", forState: .Normal)
            }
        }
        updateTextFields()
    }
    
    // MARK - Helpers functions
    func updateTextFields() {
        
        var hours: Int = 0
        var minutes: Int = 0
        var seconds: Int = 0
        
        if segmentedControl.selectedSegmentIndex == 0 {
            hours = (Int(round(timeLeftOnTimer))) / 3600
            minutes = ((Int(round(timeLeftOnTimer))) / 60) % 60
            seconds = (Int(round(timeLeftOnTimer))) % 60
        } else if segmentedControl.selectedSegmentIndex ==  1 {
            hours = (Int(round(timeElapsedOnStopWatch))) / 3600
            minutes = ((Int(round(timeElapsedOnStopWatch))) / 60) % 60
            seconds = (Int(round(timeElapsedOnStopWatch))) % 60
        }
        
        if hours < 10 {
            hoursTextField.text = "0\(hours)"
        } else {
            hoursTextField.text = "\(hours)"
        }
        if minutes < 10 {
            minutesTextField.text = "0\(minutes)"
        } else {
            minutesTextField.text = "\(minutes)"
        }
        if seconds < 10 {
            secondsTextField.text = "0\(seconds)"
        } else {
            secondsTextField.text = "\(seconds)"
        }
    }
    
    func updateTimer() {
        if !timerIsPaused {
            let currentTime = NSDate.timeIntervalSinceReferenceDate()
            
            if let timerPauseTime = timerPauseTime {
                let totalTimePaused = currentTime - timerPauseTime
                timerEndTime += totalTimePaused
                self.timerPauseTime = nil
                
                timerExpiredNotification.fireDate = NSDate(timeIntervalSinceReferenceDate: timerEndTime)
                UIApplication.sharedApplication().scheduleLocalNotification(timerExpiredNotification)
            }
            
            timeLeftOnTimer = timerEndTime - currentTime
            if timeLeftOnTimer < 0.5 {
                resetTimer()
            }
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            updateTextFields()
        }
    }
    
    func resetTimer() {
        if segmentedControl.selectedSegmentIndex == 0 {
            startAndStopButton.setTitle("Start", forState: .Normal)
            toggleTextFieldsEnabled(true)
        }
        timerDidStart = false
        timerIsPaused = true
        timerPauseTime = nil
        timeLeftOnTimer = 0.0
        timerTimer.invalidate()
    }
    
    func updateStopWatch() {
        if !stopWatchIsPaused {
            let currentTime = NSDate.timeIntervalSinceReferenceDate()
            
            if let stopWatchPauseTime = stopWatchPauseTime {
                let totalTimePaused = currentTime - stopWatchPauseTime
                stopWatchStartTime += totalTimePaused
                self.stopWatchPauseTime = nil
            }
            
            timeElapsedOnStopWatch = currentTime - stopWatchStartTime
        }
        
        if segmentedControl.selectedSegmentIndex == 1 {
            updateTextFields()
        }
    }
    
    func resetStopWatch() {
        if segmentedControl.selectedSegmentIndex == 1 {
            startAndStopButton.setTitle("Start", forState: .Normal)
        }
        stopWatchDidStart = false
        stopWatchIsPaused = true
        timeElapsedOnStopWatch = 0.0
        stopWatchPauseTime = nil
        stopWatchTimer.invalidate()
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    // MARK: - ViewDidLoad, etc.
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - UITextFieldDelegate functions
extension TimerStopWatchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == hoursTextField {
            minutesTextField.becomeFirstResponder()
        } else if textField == minutesTextField {
            secondsTextField.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let number = Int(textField.text!) {
            if number > 60 && textField != hoursTextField {
                textField.text = "59"
            } else if number < 0 {
                textField.text = "00"
            } else if number < 10 {
                textField.text = "0\(number)"
            }
        } else {
            textField.text = "00"
        }
        textField.textAlignment = .Center
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
        textField.textAlignment = .Left
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count == 2 {
            textFieldShouldReturn(textField)
        }
        return true
    }
    
}
