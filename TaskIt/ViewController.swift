//
//  ViewController.swift
//  TaskIt
//
//  Created by Nicholas Markworth on 5/11/15.
//  Copyright (c) 2015 Nick Markworth. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskArray:[TaskModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Remember to connect the tableView to the ViewController in the storyboard (DataSource and Delegate)
        // This can also be done in code - self.tableView.delegate = self and self.tableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
        let task1 = TaskModel(task: "Study French", subtask: "Verbs", date: "05/11/2015")
        let task2 = TaskModel(task: "Eat Dinner", subtask: "Burgers", date: "05/11/2015")
        let task3 = TaskModel(task: "Go to the Gym", subtask: "Leg day", date: "05/11/2015")
        
        taskArray = [task1, task2, task3]
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // UITableViewDataSource functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let thisTask:TaskModel = taskArray[indexPath.row]
        // We have to tell the Xcode compiler to use a TaskCell instance
        var cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as! TaskCell
        cell.taskLabel.text = thisTask.task
        cell.descriptionLabel.text = thisTask.subtask
        cell.dateLabel.text = thisTask.date
        return cell
    }
    
    // UITableViewDelegate functions
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            let detailVC: TaskDetailViewController = segue.destinationViewController as! TaskDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisTask = taskArray[indexPath!.row]
            detailVC.detailTaskModel = thisTask
        }
    }

}

