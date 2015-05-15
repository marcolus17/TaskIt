//
//  TaskModel.swift
//  TaskIt
//
//  Created by Nicholas Markworth on 5/12/15.
//  Copyright (c) 2015 Nick Markworth. All rights reserved.
//

import Foundation
import CoreData

// This model is now controlled by CoreData
// Be sure to make sure this file name and the modelURL in AppDelegate match

// Tell Xcode to treat this class as an Objective-C object, since some functionality is lacking yet in Swift
@objc(TaskModel)
class TaskModel: NSManagedObject {

    @NSManaged var completed: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var subtask: String
    @NSManaged var task: String

}
