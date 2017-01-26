//
//  TableViewController.swift
//  MemeMe
//
//  Created by JUNYEONG.YOO on 1/24/17.
//  Copyright © 2017 Boostcamp. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
	
	// MARK: Life cycle of view controller

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tableView.reloadData()
		
		if MemeCollection.count() == 0 {
			self.tableView.isHidden = true
		
		} else {
			self.tableView.isHidden = false
		}
	}

	// MARK: Delegate methods for UITableView
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return MemeCollection.count()
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath) as? MemeTableViewCell {
			let meme: Meme = MemeCollection.select(at: indexPath.row)
			
			cell.topLabel.text = meme.topText
			cell.bottomLabel.text = meme.bottomText
			cell.memeImageView.image = meme.memedImage
			cell.accessoryType = .disclosureIndicator
			
			return cell
		}
		
		return UITableViewCell()
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailMemeViewController") as? DetailMemeViewController {
			controller.detailMemeOf = indexPath.row
			self.navigationController?.pushViewController(controller, animated: true)
		}
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		// FIXME: Can I change this hard code?
		return 101.0
	}
	
	// MARK: Create a new meme image
	
	@IBAction func createNewMemeImage(_ sender: Any) {
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateMemeViewController") as? CreateMemeViewController {
			self.present(controller, animated: true, completion: nil)
		}
	}
}
