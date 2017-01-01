//
//  MemeDetailViewController.swift
//  Memetest
//
//  Created by Yang Gao on 1/1/17.
//  Copyright © 2017 Yang Gao. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.imageView!.image = meme.memedImage
    }
}
