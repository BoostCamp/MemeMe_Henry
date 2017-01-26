//
//  MemeCollection.swift
//  MemeMe
//
//  Created by JUNYEONG.YOO on 1/25/17.
//  Copyright © 2017 Boostcamp. All rights reserved.
//

import Foundation
import UIKit


struct MemeCollection {
	
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
	}
	
	// Get a memed image from the array
	static func select(at index: Int) -> Meme {
		return appDelegate.memes[index]
	}
	
	// Update a memed image
	static func update(at index: Int, _ meme: Meme) {
		appDelegate.memes[index] = meme
	}
}
