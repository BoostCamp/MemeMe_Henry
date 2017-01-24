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
	
	static func count() -> Int {
		return appDelegate.memes.count
	}
	
	static func insert(_ meme: Meme) {
		appDelegate.memes.append(meme)
	}
	
	static func select(at index: Int) -> Meme {
		return appDelegate.memes[index]
	}
}
