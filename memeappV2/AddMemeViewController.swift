//
//  ViewController.swift
//  memeApp
//
//  Created by Eslam  on 2/21/19.
//  Copyright © 2019 Eslam. All rights reserved.
//

import UIKit



class AddMemeViewController: UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate , UITextFieldDelegate{
    
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topNavigationBar: UIToolbar!
    @IBOutlet weak var uiImagePicker: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraPicker: UIBarButtonItem!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    
    var textFieldRealYPosition: CGFloat = 0.0
    
    var MemedImageGenerated : UIImage?
    
    var meme : Meme?
    
    // view did load Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.isEnabled = false
        textFieldStatus(textField: topTextField, defaultWord: "TOP")
        textFieldStatus(textField: bottomTextField, defaultWord: "BOTTOM")
    }
    
    // view will appear function
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraPicker.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //tell this vc to be ready and know if the keyboard need to be shown (keyboardWillShowNotification) and when the notification sent call func keyboard will show the same for the hide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldStatus (textField: UITextField , defaultWord: String){
        let memeTextAttribute = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -5] as [NSAttributedString.Key : Any]
        textField.delegate = self
        textField.textColor = UIColor.white
        textField.tintColor = UIColor.white
        textField.text = defaultWord
        textField.defaultTextAttributes = memeTextAttribute
        textField.textAlignment = .center
    }
    //**********************buttons action*****************************************
    // oick from camera phone
    func getImage (source : UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        getImage(source: .camera)
    }
    // the button responsibe for picking photo from gallery
    @IBAction func pickImage(_ sender: Any) {
        getImage(source: .photoLibrary)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let memImage = generateMemedImage()
        // set up activity view controller
        let imageToShare = [ memImage ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook , UIActivity.ActivityType.message]
        
        // present the activity view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        // to save the meme struct!!
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        // uiImagePicker.image = nil
        //textFieldStatus()
        self.dismiss(animated: true, completion: nil)
    }
    
    //**********************meme in process*****************************************
    // function for image delegate to save the image that i have picked and put it in the
    //image view and enable the share button
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagee = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            uiImagePicker.image = imagee
        }
        shareButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    // if u clicked cancel while chosing a photo??!!
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // to save a meme with its data in a variable called meme we will use it later
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: uiImagePicker.image!, memedImage: MemedImageGenerated)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    // generating the meme
    //firstly hidden the nav bar and tool bar then render view finally show nav and tool bar again
    func generateMemedImage() -> UIImage {
        self.topNavigationBar.isHidden = true
        self.bottomToolBar.isHidden = true
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        MemedImageGenerated = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.bottomToolBar.isHidden = false
        self.topNavigationBar.isHidden = false
        //  self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        return MemedImageGenerated!
    }
    
    
    //**********************Keyboard issu*****************************************
    //get the keyboard size by the userinfo dectionory in the notification it contains keyboardFrameEndUserInfoKey that have the size of keyboard
    //calculate the distance between textfield and keyboard if <0 lift the frame because the keyboard will appear
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let distanceBetweenTextfielAndKeyboard = self.view.frame.height - textFieldRealYPosition - keyboardSize.height
            
            if distanceBetweenTextfielAndKeyboard < 0{
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    // this func make the y of the view to be 0 again and the keyboard will hide
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //**********************TextField Delegate Func*****************************************
    // what will happen when you click on the text field
    // first make the textfield clear
    //second calculate the position od the text field to know if i need to move keyboard or not
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textFieldRealYPosition = textField.frame.origin.y + textField.frame.height
    }
    
    // if u cliked return in the keyborad save text
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

