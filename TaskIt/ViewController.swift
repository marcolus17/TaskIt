//
//  ViewController.swift
//  TaskIt
//
//  Created by Nicholas Markworth on 5/11/15.
//  Copyright (c) 2015 Nick Markworth. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, TaskDetailViewControllerDelegate, AddTaskViewControllerDelegate {
    
    // Outlet for the UITableView
    @IBOutlet weak var tableView: UITableView!
    
    // The "scratchboard" for adding a new task entity
    // let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    // Used to update the TableView with our CoreData entities
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Remember to connect the tableView to the ViewController in the storyboard (DataSource and Delegate)
        // This can also be done in code - self.tableView.delegate = self and self.tableView.dataSource = self
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        // Do any additional setup after loading the view, typically from a nib.
        fetchedResultsController = getFetchedResultsController()
        fetchedResultsController.delegate = self
        // Grab the initial stored entities
        fetchedResultsController.performFetch(nil)
        
        // "Listen to the radio station" and listen for iCloud to be updated
        // coreDataUpdated = kCoreDataUpdated in ModelManager class
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("iCloudUpdated"), name: "coreDataUpdated", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource Functions
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    // Change the title of the header sections
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if fetchedResultsController.sections?.count == 1 {
            let task = fetchedResultsController.fetchedObjects![0] as! TaskModel
            return task.completed.boolValue ? "Completed" : "To Do"
        }
        return section == 0 ? "To Do" : "Completed"
    }
    
    // Returns the number of rows in each sections
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    // Returns the cell that was selected
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let thisTask: TaskModel = fetchedResultsController.objectAtIndexPath(indexPath) as! TaskModel
        // We have to tell the Xcode compiler to use a TaskCell instance
        var cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as! TaskCell
        cell.taskLabel.text = thisTask.task
        cell.descriptionLabel.text = thisTask.subtask
        cell.dateLabel.text = Date.toString(date: thisTask.date)
        return cell
    }
    
    /* 
        Complete and uncomplete tasks
        Note: if we wanted to delete a task completely use the below functions...
        CoreDataManager.sharedInstance.managedObjectContext?.deleteObject(task)
        CoreDataManager.sharedInstance.saveContext()
    */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let thisTask: TaskModel = fetchedResultsController.objectAtIndexPath(indexPath) as! TaskModel
        
        // Move the task to the Completed section or back to the To Do section
        if thisTask.completed == 0 {
            thisTask.completed = 1
        }
        else {
            thisTask.completed = 0
        }
        
        // (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        
        // Save the changes to iCloud
        ModelManager.instance.saveContext()
    }
    
    // MARK: - UITableViewDelegate functions
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    // Have to override this function in order to pass data to the new ViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            let detailVC: TaskDetailViewController = segue.destinationViewController as! TaskDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisTask: TaskModel = fetchedResultsController.objectAtIndexPath(indexPath!) as! TaskModel
            // Implement our optional protocol
            detailVC.delegate = self
            detailVC.detailTaskModel = thisTask
        }
        else if segue.identifier == "showAddTask" {
            let addTaskVC: AddTaskViewController = segue.destinationViewController as! AddTaskViewController
            // Implement our required protocol
            addTaskVC.delegate = self
        }
    }

    // Add new task
    @IBAction func addBarButtonItemPressed(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showAddTask", sender: self)
    }
    
    // Fetch the TaskModel entities
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        // Sort the data by the date field
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        // Used to add the second section to our table
        let completedDescriptor = NSSortDescriptor(key: "completed", ascending: true)
        
        // Add the completedDescriptor and sortDescriptor to the fetchRequest array
        fetchRequest.sortDescriptors = [completedDescriptor, sortDescriptor]
        return fetchRequest
    }
    
    // Get the fetchedResultsController
    func getFetchedResultsController() -> NSFetchedResultsController {
        // fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: "completed", cacheName: nil)
        
        // Use the iCloud managedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: ModelManager.instance.managedObjectContext!, sectionNameKeyPath: "completed", cacheName: nil)
        return fetchedResultsController
    }
    
    // MARK: - NSFetchResultsControllerDelegate Functions
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    // MARK: - Optional TaskDetailViewControllerDelegate function
    func taskDetailEdited() {
        // Let the user know the detail of the task was edited
        Alert.showAlertWithText(viewController: self, header: "Changes Made", message: "The detail for the selected task was changed.")
    }
    
    // MARK: - Required AddTaskViewControllerDelegate functions
    func addTaskCanceled(message: String) {
        Alert.showAlertWithText(viewController: self, header: "Add Task", message: message)
    }
    
    func addTask(message: String) {
        Alert.showAlertWithText(viewController: self, header: "Add Task", message: message)
    }
    
    // MARK: - iCloud Notification handler
    func iCloudUpdated() {
        tableView.reloadData()
    }
}

