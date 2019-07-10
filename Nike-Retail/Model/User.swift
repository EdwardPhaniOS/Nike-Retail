//
//  User.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 5/16/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import UIKit

class User
{
    var username: String
    let uid: String
    var fullname: String
    var profileImage: UIImage?
    var email: String
    
    init(username: String, uid: String, fullname: String, email: String, profileImage: UIImage)
    {
        self.username = username
        self.uid = uid
        self.fullname = fullname
        self.profileImage = profileImage
        self.email = email
    }
    
    //save user information
    
    func save(completion: @escaping (Error?) -> Void)
    {
        let ref = FIRDatabaseReference.users(uid: self.uid).reference()
        ref.setValue(toDictionary())
        
        if let image = self.profileImage {
            let firImage = FIRImage(image: image)
            firImage.saveProfileImage(self.uid) { (error) in
                completion(error)
            }
        }
    }
    
    func toDictionary() -> [String : Any]
    {
        return [
            "uid" : self.uid,
            "username" : self.username,
            "fullname" : self.fullname,
            "email" : self.email
        ]
    }
}

extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool
    {
        return lhs.uid == rhs.uid
    }
}








