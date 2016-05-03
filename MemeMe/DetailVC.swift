//
//  DetailVC.swift
//  MemeMe_1.0
//
//  Created by Andy Xu on 16/4/26.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class DetailVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var textFieldToolbar: UIToolbar!
    @IBOutlet weak var fontSegmentedControl: UISegmentedControl!
    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var drawingView: UIView!

    var meme: Meme?
    var memeOperation: MemeOperation?
    
    let defaultFont: [UIFont] = [UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, UIFont(name: "GurmukhiMN-Bold", size: 30)!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        albumButton.enabled = UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
        
        // Set textField Attributes
        setupTextField(topTextField, defaultText: nil, placeholder: "Enter Top Text", defaultAttributes: textFieldAttributes(defaultFont[0]))
        setupTextField(bottomTextField, defaultText: nil, placeholder: "Enter Bottom Text", defaultAttributes: textFieldAttributes(defaultFont[1]))

        // Update Data
        setShareButtonStat()
    }
    
    func setupTextField(textField: UITextField, defaultText: String?, placeholder: String?, defaultAttributes: [String: AnyObject]?) {
        // Set textField attributes
        textField.defaultTextAttributes = defaultAttributes!
        textField.text = defaultText
        if let ph = placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: ph, attributes: defaultAttributes!)
        }
        textField.textAlignment = .Center
        
        // Set font configuration toolbar
        textField.inputAccessoryView = textFieldToolbar
    }
    
    func textFieldAttributes(font: UIFont) -> [String: AnyObject] {
        return [NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: font,
                NSStrokeColorAttributeName: UIColor.blackColor(),
                NSStrokeWidthAttributeName: -3]
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
        // Move view to prevent keyboard covers textField
        if let textField = activedTextField() {
            let testRect = drawingView.convertRect(textField.frame, toView: view)
            let moveDistance = max((getKeyboardHeight(notification) - (view.frame.size.height - testRect.size.height - testRect.origin.y)), 0)
            drawingView.transform = CGAffineTransformMakeTranslation(0, -moveDistance)
        }
        
        // Setup font configuration controls
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
        drawingView.transform = CGAffineTransformMakeTranslation(0, 0)
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
        UIGraphicsBeginImageContext(drawingView.frame.size)
        drawingView.drawViewHierarchyInRect(drawingView.bounds, afterScreenUpdates: true)
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
    
    func saveMeme(memedImage: UIImage) {
        if let meme = self.meme {
            memeOperation?.updateMeme(meme,
                                           topText: self.topTextField.text,
                                           bottomText: self.bottomTextField.text,
                                           rawImage: self.imageView.image!,
                                           memedImage: memedImage,
                                           topTextFont: (self.topTextField.font?.fontName)!,
                                           topTextFontSize: (self.topTextField.font?.pointSize)!,
                                           bottomTextFont: (self.bottomTextField.font?.fontName)!,
                                           bottomTextFontSize: (self.bottomTextField.font?.pointSize)!)
        } else {
            memeOperation?.insertMeme(self.topTextField.text,
                                           bottomText: self.bottomTextField.text,
                                           rawImage: self.imageView.image!,
                                           memedImage: memedImage,
                                           topTextFont: (self.topTextField.font?.fontName)!,
                                           topTextFontSize: (self.topTextField.font?.pointSize)!,
                                           bottomTextFont: (self.bottomTextField.font?.fontName)!,
                                           bottomTextFontSize: (self.bottomTextField.font?.pointSize)!)
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
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
        let memedImage = generateMemedImage()
        
        let alertController = UIAlertController(title: "Saved", message: nil, preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: "Done", style: .Cancel, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        let shareAction = UIAlertAction(title: "Share", style: .Default) { (action) in
            let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            activityVC.completionWithItemsHandler = {(s: String?, ok: Bool, items: [AnyObject]?, err: NSError?) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
        alertController.addAction(doneAction)
        alertController.addAction(shareAction)
        
        presentViewController(alertController, animated: true) {
            self.saveMeme(memedImage)
        }
    }
    
    @IBAction func changeFont(sender: AnyObject) {
        if let textField = activedTextField() {
            textField.font = UIFont(name: defaultFont[fontSegmentedControl.selectedSegmentIndex].fontName, size: CGFloat(fontSizeSlider.value))
        }
    }
    
    @IBAction func cancelButtonOnClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}