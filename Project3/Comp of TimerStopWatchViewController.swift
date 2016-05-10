//
//  TimerStopWatchViewController.swift
//  Project3
//
//  Created by Jon Lauer on 5/9/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import UIKit

class CopyTimerStopWatchViewController: UIViewController {
    
    // MARK: - Timer-related variables
    var timerTimer: NSTimer = NSTimer()
    var timerEndTime: NSTimeInterval = NSTimeInterval()
    var timerPauseTime: NSTimeInterval?
    var timerDidStart: Bool = false
    var timerIsPaused: Bool = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var hoursTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var secondsTextField: UITextField!
    @IBOutlet weak var startAndStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - IBActions
    @IBAction func startAndStopButtonPressed(sender: UIButton) {
        
        if !timerDidStart {
            timerDidStart = true
            let hours = Double(hoursTextField.text!)!
            let minutes = Double(minutesTextField.text!)!
            let seconds = Double(secondsTextField.text!)!
            let totalTimerTime = hours * 3600 + minutes * 60 + seconds
            
            let currentTime = NSDate.timeIntervalSinceReferenceDate()
            timerEndTime = currentTime + totalTimerTime
            print("Current time: \(currentTime.asStringWithoutDecimals)")
            print("Timer end time: \(timerEndTime.asStringWithoutDecimals)")
            print("Diff: \((timerEndTime - currentTime).asStringWithoutDecimals)")
        }
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        
    }
    
    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        
    }
    
    
    // MARK: - ViewDidLoad, etc.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - UITextFieldDelegate functions
extension CopyTimerStopWatchViewController: UITextFieldDelegate {
    
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
