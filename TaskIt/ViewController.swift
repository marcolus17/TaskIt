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
    
    var baseArray:[[TaskModel]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Remember to connect the tableView to the ViewController in the storyboard (DataSource and Delegate)
        // This can also be done in code - self.tableView.delegate = self and self.tableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create Date instances using our class function
        let date1 = Date.from(year: 2015, month: 05, day: 20)
        let date2 = Date.from(year: 2015, month: 05, day: 22)
        let date3 = Date.from(year: 2015, month: 05, day: 24)
        
        let task1 = TaskModel(task: "Study French", subtask: "Verbs", date: date1, completed: false)
        let task2 = TaskModel(task: "Eat Dinner", subtask: "Burgers", date: date2, completed: false)
        let task3 = TaskModel(task: "Go to the Gym", subtask: "Leg day", date: date3, completed: false)
        
        let completedTask = TaskModel(task: "Code", subtask: "Task Project", date: date2, completed: true)
        
        let completedArray = [completedTask]
        let taskArray = [task1, task2, task3]
        
        self.baseArray = [taskArray, completedArray]
        
        self.tableView.reloadData()
    }
    
    // Make sure tableView data gets reloaded when we come back to the main screen
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Returns an identical array sorted by the parameter method
        self.baseArray[0] = self.baseArray[0].sorted(sortByDate)
        /*
         * Sorting can also be done using a closure:
         * baseArray[0] = baseArray[0].sorted {
         *      (taskOne: TaskModel, taskTwo: TaskModel) -> Bool in
         *      // comparison logic here
         *      return taskOne.date.timeIntervalSince1970 < taskTwo.date.timeIntervalSince1970
         * }
         */
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // UITableViewDataSource functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return baseArray.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "To do"
        }
        else {
            return "Completed"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baseArray[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let thisTask:TaskModel = baseArray[indexPath.section][indexPath.row]
        // We have to tell the Xcode compiler to use a TaskCell instance
        var cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as! TaskCell
        cell.taskLabel.text = thisTask.task
        cell.descriptionLabel.text = thisTask.subtask
        cell.dateLabel.text = Date.toString(date: thisTask.date)
        return cell
    }
    
    // UITableViewDelegate functions
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    // Complete and uncomplete tasks
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let thisTask = baseArray[indexPath.section][indexPath.row]
        var newTask = thisTask
        
        // Move the task to the Completed section or back to the To Do section
        if !thisTask.completed {
            newTask.completed = true
            baseArray[1].insert(newTask, atIndex: 0)
        }
        else {
            newTask.completed = false
            baseArray[0].append(newTask)
        }
        
        // Remove the original task from the To Do or Completed section
        baseArray[indexPath.section].removeAtIndex(indexPath.row)
        // Sort the To Do section
        self.baseArray[0] = self.baseArray[0].sorted(sortByDate)
        tableView.reloadData()
    }
    
    // Have to override this function in order to pass data to the new ViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            let detailVC: TaskDetailViewController = segue.destinationViewController as! TaskDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisTask = baseArray[indexPath!.section][indexPath!.row]
            detailVC.detailTaskModel = thisTask
            detailVC.mainVC = self
        }
        else if segue.identifier == "showAddTask" {
            let addTaskVC: AddTaskViewController = segue.destinationViewController as! AddTaskViewController
            addTaskVC.mainVC = self
        }
    }
    
    // Sort array by date
    func sortByDate(taskOne: TaskModel, taskTwo: TaskModel) -> Bool {
        return taskOne.date.timeIntervalSince1970 < taskTwo.date.timeIntervalSince1970
    }

    // Add new task
    @IBAction func addBarButtonItemPressed(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showAddTask", sender: self)
    }
}

