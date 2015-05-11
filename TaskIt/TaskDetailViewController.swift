//
//  TaskDetailViewController.swift
//  TaskIt
//
//  Created by Nicholas Markworth on 5/11/15.
//  Copyright (c) 2015 Nick Markworth. All rights reserved.
//

import Foundation
import UIKit

class TaskDetailViewController:UIViewController {
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subtaskTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    var detailTaskModel: TaskModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        println(self.detailTaskModel.task)
        self.taskTextField.text = detailTaskModel.task
        self.subtaskTextField.text = detailTaskModel.subtask
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}