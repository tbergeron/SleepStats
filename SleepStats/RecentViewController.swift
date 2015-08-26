//
//  SecondViewController.swift
//  SleepStats
//
//  Created by Tommy Bergeron on 2015-08-08.
//  Copyright © 2015 Brainpad Solutions. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class RecentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets & Actions
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trackedNightsLabel: UILabel!
    @IBOutlet weak var avgDurationLabel: UILabel!
    
    // MARK: Properties

    let realm = try! Realm()
    let sleepLogs = try! Realm().objects(SleepLog).sorted("alarmDate", ascending: false)
    var notificationToken: NotificationToken?

    // MARK: UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // todo: put colors somewhere
        tableView.backgroundColor = UIColor(hex: 0x14182B)
        tableView.separatorColor = UIColor(hex: 0x475D73)

        notificationToken = realm.addNotificationBlock { [unowned self] note, realm in
            self.refreshView()
        }
        
        self.refreshView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.refreshView()
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    // MARK: UITableView Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sleepLogs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recentCell", forIndexPath: indexPath) as! RecentTableViewCell
        
        // todo: group them by month eventually
        
        let object = sleepLogs[indexPath.row]
        
        cell.dateLabel?.text = object.startTime.humanReadableDate()
        cell.sleepLabel?.text = object.startTime.humanReadableTime()
        cell.wokeUpLabel?.text = object.wokeUpTime.humanReadableTime()
        cell.durationLabel?.text = object.humanReadableDuration

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        let object = sleepLogs[indexPath.row]
        print(object)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let object = sleepLogs[indexPath.row]

            // remove object from db
            self.realm.write {
                self.realm.delete(object)
                // animate deletion
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }
    
    // MARK: Class Methods
    
    func refreshView() {
        tableView.reloadData()
        self.trackedNightsLabel.text = String(self.sleepLogs.count)
        self.avgDurationLabel.text = SleepLogRepository.getAvgHours(self.sleepLogs)
    }
    
}