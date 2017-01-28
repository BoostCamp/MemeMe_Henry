//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by JUNYEONG.YOO on 1/26/17.
//  Copyright © 2017 Boostcamp. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	// MARK: - Life cycle of view controller
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.collectionView?.reloadData()
	}

    // MARK: - Delegate methods for UICollectionView

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
	
	// MARK: - Delegate methods for UICollectionViewDelegateFlowLayout
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width: CGFloat = collectionView.frame.width / 3 - 1
		return CGSize(width: width, height: width)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1.0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1.0
	}
	
	// MARK: - Create a new meme image
	
	@IBAction func createNewMemeImage(_ sender: Any) {
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateMemeViewController") as? CreateMemeViewController {
			self.present(controller, animated: true, completion: nil)
		}
	}

}
