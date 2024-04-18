//
//  Functions.swift
//  MealMap
//
//  Created by Jabir Chowdhury
//

import Foundation
func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(
    deadline: .now() + seconds,
    execute: run)
}


let dataFetchFailedNotification = Notification.Name(
  rawValue: "DataFetchFailedNotification")

func fatalCoreDataError(_ error: Error) {
print("*** Fatal error: \(error)")
  NotificationCenter.default.post(
    name: dataFetchFailedNotification,
    object: nil)
}
