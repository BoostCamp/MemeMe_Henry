//
//  MemeController.swift
//  MemeMe
//
//  Created by JUNYEONG.YOO on 1/25/17.
//  Copyright © 2017 Boostcamp. All rights reserved.
//

import Foundation
import UIKit

struct MemeController {
	
	private static var appDelegate: AppDelegate {
		return UIApplication.shared.delegate as! AppDelegate
	}
	
	// Returns number of memed images
	static func count() -> Int {
		return appDelegate.memes.count
	}
	
	// Add a new memed image to the array
	static func insert(_ meme: Meme) {
		appDelegate.memes.append(meme)
		RealmController.insert(meme)
	}
	
	// Get a memed image from the array
	static func select(at index: Int) -> Meme {
		return appDelegate.memes[index]
	}
	
	// Update a memed image
	static func update(at index: Int, _ updatedMeme: Meme) {
		let oldMeme = appDelegate.memes[index]
		appDelegate.memes[index] = updatedMeme
		RealmController.update(old: oldMeme, updated: updatedMeme)
	}
	
	// Delete a memed image
	static func delete(at index: Int) {
		let deletedMeme: Meme = appDelegate.memes.remove(at: index)
		
		// Delete images from document directory
		let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
		let documentURL = URL(fileURLWithPath: documentDirectory)
		let originalImageURL = documentURL.appendingPathComponent(deletedMeme.originalImageName)
		let memedImageURL = documentURL.appendingPathComponent(deletedMeme.memedImageName)
		
		do {
			try FileManager.default.removeItem(at: originalImageURL)
			try FileManager.default.removeItem(at: memedImageURL)
		
		} catch {
			print("Could not delete image from document directory")
		}
		
		RealmController.delete(deletedMeme)
	}
}
