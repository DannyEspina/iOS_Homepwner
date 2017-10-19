//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Danny Espina on 10/16/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var nameField: CustomTextField!
    @IBOutlet var serialNumberField: CustomTextField!
    @IBOutlet var valueField: CustomTextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var deleteButton: UIBarButtonItem!
    var imageStore: ImageStore!
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
       
        let imagePicker = UIImagePickerController()
        // If the device has a camera, take a picture; otherwise, just pic from photo library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            
            let overlayView = UIView(frame: imagePicker.cameraOverlayView!.frame)
            
            let crosshairLabel = UILabel()
            crosshairLabel.text = "+"
            crosshairLabel.font = UIFont.systemFont(ofSize: 50)
            crosshairLabel.textColor = UIColor.yellow
            crosshairLabel.translatesAutoresizingMaskIntoConstraints = false
            overlayView.addSubview(crosshairLabel)
            
            crosshairLabel.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
            crosshairLabel.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor).isActive = true
            
            // To avoid blocking the underneath default camera controls
            overlayView.isUserInteractionEnabled = false
            
            imagePicker.cameraOverlayView = overlayView
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        // Place image picker on the screen
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func removePicture(_ sender: UIBarButtonItem) {
        let title = "Delete image?"
        let message = "Are you sure you want to delete this image?"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancel)
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            self.imageView.image = nil
            self.imageStore.deleteImage(forKey: self.item.itemKey)
            sender.isEnabled = false
        })
        ac.addAction(delete)
        present(ac, animated: true, completion: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if imageStore.image(forKey: item.itemKey) == nil {
        deleteButton.isEnabled = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        // Get the item key
        let key = item.itemKey
        
        // If there is an associated image with the item
        // display it on the image view
        let imageToDisplay = imageStore.image(forKey: key)
        imageView.image = imageToDisplay
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clear first responder
        view.endEditing(true)
        
        // "Save" changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text, let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String: Any]) {
        // Get picked image from info dictionary
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Store the image in the ImageStore for the item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        // Put that image on the screen in the image view
        imageView.image = image
        deleteButton.isEnabled = true
        // Take image picker off the screen - you must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "changeDate"?:
            let dateCreatedViewController = segue.destination as! DateCreatedViewController
            dateCreatedViewController.item = item
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
