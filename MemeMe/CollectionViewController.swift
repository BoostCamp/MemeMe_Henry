//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by JUNYEONG.YOO on 1/26/17.
//  Copyright © 2017 Boostcamp. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
	
	// MARK: Properties
	
	// MARK: IBOutlets
	
	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

	// MARK: Life cycle of view controller
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Set the size of Collection view cell
		let space: CGFloat = 2.0
		let dimension = self.view.frame.size.width / (space * 1.5)
		
		self.flowLayout.minimumInteritemSpacing = space
		self.flowLayout.minimumLineSpacing = space
		self.flowLayout.itemSize = CGSize(width: dimension, height: dimension)
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.collectionView?.reloadData()
	}

    // MARK: Delegate methods for UICollectionView

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MemeController.count()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCell", for: indexPath) as? MemeCollectionViewCell {
			let meme: Meme = MemeController.select(at: indexPath.row)
			
			let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
			let photoURL = URL(fileURLWithPath: documentDirectory)
			let memedImageURL = photoURL.appendingPathComponent(meme.memedImageName)
			
			cell.memeImageView.image = UIImage(contentsOfFile: memedImageURL.path)

			return cell
		}
    
        return UICollectionViewCell()
    }
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "DetailMemeViewController") as? DetailMemeViewController {
			controller.detailMemeOf = indexPath.row
			self.navigationController?.pushViewController(controller, animated: true)
		}
	}
	
	// MARK: Create a new meme image
	
	@IBAction func createNewMemeImage(_ sender: Any) {
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateMemeViewController") as? CreateMemeViewController {
			self.present(controller, animated: true, completion: nil)
		}
	}

}
