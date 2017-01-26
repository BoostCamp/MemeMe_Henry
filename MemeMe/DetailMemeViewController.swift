//
//  DetailMemeViewController.swift
//  MemeMe
//
//  Created by JUNYEONG.YOO on 1/26/17.
//  Copyright © 2017 Boostcamp. All rights reserved.
//

import UIKit

class DetailMemeViewController: UIViewController {
	
	// MARK: Properties
	var detailMemeOf: Int!
	
	let memeTextAttributes:[String:Any] = [
		NSStrokeColorAttributeName: UIColor.black,
		NSForegroundColorAttributeName: UIColor.white,
		NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
		NSStrokeWidthAttributeName: -3.0
	]

	// MARK: IBOutlets
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	
	// MARK: Life cycle of view controller
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.topTextField.isEnabled = false
		self.bottomTextField.isEnabled = false
		
		let meme = MemeCollection.select(at: self.detailMemeOf)
		self.imageView.image = meme.originalImage
		self.topTextField.text = meme.topText
		self.bottomTextField.text = meme.bottomText
		
		// Set attributes of the text field
		self.topTextField.defaultTextAttributes = memeTextAttributes
		self.topTextField.textAlignment = .center
		self.bottomTextField.defaultTextAttributes = memeTextAttributes
		self.bottomTextField.textAlignment = .center
	}

	// MARK: Edit meme image when a user click the edit button
	
	@IBAction func editMemeAction(_ sender: Any) {
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateMemeViewController") as? CreateMemeViewController {
			controller.isEditMode = true
			controller.editMemeOf = self.detailMemeOf
			self.present(controller, animated: true, completion: nil)
		}
	}
	
}
