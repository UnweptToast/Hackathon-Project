//
//  DataManager.swift
//  hackathon-project
//
//  Created by Sanchith on 1/29/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage

class DataManager {
    
    static let shared = DataManager()
    
    let firestore = Firestore.firestore()
    
    private let storage = Storage.storage().reference()
    
    private init() {}
    
    public func getProfile(email: String, accountType: AccountType, completion: @escaping (Bool, UserProfile?) -> Void) {
        
        firestore.document("\(accountType.rawValue)/\(email)").getDocument { snapshot, error in
            
            guard let data = snapshot?.data(), error == nil else {
                completion(false, nil)
                return
            }
            
            let name = data["name"] as! String
            let phone = data["phone"] as! String
            let pfpUrl = data["pfpUrl"] as! String
            
            self.getImage(url: pfpUrl) { image in
                
                let user = UserProfile(name: name, email: email, phone: phone, accountType: accountType, pfp: image, pfpUrl: pfpUrl)
                
                ProfileManager.shared.profile = user
                
                completion(true, user)
                
            }
            
            
        }
        
    }
    
    public func getAddresses(email: String, accountType: AccountType, completion: @escaping (Bool, [String: String]?) -> Void) {
        
        self.firestore.document("\(accountType.rawValue)/\(email)").getDocument { snapshot, error in
            
            
            guard let data = snapshot?.data(), error == nil else {
                completion(false, nil)
                return
            }
            
            guard let addresses = data["addresses"] as? [String:String] else {
                completion(true, nil)
                return
            }
            
            completion(true, addresses)
            
        }
        
    }
    
    public func addAddress(email: String, accountType: AccountType, address: [String], completion: @escaping (Bool) -> Void) {
        
        self.firestore.document("\(accountType.rawValue)/\(email)").setData([
            "addresses": [
                address[0]: address[1]
            ]
        ], merge: true) { error in
            
            guard error == nil else {
                completion(false)
                return
            }
            
            completion(true)
            
        }
        
        
        
    }
    
    public func createPost(profile: UserProfile, address: [String], post: Post, completion: @escaping (Bool) -> Void) {
        
        if let image = profile.pfp {
            
            uploadImage(image: image, path: "Posts/\(UUID())") { success, url in
                
                guard let url = url, success else {
                    completion(false)
                    return
                }
                
                self.firestore.document("Posts/\(profile.email)").setData([
                    "by": profile.email,
                    "status": "posted",
                    "post": [
                        "items": post.items,
                        "qty": post.qty,
                        "address": address[1],
                        "info": post.info,
                        "imageUrl": url
                        
                    ]
                ], merge: true) { error in
                    
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    
                    completion(true)
                    
                }
                
            }
            
        } else {
            
            self.firestore.document("History/\(profile.email)").setData([
                "by": profile.email,
                "status": "posted",
                "post": [
                    "items": post.items,
                    "qty": post.qty,
                    "address": address[1],
                    "info": post.info,
                    "imageUrl": ""
                    
                ]
            ], merge: true) { error in
                
                guard error == nil else {
                    completion(false)
                    return
                }
                
                completion(true)
                
            }
            
        }
        
    }
    
    public func getLivePost(profile: UserProfile, completion: @escaping (Post?) -> Void) {
        
        self.firestore.document("Posts/\(profile.email)").getDocument { snapshot, error in
            
            guard let data = snapshot?.data(), error == nil else {
                completion(nil)
                return
            }
            
            let postData = data["post"] as! [String: Any]
            let imageUrl = postData["imageUrl"] as! String
            let status = DonationStatus(rawValue: data["status"] as! String)!
            
            self.getImage(url: imageUrl) { image in
                let post = self.getPost(_from: postData, image: image, status: status)
                completion(post)
            }
            
        }
        
    }
    
    public func getPost(_from data: [String: Any], image: UIImage?, status: DonationStatus) -> Post {
        
        let address =  data["address"] as! String
        let imagUrl = data["imageUrl"] as! String
        let info = data["info"] as! String
        let items = data["items"] as! String
        let qty = data["qty"] as! Int
        
        return Post(items: items, qty: qty, image: image, address: ["", address], info: info, status: status)
        
    }
    
    public func uploadImage(image: UIImage, path: String, completion: @escaping (Bool, String?) -> Void) {
            
            guard let data = image.pngData() else { return }
            self.storage.child(path).putData(data) { _, error in
                guard error == nil else {
                    completion(false, nil)
                    return
                }
                
                self.storage.child(path).downloadURL { url, error in
                    
                    guard let url = url, error == nil else {
                        completion(false, nil)
                        return
                    }
                    
                    let urlString = url.absoluteString
                    
                    completion(true, urlString)
                    
                }
                
            }
        
    }
    
    public func getImage(url: String, completion: @escaping (UIImage?) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
            
        }.resume()
        
    }
    
}
