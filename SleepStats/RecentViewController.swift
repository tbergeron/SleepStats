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
    
    // MARK: Properties

    let realm = try! Realm()
    let sleepLogs = try! Realm().objects(SleepLog).sorted("alarmDate", ascending: false)
    var notificationToken: NotificationToken?

    // MARK: UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(RecentTableViewCell.self, forCellReuseIdentifier: "cell")
        
        notificationToken = realm.addNotificationBlock { [unowned self] note, realm in
            self.tableView.reloadData()
        }
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UITableView Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sleepLogs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RecentTableViewCell

        let object = sleepLogs[indexPath.row]
        cell.textLabel?.text = "Date: \(object.startTime.humanReadableDate())"
        cell.detailTextLabel?.text = "Sleep: \(object.startTime.humanReadableTime()) Wake: \(String(object.wokeUpTime.humanReadableTime()))"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // todo: handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
}