//
//  TaskDetailViewController.swift
//  TaskIt
//
//  Created by Nicholas Markworth on 5/11/15.
//  Copyright (c) 2015 Nick Markworth. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc protocol TaskDetailViewControllerDelegate {
    optional func taskDetailEdited()
}

class TaskDetailViewController: UIViewController, UITextFieldDelegate {
    
    // Outlets for UI Fields
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var dueDatePickerContainerView: UIView!
    
    // Holds the information for the task being passed in
    var detailTaskModel: TaskModel!
    
    // Delegate property for the protocol
    var delegate: TaskDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        self.dueDatePickerContainerView.layer.cornerRadius = 5;
        self.dueDatePickerContainerView.layer.masksToBounds = true;
        
        // Creating a tap gesture recognizer in order to dismiss the keyboard when the main view is touched
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedView")
        self.view.addGestureRecognizer(tapGesture)
        // Must assing the parent view as the delegate and add UITextFieldDelegate to class
        self.taskTextField.delegate = self
        self.subtaskTextField.delegate = self
        
        // Fill in UI fields
        self.taskTextField.text = detailTaskModel.task
        self.subtaskTextField.text = detailTaskModel.subtask
        self.dueDatePicker.date = detailTaskModel.date
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Cancel the edit and return to the main screen
    @IBAction func cancelBarButtonItemPressed(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // Edit the information in the task and return to the main screen
    @IBAction func doneBarButtonItemPressed(sender: UIBarButtonItem) {
        if taskTextField.text != "" {
            // let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            
            // Make any necessary changes to the task
            detailTaskModel.task = taskTextField.text
            detailTaskModel.subtask = subtaskTextField.text
            detailTaskModel.date = dueDatePicker.date
            detailTaskModel.completed = detailTaskModel.completed
            
            // appDelegate.saveContext()
            // Save changes to iCloud
            ModelManager.instance.saveContext()
            
            self.navigationController?.popViewControllerAnimated(true)
            // Tell our delegate that we are done editing
            delegate?.taskDetailEdited!()
        }
        else {
            Alert.showAlertWithText(viewController: self, header: "Missing Information", message: "Please fill in the task field.")
        }
    }
    
    // Dismiss keyboard if view is tapped
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