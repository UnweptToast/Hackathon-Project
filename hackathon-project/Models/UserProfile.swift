//
//  UserProfile.swift
//  hackathon-project
//
//  Created by Sanchith on 1/29/23.
//

import Foundation
import UIKit

struct UserProfile {
    
    let name: String
    let email: String
    let phone: String
    let accountType: AccountType
    let pfp: UIImage?
    let pfpUrl: String?
    
    init(profile: UserProfile, pfpUrl: String?) {
        self.name = profile.name
        self.email = profile.email
        self.phone = profile.phone
        self.accountType = profile.accountType
        self.pfp = profile.pfp
        self.pfpUrl = pfpUrl
    }
    
    init(name: String, email: String, phone: String, accountType: AccountType, pfp: UIImage?, pfpUrl: String?) {
        self.name = name
        self.email = email
        self.phone = phone
        self.accountType = accountType
        self.pfp = pfp
        self.pfpUrl = pfpUrl
    }
    
}
