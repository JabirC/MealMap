//
//  SettingsViewController.swift
//  MealMap
//
//  Created by Jabir Chowdhury on 5/17/23.
//
// text field manipulation resource: medium.com/mobile-app-development-publication/making-ios-uitextfield-accept-number-only-4e9f569ae0c6

import UIKit
import CoreData


class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var calorieCount: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    var goal = UserDefaults.standard.integer(forKey: "calorieGoal")
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.isEnabled = false
        calorieCount.delegate = self
        calorieCount.placeholder = String(goal)
        
        let gestureRecognizer = UITapGestureRecognizer(
          target: self,
          action: #selector(hideKeyboard))
          gestureRecognizer.cancelsTouchesInView = false
          view.addGestureRecognizer(gestureRecognizer)
        
        let swipeRight = UISwipeGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard))
        swipeRight.direction = .down
        view.addGestureRecognizer(swipeRight)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if string == "0" {
            if textField.text!.count == 0 {
               return false
            }
            return true
        }
        if(calorieCount.text != String(goal)){
            updateButton.isEnabled = true
        }
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    
    @IBAction func buttonTapped(_ button: UIButton){
        if(calorieCount.text == ""){
            let alert = UIAlertController(
                title: "",
                message: "Please enter a value",
                preferredStyle: .alert)
              let action = UIAlertAction(
                title: "Close",
                style: .default,
                handler: nil)
              alert.addAction(action)
              present(alert, animated: true, completion: nil)
        }
        else {
            UserDefaults.standard.set(
                calorieCount.text,
                forKey: "calorieGoal")
            updateButton.isEnabled = false
            calorieCount.placeholder = calorieCount.text
        }
    }
    
    @objc func hideKeyboard(
      _ gestureRecognizer: UIGestureRecognizer
    ){
        view.endEditing(true)
    }
}

