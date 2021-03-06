//
//  Comon.swift
//  uios_p2v1_MemeMe
//
//  Created by Naci Kalyoncu on 10.10.20.
//

import UIKit

// MARK: Properties
enum PickerType: Int{case camera=0, album }

let textTOP = "TOP"
let textBOTTOM = "BOTTOM"


let memeTextAttributes:[NSAttributedString.Key:Any] = [
    NSAttributedString.Key.strokeColor: UIColor.black,
    NSAttributedString.Key.foregroundColor: UIColor.white,
    NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSAttributedString.Key.strokeWidth: -3.0]

// struct for Meme object to share
struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}
