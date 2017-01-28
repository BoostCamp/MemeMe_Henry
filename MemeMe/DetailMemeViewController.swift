//
//  DetailMemeViewController.swift
//  MemeMe
//
//  Created by JUNYEONG.YOO on 1/26/17.
//  Copyright © 2017 Boostcamp. All rights reserved.
//

import UIKit

class DetailMemeViewController: UIViewController {
	
	// MARK: - Properties
	var detailMemeOf: Int!
	
	let memeTextAttributes: [String : Any] = [
		NSStrokeColorAttributeName : UIColor.black,
		NSForegroundColorAttributeName : UIColor.white,
		NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
		NSStrokeWidthAttributeName : -3.0
	]

	// MARK: - IBOutlets
	
	@IBOutlet weak var toolbarForSize: UIToolbar!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	
	// MARK: - Life cycle of view controller
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.toolbarForSize.isHidden = true
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.topTextField.isEnabled = false
		self.bottomTextField.isEnabled = false
		
		let meme = MemeController.select(at: self.detailMemeOf)
		
		let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
		let photoURL = URL(fileURLWithPath: documentDirectory)
		let originalImageURL = photoURL.appendingPathComponent(meme.originalImageName)
		
		self.imageView.image = UIImage(contentsOfFile: originalImageURL.path)
		self.topTextField.text = meme.topText
		self.bottomTextField.text = meme.bottomText
		
		// Set attributes of the text field
		self.topTextField.defaultTextAttributes = memeTextAttributes
		self.topTextField.textAlignment = .center
		self.bottomTextField.defaultTextAttributes = memeTextAttributes
		self.bottomTextField.textAlignment = .center
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.popViewController(animated: false)
	}

	// MARK: - Edit meme image when a user click the edit button
	
	@IBAction func editMemeAction(_ sender: Any) {
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateMemeViewController") as? CreateMemeViewController {
			controller.isEditMode = true
			controller.editMemeOf = self.detailMemeOf
			self.present(controller, animated: true, completion: nil)
		}
	}
	
	// MARK: - Delete selected meme image
	
	@IBAction func deleteMemeAction(_ sender: Any) {
		let controller = UIAlertController()
		controller.title = "Delete meme"
		controller.message = "Do you want to delete this meme image?"
		
		let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { action in
			MemeController.delete(at: self.detailMemeOf)
			self.navigationController?.popToRootViewController(animated: true)
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		controller.addAction(confirmAction)
		controller.addAction(cancelAction)
		self.present(controller, animated: true, completion: nil)
	}
	
}
