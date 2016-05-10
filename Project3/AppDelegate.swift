//
//  AppDelegate.swift
//  Project3
//
//  Created by Jon Lauer on 4/20/16.
//  Copyright © 2016 Jon Lauer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert, categories: nil))
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        if notification.alertAction == "Timer ended" {
            //let alert = UIAlertController(title: notification.alertAction, message: notification.alertBody, preferredStyle: .Alert)
            //alert.addAction(UIAlertAction(title: "Done", style: .Cancel, handler: nil))
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let test = storyboard.instantiateViewControllerWithIdentifier("notevc") as! NoteVC
            test.action = notification.alertAction!
            test.body = notification.alertBody!
            self.window?.rootViewController?.presentViewController(test, animated: true, completion: nil)
        } else if notification.alertAction == "Alarm!" {
            let alert = UIAlertController(title: notification.alertAction, message: notification.alertBody, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Done", style: .Cancel, handler: nil))
            self.window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
        } else if notification.alertAction == "Reminder!" {
            let alert = UIAlertController(title: notification.alertAction, message: notification.alertBody, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Done", style: .Cancel, handler: nil))
            self.window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
        }
    }


}

