//
//  DetailVC.swift
//  MemeMe_1.0
//
//  Created by Andy Xu on 16/4/26.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class DetailVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var textFieldToolbar: UIToolbar!
    @IBOutlet weak var fontSegmentedControl: UISegmentedControl!
    @IBOutlet weak var fontSizeSlider: UISlider!

    var meme: Meme?
    var memeOperation: MemeOperation?
    
    let defaultFont: [UIFont] = [UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, UIFont(name: "GurmukhiMN-Bold", size: 30)!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let flexiableSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        self.toolbarItems = [flexiableSpace, cameraButton, flexiableSpace, albumButton, flexiableSpace]
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        albumButton.enabled = UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
        
        // Set textField Attributes
        let textFieldAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),
                                  NSFontAttributeName: defaultFont[0],
                                  NSStrokeColorAttributeName: UIColor.orangeColor(),
                                  NSStrokeWidthAttributeName: 5]
        topTextField.defaultTextAttributes = textFieldAttributes
        bottomTextField.defaultTextAttributes = textFieldAttributes
        let placeholderAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(),
                                     NSFontAttributeName: defaultFont[1],
                                     NSStrokeColorAttributeName: UIColor.grayColor(),
                                     NSStrokeWidthAttributeName: 5]
        topTextField.attributedPlaceholder = NSAttributedString(string: "Enter Top Text", attributes: placeholderAttributes)
        bottomTextField.attributedPlaceholder = NSAttributedString(string: "Enter Bottom Text", attributes: placeholderAttributes)
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        // Set font configuration
        topTextField.inputAccessoryView = textFieldToolbar
        bottomTextField.inputAccessoryView = textFieldToolbar
        
        fillMemeToView()
        setShareButtonStat()
    }
    
    func fillMemeToView() {
        if let memeData = meme {
            topTextField.text = memeData.topText
            bottomTextField.text = memeData.bottomText
            imageView.image = UIImage(data: memeData.rawImage!)
            
            topTextField.font = UIFont(name: memeData.topTextFont!, size: CGFloat((memeData.topTextFontSize?.floatValue)!))
            bottomTextField.font = UIFont(name: memeData.bottomTextFont!, size: CGFloat((memeData.bottomTextFontSize?.floatValue)!))
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        if let userInfo = notification.userInfo {
            let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            return keyboardSize.CGRectValue().height
        } else {
            return 0
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.transform = CGAffineTransformMakeTranslation(0, -getKeyboardHeight(notification))
        }
        
        if let activedTextField = activedTextField() {
            for font in defaultFont {
                if font.fontName == activedTextField.font?.fontName {
                    fontSegmentedControl.selectedSegmentIndex = defaultFont.indexOf(font)!
                    break
                }
            }
            
            fontSizeSlider.value = Float((activedTextField.font?.pointSize)!)
        }
    }
    
    func keyboardWillHidden(notification: NSNotification) {
        view.transform = CGAffineTransformMakeTranslation(0, 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHidden), name: UIKeyboardWillHideNotification, object: nil)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setShareButtonStat() {
        shareButton.enabled = (imageView.image != nil)
    }
    
    func generateMemedImage() -> UIImage {
        // Hidden TextFields if no text
        topTextField.hidden = (topTextField.text?.isEmpty)!
        bottomTextField.hidden = (bottomTextField.text?.isEmpty)!
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Restore TextField visibility
        topTextField.hidden = false
        bottomTextField.hidden = false
        
        return memedImage
    }
    
    func activedTextField() -> UITextField? {
        if topTextField.isFirstResponder() {
            return topTextField
        } else if bottomTextField.isFirstResponder() {
            return bottomTextField
        } else {
            return nil
        }
    }
    
    func saveMeme() {
        let memedImage = generateMemedImage()
        
        if let meme = self.meme {
            self.memeOperation?.updateMeme(meme,
                                           topText: self.topTextField.text,
                                           bottomText: self.bottomTextField.text,
                                           rawImage: self.imageView.image!,
                                           memedImage: memedImage,
                                           topTextFont: (self.topTextField.font?.fontName)!,
                                           topTextFontSize: (self.topTextField.font?.pointSize)!,
                                           bottomTextFont: (self.bottomTextField.font?.fontName)!,
                                           bottomTextFontSize: (self.bottomTextField.font?.pointSize)!)
        } else {
            self.memeOperation?.insertMeme(self.topTextField.text,
                                           bottomText: self.bottomTextField.text,
                                           rawImage: self.imageView.image!,
                                           memedImage: memedImage,
                                           topTextFont: (self.topTextField.font?.fontName)!,
                                           topTextFontSize: (self.topTextField.font?.pointSize)!,
                                           bottomTextFont: (self.bottomTextField.font?.fontName)!,
                                           bottomTextFontSize: (self.bottomTextField.font?.pointSize)!)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        setShareButtonStat()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        setShareButtonStat()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: IBActions
    @IBAction func presentImagePickerView(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if (sender as! UIBarButtonItem) == cameraButton {
            picker.sourceType = .Camera
        } else {
            picker.sourceType = .PhotoLibrary
            picker.allowsEditing = true
        }
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        view.endEditing(true)
        
        let alertController = UIAlertController(title: "Saved", message: nil, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .Default, handler: { (action) in
                self.navigationController?.popViewControllerAnimated(true)
        }))
        
        presentViewController(alertController, animated: true) {
            self.saveMeme()
        }
        

//        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
//        presentViewController(activityVC, animated: true) {
//                    }
    }
    
    @IBAction func changeFont(sender: AnyObject) {
        if let textField = activedTextField() {
            textField.font = UIFont(name: defaultFont[fontSegmentedControl.selectedSegmentIndex].fontName, size: CGFloat(fontSizeSlider.value))
        }
    }
}