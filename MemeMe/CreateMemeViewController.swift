//
//  CreateMemeViewController.swift
//  MemeMe
//
//  Created by JUNYEONG.YOO on 1/24/17.
//  Copyright © 2017 Boostcamp. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
	
	// MARK: - Properties
	
	let memeTextAttributes: [String : Any] = [
		NSStrokeColorAttributeName : UIColor.black,
		NSForegroundColorAttributeName : UIColor.white,
		NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
		NSStrokeWidthAttributeName : -3.0
	]
	
	var activeTextField: UITextField!
	
	// Set properties if edit mode
	var isEditMode: Bool = false
	var editMemeOf: Int!
	
	// Save image name
	var originalImageName: String = ""
	var memedImageName: String = ""
	

	// MARK: - IBOutlets
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var initialLabel: UILabel!
	@IBOutlet weak var navigationBar: UINavigationBar!
	@IBOutlet weak var toolBar: UIToolbar!
	@IBOutlet weak var captureView: UIView!

	// MARK: - Life cycle of View Controller
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.topTextField.delegate = self
		self.bottomTextField.delegate = self
		
		// Hide keyboard when a user touches screen
		self.scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
		
		// Set if edit mode
		if self.isEditMode {
			let meme = MemeController.select(at: self.editMemeOf)
			
			let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
			let photoURL = URL(fileURLWithPath: documentDirectory)
			let originalImageURL = photoURL.appendingPathComponent(meme.originalImageName)
			
			self.imageView.image = UIImage(contentsOfFile: originalImageURL.path)
			self.topTextField.text = meme.topText
			self.bottomTextField.text = meme.bottomText
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Check whether the application could use camera
		self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

		// Disable save button initially if not edit mode
		if self.isEditMode {
			self.saveButton.isEnabled = true
			self.topTextField.isHidden = false
			self.bottomTextField.isHidden = false
			self.initialLabel.isHidden = true
		
		} else {
			self.saveButton.isEnabled = false
			self.topTextField.isHidden = true
			self.bottomTextField.isHidden = true
		}
		
		// Set attributes of the text field
		self.topTextField.defaultTextAttributes = memeTextAttributes
		self.topTextField.textAlignment = .center
		self.bottomTextField.defaultTextAttributes = memeTextAttributes
		self.bottomTextField.textAlignment = .center
		
		// Subscribe keyboard notification
		self.subscribeToKeyboardNotification()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Unsubscribe keyboard notification
		self.unsubscribeToKeyboardNotification()
	}
	
	// MARK: - Pick an image
	
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
	
	// MARK: - Delegate methods of UIImagePickerControllerDelegate

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			self.imageView.image = selectedImage
			
			// Save original image to document directory
			let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
			let photoURL = URL(fileURLWithPath: documentDirectory)
			let originalImageName = self.generateOriginalImageName()
			let originalImageURL = photoURL.appendingPathComponent(originalImageName)
			
			do {
				try UIImagePNGRepresentation(selectedImage)?.write(to: originalImageURL, options: .atomic)
				self.originalImageName = originalImageName
			
			} catch {
				print("Original image is not saved in document directory :(")
			}
		}
		
		self.dismiss(animated: false) {
			self.saveButton.isEnabled = true
			self.initialLabel.isHidden = true
			self.topTextField.isHidden = false
			self.bottomTextField.isHidden = false
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: false) {
			if self.imageView.image != nil {
				self.saveButton.isEnabled = true
			}
		}
	}
	
	// MARK: - Delegate methods of UITextFieldDelegate
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
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
	
	// MARK: - Subscription to Keyboard showing up or hiding
	
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
	
	// MARK: - Generate and save memed image
	
	func generateMemedImage() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(self.captureView.frame.size, true, 2.0)
		self.captureView.drawHierarchy(in: CGRect(x: 0, y: 0, width: self.captureView.frame.size.width, height: self.captureView.frame.size.height), afterScreenUpdates: false)
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		return memedImage
	}
	
	@IBAction func saveMemedImage(_ sender: Any) {
		let controller = UIAlertController(title: "Save memed image", message: "Do you want save this memed image?", preferredStyle: .actionSheet)
		
		let confirmAction = UIAlertAction(title: "Confirm", style: .default) { action in
			
			// Save memed image to document directory
			let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
			let memedImageName = self.generateMemedImageName()
			let photoURL = URL(fileURLWithPath: documentDirectory)
			let memedImageURL = photoURL.appendingPathComponent(memedImageName)
			
			do {
				try UIImagePNGRepresentation(self.generateMemedImage())?.write(to: memedImageURL, options: .atomic)
				self.memedImageName = memedImageName
				
				// Save meme information to the array and Realm
				let meme = Meme()
				meme.memeID = Int(Date().timeIntervalSinceReferenceDate)
				meme.topText = self.topTextField.text!
				meme.bottomText = self.bottomTextField.text!
				meme.originalImageName = self.originalImageName
				meme.memedImageName = self.memedImageName
				
				if self.isEditMode {
					MemeController.update(at: self.editMemeOf, meme)
					
				} else {
					MemeController.insert(meme)
				}

			
			} catch {
				print("Memed image is not saved in document directory :(")
			}
			
			// After saving meme instant, close the alert controller
			self.dismiss(animated: true, completion: nil)
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		controller.addAction(confirmAction)
		controller.addAction(cancelAction)
		self.present(controller, animated: true, completion: nil)
	}
	
	func generateMemedImageName() -> String {
		let date = NSDate()
		let calendar = NSCalendar.current
		let year = calendar.component(.year, from: date as Date)
		let month = calendar.component(.month, from: date as Date)
		let day = calendar.component(.day, from: date as Date)
		let hour = calendar.component(.hour, from: date as Date)
		let minute = calendar.component(.minute, from: date as Date)
		let second = calendar.component(.second, from: date as Date)
		
		return "memed_\(year)-\(month)-\(day)-\(hour)-\(minute)-\(second).png"
	}
	
	func generateOriginalImageName() -> String {
		let date = NSDate()
		let calendar = NSCalendar.current
		let year = calendar.component(.year, from: date as Date)
		let month = calendar.component(.month, from: date as Date)
		let day = calendar.component(.day, from: date as Date)
		let hour = calendar.component(.hour, from: date as Date)
		let minute = calendar.component(.minute, from: date as Date)
		let second = calendar.component(.second, from: date as Date)
		
		return "original_\(year)-\(month)-\(day)-\(hour)-\(minute)-\(second).png"
	}
	
	// MARK: - Cancel creating meme

	@IBAction func cancelCreatingMemedImage(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
}

