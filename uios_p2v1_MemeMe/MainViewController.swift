//
//  MainViewController.swift
//  uios_p2v1_MemeMe
//
//  Created by Naci Kalyoncu on 08.10.20.
//

import UIKit

class MainViewController: UIViewController,
                          UITextFieldDelegate,
                          UIImagePickerControllerDelegate,
                          UINavigationControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var constraintForKeyboard: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldAttributes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initScreen()
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Text Field Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.textAlignment = .center
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkEditingCompleted()
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Image picker and present
    
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        // get an image picker controller
        let imagePicker = UIImagePickerController()
        // set the delegate
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        // which source should be used
        switch (PickerType(rawValue: sender.tag)!) {
        case .camera:
            imagePicker.sourceType = .camera
        case .album:
            imagePicker.sourceType = .photoLibrary
        }
        // call image picker controller libary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        checkEditingCompleted()
        // dismiss controller
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // display picket image in UIImageView
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            albumButton.isEnabled = false
        }
        checkEditingCompleted()
        // dismiss controller
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelEditing(_ sender: UIBarButtonItem) {
        initScreen()
    }
    
    @IBAction func shareImage(_ sender: UIBarButtonItem) {
        // generate a memed image
        let memedImage = generateMemedImage()
        // define an instance of the ActivityViewController
        // pass the ActivityViewController a memedImage as an activity item
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        // present the ActivityViewController
        present(controller, animated: true, completion: nil)
        // create an activity object
        controller.completionWithItemsHandler = {
            _, completed, _, _ in
            if completed {
                // save
                // The completionWithItemsHandler should be used here, as per specifications.
                // It prevents the app from saving memes when the user cancels the action:
                let _ = Meme(
                            topText: self.textFieldTop.text!,
                            bottomText: self.textFieldBottom.text!,
                            originalImage: self.imageView.image!,
                            memedImage: memedImage)
            }
        }
    }
    
    func generateMemedImage() -> UIImage {

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return memedImage
    }
    
    func initScreen(){
        
        // if camera not available then disable it
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Photos from album can be picked up
        albumButton.isEnabled = true
        
        // can't send, before editing photo finished
        shareButton.isEnabled = false
        
        // image not picked
        imageView.image = nil
        
        setTextFieldAttributes(textFieldTop,text: textTOP)
        setTextFieldAttributes(textFieldBottom, text: textBOTTOM)
        
    }
    
    func setTextFieldAttributes() {
       
       // set default attributes for TextFields
        setTextFieldAttributes(textFieldTop, text: "")
        setTextFieldAttributes(textFieldBottom,text:  "")
   }
    
    func setTextFieldAttributes(_ textField: UITextField, text: String) {
        // set attributes
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        if(text != ""){
            textField.textAlignment = .center
            textField.text = text
        }
    }
    
    func checkEditingCompleted(){
        
        if (imageView.image == nil ||
            self.textFieldTop.text == textTOP ||
                self.textFieldBottom.text == textBOTTOM ){
            shareButton.isEnabled = false
        } else {
            // can be shared editing photo finished
            shareButton.isEnabled = true
        }
    }
    
    // MARK: Keyboard Notifications for constrains
    func subscribeToKeyboardNotifications() {
       // Soft Keyboard notification subscribe
       NotificationCenter.default.addObserver(
           self,
           selector: #selector(keyboardWillShow(with:)),
           name: UIResponder.keyboardWillShowNotification,
           object: nil)
       
       NotificationCenter.default.addObserver(
           self,
           selector: #selector(keyboardWillHide(with:)),
           name: UIResponder.keyboardWillHideNotification,
           object: nil)
   }
   
   
    func unsubscribeFromKeyboardNotifications() {
       // unsubscribe keyboard notifications
       NotificationCenter.default.removeObserver(self,
                                                 name: UIResponder.keyboardWillShowNotification,
                                                 object: nil)
       NotificationCenter.default.removeObserver(self,
                                                 name: UIResponder.keyboardWillHideNotification,
                                                 object: nil)
   }
   
   @objc func keyboardWillShow(with notification: Notification){
       
       let key = "UIKeyboardFrameEndUserInfoKey"
       guard let keyboardFrame = notification.userInfo?[key] as? NSValue else {return}
       let keyboardHeight = keyboardFrame.cgRectValue.height
       constraintForKeyboard.constant = keyboardHeight
       UIView.animate(withDuration: 0.3){
           self.view.layoutIfNeeded()
       }
   }
   @objc func keyboardWillHide(with notification: Notification){
       
       let key = "UIKeyboardFrameEndUserInfoKey"
       guard let keyboardFrame = notification.userInfo?[key] as? NSValue else {return}
       let keyboardHeight = keyboardFrame.cgRectValue.height
       constraintForKeyboard.constant -= keyboardHeight - 20
       UIView.animate(withDuration: 0.3){
           self.view.layoutIfNeeded()
       }
   }
}


