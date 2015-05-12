//
//  AddTaskViewController.swift
//  TaskIt
//
//  Created by Nicholas Markworth on 5/12/15.
//  Copyright (c) 2015 Nick Markworth. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    // Used to pass the main ViewController during segue
    var mainVC: ViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tappedView")
        self.view.addGestureRecognizer(tapGesture)
        self.taskTextField.delegate = self
        self.subtaskTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addTaskButtonPressed(sender: UIButton) {
        if taskTextField.text != "" {
            var task = TaskModel(task: taskTextField.text, subtask: subtaskTextField.text, date: dueDatePicker.date, completed: false)
            // Add the new task to the TableViewController's array
            mainVC?.baseArray[0].append(task)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            Alert.showAlertWithText(viewController: self, header: "Missing Information", message: "Please fill out the task field.")
        }
    }
    
    // Dismiss keyboard
    func tappedView() {
        for view in self.view.subviews {
            if view.isKindOfClass(UITextField) {
                view.resignFirstResponder()
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
