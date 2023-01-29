//
//  AuthManager.swift
//  hackathon-project
//
//  Created by Sanchith on 1/29/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class AuthManager {
    
    private init() {}
    
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    private let firestore = Firestore.firestore()
    
    private let storage = Storage.storage().reference()
    
    public func createAccount(profile: UserProfile, password: String, completion: @escaping (Bool, String?) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            
            self.auth.createUser(withEmail: profile.email, password: password) { result, error in
                
                guard let result = result, error == nil else {
                    completion(false, nil)
                    return
                }
                
                if let image = profile.pfp {
                    
                    guard let data = image.pngData() else { return }
                    self.storage.child("\(profile.accountType.rawValue)/\(profile.email.lowercased())").putData(data) { _, error in
                        guard error == nil else {
                            completion(false, nil)
                            return
                        }
                        
                        self.storage.child("\(profile.accountType.rawValue)/\(profile.email.lowercased())").downloadURL { url, error in
                            
                            guard let url = url, error == nil else {
                                completion(false, nil)
                                return
                            }
                            
                            let urlString = url.absoluteString
                            
                            self.firestore.document("\(profile.accountType.rawValue)/\(profile.email.lowercased())").setData([
                                "name": profile.name,
                                "uid": result.user.uid,
                                "phone": profile.phone,
                                "accountType": profile.accountType.rawValue,
                                "pfpUrl": urlString
                                
                            ]) { error in
                                
                                guard error == nil else {
                                    completion(false, nil)
                                    print("ERROR: \(error?.localizedDescription)")
                                    return
                                }
                                
                                completion(true, urlString)
                            }
                            
                        }
                        
                    }
                    
                } else {
                    
                    self.firestore.collection("\(profile.accountType.rawValue)").document(profile.email.lowercased()).setData([
                        "name": profile.name,
                        "uid": result.user.uid,
                        "phone": profile.phone,
                        "accountType": profile.accountType.rawValue,
                        "pfpUrl": ""
                        
                    ]) { error in
                        
                        guard error == nil else {
                            completion(false, nil)
                            return
                        }
                        completion(true, nil)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    public func login(email: String, password: String, accountType: AccountType, completion: @escaping (Bool, UserProfile?) -> Void) {
        
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                print("ERROR: \(error?.localizedDescription)")
                completion(false, nil)
                return
            }
            
            self.firestore.document("\(accountType.rawValue)/\(email.lowercased())").getDocument { snapshot, error in
                
                guard let data = snapshot?.data(), error == nil else {
                    completion(false, nil)
                    return
                }

                let accountType = AccountType(rawValue: data["accountType"] as! String)!
                let name = data["name"] as! String
                let phone = data["phone"] as! String
                let email = email.lowercased()
                let pfpUrl = data["pfpUrl"] as! String

                DataManager.shared.getImage(url: pfpUrl) { image in
                    let image = image
                    let profile = UserProfile(name: name, email: email, phone: phone, accountType: accountType, pfp: image, pfpUrl: pfpUrl)
                    completion(true, profile)
                }
                
            }
            
        }
        
    }
    
}

