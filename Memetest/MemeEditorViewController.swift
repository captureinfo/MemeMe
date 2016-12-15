//
//  MemeEditorViewController.swift
//  Memetest
//
//  Created by Yang Gao on 11/7/16.
//  Copyright © 2016 Yang Gao. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    
    @IBOutlet weak var memeImage: UIImageView!

    @IBOutlet weak var cameraButton: UIBarButtonItem!
 
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    func imagePickerController(picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.image = image
            memeImage.contentMode = .ScaleAspectFit
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func pickAnImageFromAlbumWithSender(sender: AnyObject) {
        pickAnImageFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCameraWithSender(sender: AnyObject) {
        pickAnImageFromSource(UIImagePickerControllerSourceType.Camera)
    }
    
    func pickAnImageFromSource(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
        imagePicker.sourceType = source
    }
    
    @IBAction func shareMemeWithSender(sender: AnyObject) {
        let memedImage = generateMemedImage()
        save()
        let vc = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.5
    ] as [String : AnyObject]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        configureTextFields(textTop, defaultString: "TOP")
        configureTextFields(textBottom, defaultString: "BOTTOM")
        subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureTextFields(textTop, defaultString: "TOP")
        configureTextFields(textBottom, defaultString: "BOTTOM")
    }
    
    func configureTextFields(textField: UITextField, defaultString: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.borderStyle = .None
        textField.textAlignment = .Center
        textField.text = defaultString
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if textBottom.isFirstResponder() {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if textBottom.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // Unsubscribe
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        hideNavBarAndToolBar(true)
        
        // render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideNavBarAndToolBar(false)
        return memedImage
    }
    
    func hideNavBarAndToolBar(hide: Bool) {
        navBar.hidden = hide
        toolBar.hidden = hide
    }
    
    func save() {
        //Create the meme
        let meme = Meme( topText: textTop.text!, bottomText: textBottom.text!, originalImage: memeImage.image, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.sharedApplication().delegate as!
            AppDelegate).memes.append(meme)
    }
}

