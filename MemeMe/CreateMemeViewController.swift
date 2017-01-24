//
//  ViewController.swift
//  MemeMe
//
//  Created by JUNYEONG.YOO on 1/24/17.
//  Copyright © 2017 Boostcamp. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
	
	// MARK: Properties
	
	let memeTextAttributes:[String:Any] = [
		NSStrokeColorAttributeName: UIColor.black,
		NSForegroundColorAttributeName: UIColor.white,
		NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
		NSStrokeWidthAttributeName: -3.0
	]
	
	var activeTextField: UITextField!

	// MARK: IBOutlets
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var initialLabel: UILabel!

	// MARK: Life cycle of View Controller
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.topTextField.delegate = self
		self.bottomTextField.delegate = self
		
		// Hide keyboard when a user touches screen
		self.scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Check whether the application could use camera
		self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

		// Disable share button initially
		self.shareButton.isEnabled = false
		
		// Set attributes of the text field
		self.topTextField.defaultTextAttributes = memeTextAttributes
		self.topTextField.textAlignment = .center
		self.bottomTextField.defaultTextAttributes = memeTextAttributes
		self.bottomTextField.textAlignment = .center
		
		// Hide text field initially
		self.topTextField.isHidden = true
		self.bottomTextField.isHidden = true
		
		// Subscribe keyboard notification
		self.subscribeToKeyboardNotification()
		
		// TODO: delete this code when CreateMemeViewController is used at the main view controller
		self.cancelButton.isEnabled = false
		
			}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Unsubscribe keyboard notification
		self.unsubscribeToKeyboardNotification()
	}
	
	// MARK: IBActions
	
	@IBAction func pickAnImageFromAlbum(_ sender: Any) {
		let controller = UIImagePickerController()
		controller.delegate = self
		controller.sourceType = .photoLibrary
		self.present(controller, animated: true, completion: nil)
	}
	
	
	@IBAction func pickAnImageFromCamera(_ sender: Any) {
		let controller = UIImagePickerController()
		controller.delegate = self
		controller.sourceType = .camera
		self.present(controller, animated: true, completion: nil)
	}
	
	@IBAction func shareMemedImage(_ sender: Any) {
		// TODO: do when a user touch share button
	}
	
	@IBAction func cancelAction(_ sender: Any) {
		// TODO: do when a user touch cancel button
	}
	
	// MARK: Delegate methods of UIImagePickerControllerDelegate

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			self.imageView.image = selectedImage
		}
		
		self.dismiss(animated: true) {
			self.shareButton.isEnabled = true
			self.initialLabel.isHidden = true
			self.topTextField.isHidden = false
			self.bottomTextField.isHidden = false
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true) {
			if self.imageView.image != nil {
				self.shareButton.isEnabled = true
			}
		}
	}
	
	// MARK: Delegate methods of UITextFieldDelegate
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		// TODO: clear when textField.text == "TOP" or "BOTTOM"
		if textField.text! == "TOP" || textField.text! == "BOTTOM" {
			textField.text = ""
		}
		
		self.activeTextField = textField
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		self.activeTextField = nil
		return true
	}
	
	// MARK: Subscription to Keyboard showing up or hiding
	
	func subscribeToKeyboardNotification() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
	}
	
	func unsubscribeToKeyboardNotification() {
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
	}
	
	func keyboardWillShow(_ notification: Notification) {
		let userInfo = notification.userInfo!
		if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
			let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
			self.scrollView.contentInset = contentInsets
			self.scrollView.scrollIndicatorInsets = contentInsets
			
			var aRect = self.view.frame
			aRect.size.height -= keyboardSize.height
			
			if let activeTextField = self.activeTextField {
				if !(aRect.contains(activeTextField.frame.origin)) {
					self.scrollView.scrollRectToVisible(activeTextField.frame, animated: true)
				}
			}
		}
	}
	
	func keyboardWillHide(_ notification: Notification) {
		let contentInsets = UIEdgeInsets.zero
		self.scrollView.contentInset = contentInsets
		self.scrollView.scrollIndicatorInsets = contentInsets
	}
	
	func hideKeyboard() {
		self.view.endEditing(true)
		if self.activeTextField != nil {
			self.activeTextField = nil
		}
	}
}

