//
//  FIRReference.swift
//  Nike-Retail
//
//  Created by Tan Vinh Phan on 5/12/19.
//  Copyright © 2019 PTV. All rights reserved.
//

import Foundation
import Firebase

enum FIRDatabaseReference
{
    case root
    case users(uid: String)
    case products(uid: String)
    
    // MARK: - Public
    
    func reference() -> DatabaseReference {
        switch self {
        case .root:
            return rootRef
        case .users:
            return rootRef.child(path)
        case .products:
            return rootRef.child(path)
        }
    }
    
    private var rootRef: DatabaseReference {
        return  Database.database().reference()
    }
    
    private var path: String {
        switch self {
        case .root:
            return ""
        case .users(let uid):
            return "users/\(uid)"
        case .products(let uid):
            return "products/\(uid)"
        }
    }
}


enum FIRStorageReference
{
    case root
    case profileImages
    case images
    
    func reference() -> StorageReference {
        switch self {
        case .root:
            return rootRef
        case .profileImages:
            return rootRef.child(path)
        case .images:
            return rootRef.child(path)
        }
    }
    
    private var rootRef: StorageReference {
        return Storage.storage().reference()
    }
    
    private var path: String {
        switch self {
        case .root:
            return ""
        case .profileImages:
            return "profileImages"
        case .images:
            return "images"
        }
    }
}













