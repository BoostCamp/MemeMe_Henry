//
//  Meme.swift
//  MemeMe
//
//  Created by JUNYEONG.YOO on 1/24/17.
//  Copyright © 2017 Boostcamp. All rights reserved.
//

import Foundation
import RealmSwift

class Meme: Object {
	
	dynamic var memeID = 0
	dynamic var topText = ""
	dynamic var bottomText = ""
	dynamic var originalImageName = ""
	dynamic var memedImageName = ""
	
	override class func primaryKey() -> String? {
		return "memeID"
	}
}
