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
                print("ERROR: \(error?.localizedDescription)")
                completion(false, nil)
                return
            }
            
            let name = data["name"] as! String
            let phone = data["phone"] as! String
            let pfpUrl = data["pfpUrl"] as! String
            
            self.getImage(url: pfpUrl) { image in
                
                let user = UserProfile(name: name, email: email, phone: phone, accountType: accountType, pfp: image, pfpUrl: pfpUrl)
                
                completion(true, user)
                
            }
            
            
        }
        
    }
    
    public func getAddresses(email: String, accountType: AccountType, completion: @escaping (Bool, [String: String]?) -> Void) {
        
        self.firestore.document("\(accountType.rawValue)/\(email)").addSnapshotListener { snapshot, error in
            
            
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
        
        if let image = post.image {
            
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
            
            self.firestore.document("Posts/\(profile.email)").setData([
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
        
        self.firestore.document("Posts/\(profile.email)").addSnapshotListener { snapshot, error in
            
            guard let data = snapshot?.data(), error == nil else {
                completion(nil)
                return
            }
            
            let postData = data["post"] as! [String: Any]
            let imageUrl = postData["imageUrl"] as! String
            let status = DonationStatus(rawValue: data["status"] as! String)!
            
            if status == .posted {
                self.getImage(url: imageUrl) { image in
                    let post = self.getPost(_from: postData, image: image, status: status)
                    completion(post)
                }
            } else {
                
                let to = data["to"] as? [String: String]

                guard let to = to else {
                    completion(nil)
                    return
                }
                
                let address = to["address"]!
                let info = to["info"]!
                let email = to["email"]!
                
                self.getImage(url: imageUrl) { image in
                    let post = self.getPost(_from: postData, image: image, status: status)
                    let completePost = Post(post: post, to: AcceptedBy(address: address, email: email, info: info))
                    completion(completePost)
                }
                
                
            }
            
        }
        
    }
    
    public func getCurrentPosts(completion: @escaping (Bool, [DonorPost]?) -> Void) {
        
        var posts: [DonorPost] = []
        
        self.firestore.collection("Posts").addSnapshotListener { snapshot, error in
            
            guard let documents = snapshot?.documents, error == nil else {
                completion(false, nil)
                return
            }

            documents.forEach { snapshot in
                
                let data = snapshot.data()
                let post = self.getDonorPost(from: data)
                if post.status == .posted {
                    posts.append(post)
                }
                
            }
            
            completion(true, posts)
            posts = []
            
        }
        
    }
    
    public func acceptPost(by: String, to: String, address: String, info: String, completion: @escaping (Bool) -> Void) {
        
        self.firestore.document("Posts/\(by)").setData([
            "to": [
                "email": to,
                "address": address,
                "info": info
            ],
            "status": "accepted"
        ], merge: true) { error in
            
            guard error == nil else {
                completion(false)
                return
            }
            
            completion(true)
            
        }
        
    }
    
    public func getLiveDonations(profile: UserProfile, completion: @escaping (Bool, [AcceptedPost]?) -> Void) {
        
        var posts: [AcceptedPost] = []
        
        firestore.collection("Posts").addSnapshotListener { snapshot, error in
            
            guard error == nil, let documents = snapshot?.documents else {
                completion(false, nil)
                return
            }
            
            documents.forEach { snapshot in
                
                let data = snapshot.data()

                
                if DonationStatus(rawValue: data["status"] as! String) == .accepted {
                    
                    if (data["to"] as! [String: String])["email"]! == profile.email {
                        
                        let donorPost = self.getDonorPost(from: data)
                        let address = (data["to"] as! [String: String])["address"]!
                        let info = (data["to"] as! [String: String])["info"]!
                        let email = (data["to"] as! [String: String])["email"]!
                        let post = AcceptedPost(address: address, info: info, email: email, post: donorPost)
                        posts.append(post)
                        
                    }
        
                }
            }
            
            completion(true, posts)
            posts = []
            
        }
        
    }
    
    public func completeDonation(post: AcceptedPost, completion: @escaping (Bool) -> Void) {
        
        self.firestore.document("Posts/\(post.post.by)").getDocument { snapshot, error in
            
            guard let data = snapshot?.data(), error == nil else {
                completion(false)
                return
            }
            
            let id = UUID().uuidString
            
            self.firestore.document("History/\(id)").setData(data) { error in
                
                guard error == nil else {
                    completion(false)
                    return
                }
                
//                self.firestore.document("Donor/\(post.post.by)").setData([
//                    "history": [id]
//                ], mergeFields: ["history"]) { _ in
//                    self.firestore.document("Charity/\(post.email)").setData([
//                        "history": [id]
//                    ], mergeFields: ["history"]) { _ in
//
//                        self.firestore.document("Posts/\(post.post.by)").delete() { _ in
//
//                            completion(true)
//
//                        }
//
//                    }
//                }
                
                let group = DispatchGroup()
                
                group.enter()
                group.enter()
                
                self.firestore.document("Donor/\(post.post.by)").getDocument { snapshot, error in
                    
                    guard error == nil, let data = snapshot?.data() else {
                        group.leave()
                        completion(false)
                        return
                    }
                    
                    let history = data["history"] as? [String]
                    var modified: [String] = []
                    
                    if let history = history {
                        modified = history
                    }
                    
                    modified.append(id)
                    
                    self.firestore.document("Donor/\(post.post.by)").setData([
                        "history": modified
                    ], mergeFields: ["history"]) { _ in
                        group.leave()
                        
                    }
                    
                }
                
                self.firestore.document("Charity/\(post.email)").getDocument { snapshot, error in
                    
                    guard error == nil, let data = snapshot?.data() else {
                        group.leave()
                        completion(false)
                        return
                    }
                    
                    let history = data["history"] as? [String]
                    var modified: [String] = []
                    
                    if let history = history {
                        modified = history
                    }
                    
                    modified.append(id)
                    
                    self.firestore.document("Charity/\(post.email)").setData([
                        "history": modified
                    ], mergeFields: ["history"]) { _ in
                        group.leave()
                    }
                    
                }
                
                group.notify(queue: .global()) {
                    self.firestore.document("Posts/\(post.post.by)").delete() { _ in
                        
                        completion(true)
                        
                    }
                }
                
                
                
            }
            
        }
        
    }
    
    public func getHistory(profile: UserProfile, completion: @escaping (Bool, [AcceptedPost]?) -> Void) {
        
        var posts: [AcceptedPost] = []
            
        self.firestore.document("\(profile.accountType.rawValue.capitalized)/\(profile.email)").addSnapshotListener { snapshot, error in
                
                guard let data = snapshot?.data(), error == nil else {
                    completion(false, nil)
                    return
                }
                
                let history = (data["history"] as? [String]) ?? []
                
                let group = DispatchGroup()
                
                history.forEach { id in
                    
                    group.enter()
                    
                    self.firestore.document("History/\(id)").getDocument { snapshot, error in
                        
                        guard let history = snapshot?.data(), error == nil else {
                            group.leave()
                            completion(false, nil)
                            return
                        }
                        
                        let donorPost = self.getDonorPost(from: history)
                        let address = (history["to"] as! [String: String])["address"]!
                        let info = (history["to"] as! [String: String])["info"]!
                        let email = (history["to"] as! [String: String])["email"]!
                        let post = AcceptedPost(address: address, info: info, email: email, post: donorPost)
                        let completedPost = self.changePostStatus(post: post, status: .completed)
                        posts.append(completedPost)
                        
                        group.leave()
                        
                    }
                    
                    
                }
                
                group.notify(queue: .global()) {
                    
                    completion(true, posts)
                    print("POSTS: \(posts)")
                    posts = []
                    
                }
                
            }
        
    }
    
    public func changePostStatus(post: AcceptedPost, status: DonationStatus) -> AcceptedPost {
        
        let noImagePost = NoImagePost(items: post.post.post.items, qty: post.post.post.qty, imageUrl: post.post.post.imageUrl, address: post.post.post.address, info: post.post.post.info, status: status)
        let donorPost = DonorPost(by: post.post.by, post: noImagePost, status: status)
        let acceptedPost = AcceptedPost(address: post.address, info: post.info, email: post.email, post: donorPost)
        
        return acceptedPost
        
    }
    
    public func getDonorPost(from data: [String: Any]) -> DonorPost {
        
        let by = data["by"] as! String
        let status = data["status"] as! String
        let post = self.getPost(_from: data["post"] as! [String: Any], image: nil, status: DonationStatus(rawValue: status)!)
        let imageUrl = (data["post"] as! [String: Any])["imageUrl"] as! String
        
        return DonorPost(by: by, post: NoImagePost(post: post, imageUrl: imageUrl), status: DonationStatus(rawValue: status)!)
        
        
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
