//
//  PhotoViewController.swift
//  Snacktacular
//
//  Created by Alex Golden on 11/15/20.
//

import UIKit

class PhotoViewController: UIViewController {
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    
    var spot: Spot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide keyboard when tap outside
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        guard spot != nil else {
            print("Error no spot passed to photoVC")
            return
        }

        
    }
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
       
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }

}
