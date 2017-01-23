//
//  ViewController.swift
//  MemeMe
//
//  Created by JUNYEONG.YOO on 1/24/17.
//  Copyright © 2017 Boostcamp. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	// MARK: Properties
	
	
	
	// MARK: IBOutlets
	
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	@IBOutlet weak var topLabel: UILabel!
	@IBOutlet weak var bottomLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!

	// MARK: Life cycle of View Controller
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Check whether the application could use camera
		self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		self.shareButton.isEnabled = false
		
		// TODO: delete this code when CreateMemeViewController is used at the main view controller
		self.cancelButton.isEnabled = false
		
		// TODO: set top and bottom label font
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
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true) {
			if self.imageView.image != nil {
				self.shareButton.isEnabled = true
			}
		}
	}
}

