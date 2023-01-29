//
//  DataManager.swift
//  hackathon-project
//
//  Created by Sanchith on 1/29/23.
//

import Foundation
import UIKit
import FirebaseFirestore

class DataManager {
    
    static let shared = DataManager()
    
    let firestore = Firestore.firestore()
    
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
                completion(true, user)
                
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
