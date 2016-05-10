//
//  NoteVC.swift
//  Project3
//
//  Created by Michael Boom on 5/9/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import UIKit

class NoteVC: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var actionLabel:UILabel!
    @IBOutlet weak var bodyLabel:UILabel!
    
    var action = " "
    var body = " "
    
    @IBAction func handleTap(recog:UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        actionLabel.text = action
        bodyLabel.text = body
        if MotionHandler.singleton.motionManager.accelerometerAvailable {
            MotionHandler.singleton.motionManager.accelerometerUpdateInterval = 0.1
            let queue = NSOperationQueue()
            MotionHandler.singleton.motionManager.startAccelerometerUpdatesToQueue(queue) { data, error in
                if data?.acceleration.z > MotionHandler.singleton.zAccelThreshhold {
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        MotionHandler.singleton.motionManager.stopAccelerometerUpdates()
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
