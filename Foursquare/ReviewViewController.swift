//
//  ReviewViewController.swift
//  Foursquare
//
//  Created by Vishal on 22/03/17.
//  Copyright © 2017 Daffolapmac-25. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var textField: UITextView!
    
    var id:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Write Review"
        self.hideKeyboardWhenTappedAround()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor

       
    }
    
    @IBAction func saveData(_ sender: Any) {
        if id != nil {
            if validateData() {
                saveReview()
            }
        }
    }
    
    func saveReview(){
        let name = firstName.text! + " " + lastName.text!
        DatabaseServiceManager.createReview(name, id: id!, review: textField.text) { (response) in
            self.showAlertWithMessage("Successfully added the review", andTitle: "Success")
        }
    }
    
    
    func validateData() -> Bool {
        if firstName.text == "" || firstName.text == nil {
            self.showAlertWithMessage("Please write first name", andTitle: "Error")
            return false
        }else if lastName.text == "" || lastName.text == nil {
            self.showAlertWithMessage("Pelase write last name", andTitle: "Error")
            return false
        }else if textField.text == "" || textField.text == nil {
            self.showAlertWithMessage("Pelase write Review", andTitle: "Error")
            return false
        }else {
            return true
        }
    }

}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlertWithMessage(_ message:String, andTitle title:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
