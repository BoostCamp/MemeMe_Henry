//
//  RealmController.swift
//  MemeMe
//
//  Created by JUNYEONG.YOO on 1/27/17.
//  Copyright © 2017 Boostcamp. All rights reserved.
//

import Foundation
import RealmSwift

class RealmController: NSObject {
	
	private static var realm: Realm {
		return try! Realm()
	}
	
	// Add a new memed image to Realm
	static func insert(_ meme: Meme) {
		try! realm.write {
			realm.add(meme)
		}
	}
	
	// Update a existing memed image
	static func update(old: Meme, updated: Meme) {
//		let oldMeme = realm.objects(Meme.self).filter("memeID == \(old.memeID)").first!
		
		try! realm.write {
//			oldMeme.topText = updated.topText
//			oldMeme.bottomText = updated.bottomText
//			oldMeme.originalImageName = updated.originalImageName
//			oldMeme.memedImageName = updated.memedImageName
			realm.delete(old)
			realm.add(updated)
		}
	}
	
	// Cast meme instances to the array in App Delegate
	static func castToArray(_ memes: inout [Meme]) {
		let allMemes = realm.objects(Meme.self)
		
		for meme in allMemes {
			memes.append(meme)
		}
	}
	
	static func delete(_ deletedMeme: Meme) {
		try! realm.write {
			realm.delete(deletedMeme)
		}
	}
}
