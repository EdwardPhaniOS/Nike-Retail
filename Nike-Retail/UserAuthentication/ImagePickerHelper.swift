//
//  ImagePickerHelper.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 5/20/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit
import MobileCoreServices

class ImagePickerHelper: NSObject
{
    typealias imagePickerHelperCompletion = (UIImage?) -> Void
    weak var viewController: UIViewController!
    var completion: imagePickerHelperCompletion?
    var imagePickerController: UIImagePickerController?
    
    init(viewController: UIViewController, completion: imagePickerHelperCompletion?)
    {
        super.init()
        self.viewController = viewController
        self.completion = completion
        
        showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection()
    {
        let actionSheet = UIAlertController(title: "Pick New Photo", message: "Would you like to open camera or library", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.showImagePicker(sourceType: .camera)
        }
        let libraryAction = UIAlertAction(title: "Library", style: .default) { (action) in
             self.showImagePicker(sourceType: .photoLibrary)
        }
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = [kUTTypeImage] as [String]
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        
        self.viewController.present(imagePicker, animated: true, completion: nil)
    }

}

extension ImagePickerHelper: UIImagePickerControllerDelegate & UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        completion!(image)
        viewController.dismiss(animated: true, completion: nil)
    }
}
