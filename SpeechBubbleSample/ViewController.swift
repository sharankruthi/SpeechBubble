//
//  ViewController.swift
//  SpeechBubbleSample
//
//  Created by Sharanya on 8/23/15.
//  Copyright (c) 2015 Sharanya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // MARK:
    // MARK: IBOutlets
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var choosePictureButton: UIButton!
    
    // MARK:
    // MARK: Private Methods
    
    private let imagePickerController:UIImagePickerController = UIImagePickerController();
    lazy private var speechView:SpeechBubbleView = SpeechBubbleView(frame: CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-70))

    
    // MARK:
    // MARK: Base Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        self.view.backgroundColor = UIColorFromRGB(0xFFFFCC)
        
        speechView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(speechView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:
    // MARK: Private Methods

    private func chooseFromLibrary(sender: AnyObject)
    {
        if(UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary))
        {
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.modalPresentationStyle = .Popover
            presentViewController(imagePickerController, animated: true, completion: nil)
            imagePickerController.popoverPresentationController?.sourceView = sender as! UIButton
        }
    }

    private func chooseFromPhoto(sender: AnyObject)
    {
        if(UIImagePickerController.isSourceTypeAvailable(.Camera)
            && UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil)
        {
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .Camera
            imagePickerController.cameraCaptureMode = .Photo
            imagePickerController.modalPresentationStyle = .FullScreen
            presentViewController(imagePickerController, animated: true, completion: nil)
            speechView.clearAllBubbles()
        }
        else
        {
            showCameraNotAvailableMessage();
        }
    }
    
    // MARK:
    // MARK: IBActions Methods
    
    @IBAction func choosePicture(sender: UIButton)
    {
        let alertActionSheetController = UIAlertController(title: "Photo from", message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            alertActionSheetController.dismissViewControllerAnimated(true, completion:nil)
        }
        
        let chooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .Default) { [weak self] (action) -> Void in
            alertActionSheetController.dismissViewControllerAnimated(true, completion:nil)
            self?.chooseFromLibrary(sender)
        }
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default) {[weak self] (action) -> Void in
            alertActionSheetController.dismissViewControllerAnimated(true, completion:nil)
            self?.chooseFromPhoto(sender)
        }
        
        alertActionSheetController.addAction(cancelAction);
        alertActionSheetController.addAction(chooseFromLibraryAction);
        alertActionSheetController.addAction(takePhotoAction);
        
        alertActionSheetController.popoverPresentationController?.sourceView = sender;
        alertActionSheetController.popoverPresentationController?.permittedArrowDirections = .Down;
        alertActionSheetController.popoverPresentationController?.sourceRect = CGRectMake(sender.frame.size.width/8, 0, sender.frame.size.width, sender.frame.size.height)
        
        self.presentViewController(alertActionSheetController,animated: true,completion: nil)
    }
    
    @IBAction func addSpeechBubble(sender: UIButton)
    {
        speechView.createNewBubble()
    }
    
    
    // MARK:
    // MARK: UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        userImageView.contentMode = .ScaleAspectFit
        userImageView.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil)
        speechView.clearAllBubbles()
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK:
    // MARK: Alert Warning
    
    
    func showCameraNotAvailableMessage()
    {
        let alertActionSheetController = UIAlertController(title: "Info", message: "Camera not found", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler:nil)
       
        alertActionSheetController.addAction(okAction);
        presentViewController(alertActionSheetController, animated: true, completion: nil)
    }
    
    // MARK:
    // MARK: Helper methods
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor
    {
        return UIColor( red:   CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue:  CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // MARK:


}

