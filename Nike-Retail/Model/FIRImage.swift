//
//  FIRImage.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 5/14/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import Foundation
import Firebase

class FIRImage
{
    var image: UIImage
    var downloadURL: URL?
    var downloadURLString: String!
    var ref: StorageReference!
    
    init(image: UIImage)
    {
        self.image = image
    }
    
    func saveProfileImage(_ userUID: String, _ completion: @escaping (Error?) -> Void)
    {
        let resizedImage = image.resize()
        if let imageData = resizedImage.jpegData(compressionQuality: 0.9) {
            //1. get the reference
            ref = FIRStorageReference.profileImages.reference().child(userUID)
            downloadURLString = ref.description
            
            //2. save that data to the reference
            ref.putData(imageData, metadata: nil) { (metaData, error) in
                completion(error)
            }
        }
    }
    
    func saveImage(_ uid: String, _ completion: @escaping (Error?) -> Void)
    {
        let resizedImage = image.resize()
        if let imageData = resizedImage.jpegData(compressionQuality: 0.9) {
            //1. get the reference
            ref = FIRStorageReference.images.reference().child(uid)
            downloadURLString = ref.description
            
            //2. save that data to the reference
            ref.putData(imageData, metadata: nil) { (metaData, error) in
                completion(error)
            }
        }
    }
    
    func downloadProfileImage(_ userUID: String, completion: @escaping (UIImage?, Error?) -> Void)
    {
        FIRStorageReference.profileImages.reference().child(userUID).getData(maxSize: 1*1024*1024) { (data, error) in
            if data != nil && error == nil {
                let image = UIImage(data: data!)
                completion(image, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func downloadImage(uid: String, completion: @escaping (UIImage?, Error?) -> Void)
    {
        FIRStorageReference.images.reference().child(uid).getData(maxSize: 1*1024*1024) { (data, error) in
            if data != nil && error == nil {
                let image = UIImage(data: data!)
                completion(image, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getImageUriOf(productUID: String, completion: @escaping (String?) -> Void)
    {
        var uriString = [String]()
        FIRDatabaseReference.products(uid: productUID).reference().child("images").observe(.value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            for (_, uri) in value as! [String : String] {
                uriString.append(uri)
            }
            
            completion(uriString.first)
        }
    }
    
    class func downloadImage(uri: String, completion: @escaping (UIImage?, Error?) -> Void)
    {
        Storage.storage().reference(forURL: uri).getData(maxSize: 1*1024*1024) { (data, error) in
            if data != nil && error == nil {
                let image = UIImage(data: data!)
                completion(image, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}

private extension UIImage
{ 
    func resize() -> UIImage
    {
        let ratio = self.size.width / self.size.height
        let height: CGFloat = 1000
        let width = height * ratio
        
        let newSize = CGSize(width: width, height: height)
        let newRectangle = CGRect(x: 0, y: 0, width: width, height: height)
        
        // context - canvas
        UIGraphicsBeginImageContext(newSize)
        
        // draw the new sized image on the canvas
        self.draw(in: newRectangle)
        
        // get the new sized image into a new variable
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // close the canvas
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
}









