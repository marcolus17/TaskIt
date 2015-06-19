//
//  SettingsViewController.swift
//  TaskIt
//
//  Created by Nicholas Markworth on 6/14/15.
//  Copyright (c) 2015 Nick Markworth. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Note: normally in a settings view one would have one table, with multiple groups and static cells
    @IBOutlet weak var capitalizeTableView: UITableView!
    @IBOutlet weak var completeNewTodoTableView: UITableView!
    @IBOutlet weak var versionLabel: UILabel!
    
    let kVersionNumber = "1.0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        self.navigationItem.backBarButtonItem?.image = UIImage(named: "BackButton")
        
        self.capitalizeTableView.delegate = self
        self.capitalizeTableView.dataSource = self
        self.capitalizeTableView.scrollEnabled = false
        
        self.completeNewTodoTableView.delegate = self
        self.completeNewTodoTableView.dataSource = self
        self.completeNewTodoTableView.scrollEnabled = false
        
        self.title = "Settings"
        self.versionLabel.text = kVersionNumber
        
        // An example of how to add a button in code
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("doneBarButtonItemPressed:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView Delegate and DataSource functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableView == self.capitalizeTableView ? "Capitalize New Task" : "Complete New Task"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.capitalizeTableView {
            if indexPath.row == 0 {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: kShouldCapitalizeTaskKey)
            }
            else {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kShouldCapitalizeTaskKey)
            }
        }
        else {
            if indexPath.row == 0 {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: kShouldCompleteNewTodoKey)
            }
            else {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kShouldCompleteNewTodoKey)
            }
        }
        NSUserDefaults.standardUserDefaults().synchronize()
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.capitalizeTableView {
            var capitalizeCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("capitalizeCell") as! UITableViewCell
            capitalizeCell.textLabel?.textColor = UIColor.lightGrayColor()
            if indexPath.row == 0 {
                capitalizeCell.textLabel?.text = "No do not Capitalize"
                capitalizeCell.accessoryType = setAccessoryTypeForKey(kShouldCapitalizeTaskKey, whenKeyEqualsBool: false)
            }
            else {
                capitalizeCell.textLabel?.text = "Yes Capitalize!"
                capitalizeCell.accessoryType = setAccessoryTypeForKey(kShouldCapitalizeTaskKey, whenKeyEqualsBool: true)
            }
            return capitalizeCell
        }
        else {
            var completeCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("completeNewTodoCell") as! UITableViewCell
            completeCell.textLabel?.textColor = UIColor.lightGrayColor()
            if indexPath.row == 0 {
                completeCell.textLabel?.text = "Do not complete task"
                completeCell.accessoryType = setAccessoryTypeForKey(kShouldCompleteNewTodoKey, whenKeyEqualsBool: false)
            }
            else {
                completeCell.textLabel?.text = "Complete task"
                completeCell.accessoryType = setAccessoryTypeForKey(kShouldCompleteNewTodoKey, whenKeyEqualsBool: true)
            }
            return completeCell
        }
    }
    
    // Helper function for cellForRowAtIndexPath
    func setAccessoryTypeForKey(key: String, whenKeyEqualsBool bool: Bool) -> UITableViewCellAccessoryType {
        if NSUserDefaults.standardUserDefaults().boolForKey(key) == bool {
            return UITableViewCellAccessoryType.Checkmark
        }
        else {
            return UITableViewCellAccessoryType.None
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func doneBarButtonItemPressed(barButtonItem: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
