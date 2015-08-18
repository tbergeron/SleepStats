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

class Cell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    let sleepLogs = try! Realm().objects(SleepLog).sorted("alarmDate", ascending: false)
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(Cell.self, forCellReuseIdentifier: "cell")
        
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sleepLogs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! Cell

        let object = sleepLogs[indexPath.row]
        cell.textLabel?.text = object.humanReadableAlarmTime
        cell.detailTextLabel?.text = String(object.wokeUpTime)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}

