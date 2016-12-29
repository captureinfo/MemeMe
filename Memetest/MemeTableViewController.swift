//
//  MemeTableViewController.swift
//  Memetest
//
//  Created by Yang Gao on 12/27/16.
//  Copyright © 2016 Yang Gao. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    // @IBOutlet weak var flowLayout:UIColletionViewFlowLayout!
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.item]
        //        cell.setText(meme.top, bottomString: meme.bottom)
        let imageView = UIImageView(image: meme.memedImage)
        cell.memeImageView? = imageView
        return cell
    }
}
