//
//  Meme.swift
//  Memetest
//
//  Created by Yang Gao on 12/4/16.
//  Copyright © 2016 Yang Gao. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    /*
    2 strings representing the top and bottom text
    the original image
    a memed image, combining the text and the original image
 */
    let topText: String?
    let bottomText: String?
    let originalImage: UIImage?
    let memedImage: UIImage?
}
