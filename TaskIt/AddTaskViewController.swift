//
//  AddTaskViewController.swift
//  TaskIt
//
//  Created by Nicholas Markworth on 5/12/15.
//  Copyright (c) 2015 Nick Markworth. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController, UITextFieldDelegate {
    
    // Outlets for UI fields
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Creating a tap gesture recognizer in order to dismiss the keyboard when the main view is touched
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedView")
        self.view.addGestureRecognizer(tapGesture)
        // Must assing the parent view as the delegate and add UITextFieldDelegate to class
        self.taskTextField.delegate = self
        self.subtaskTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Cancel the edit and return to the main screen
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Add a new task to the list
    @IBAction func addTaskButtonPressed(sender: UIButton) {
        if taskTextField.text != "" {
            /*
             * UIApplication represents our entire application; gaining access to the AppDelegate
             * sharedApplication() returns a singleton
             */
            let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            
            // Get the "scratchboard" for adding a new task entity
            let managedObjectContext = appDelegate.managedObjectContext
            // Describes the TaskModel entity used in the next step
            let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext!)
            
            // Set up our task
            let task = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
            
            // Use our new settings options
            if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitalizeTaskKey) == true {
                task.task = taskTextField.text.capitalizedString
            }
            else {
                task.task = taskTextField.text
            }
            
            task.subtask = subtaskTextField.text
            task.date = dueDatePicker.date
            
            if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodoKey) == true {
                task.completed = true
            }
            else {
                task.completed = false
            }
            
            // Called to save the data to CoreData
            appDelegate.saveContext()
            
            // Getting the information that we just saved
            var request = NSFetchRequest(entityName: "TaskModel")
            var error: NSError? = nil
            // &: Write the error to the memory address if an error occurs
            var results: NSArray = managedObjectContext!.executeFetchRequest(request, error: &error)!
            for res in results {
                println(res)
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            Alert.showAlertWithText(viewController: self, header: "Missing Information", message: "Please fill out the task field.")
        }
    }
    
    // Dismiss keyboard if main view is touched
    func tappedView() {
        for view in self.view.subviews {
            if view.isKindOfClass(UITextField) {
                view.resignFirstResponder()
            }
        }
    }
    
    // Dismiss keyboard if Return button is pressed on the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
