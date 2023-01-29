//
//  UserEnvObject.swift
//  hackathon-project
//
//  Created by Sanchith on 1/29/23.
//

import Foundation
import UIKit

class UserEnvObject: ObservableObject {
    
    @Published var name: String
    @Published var email: String
    @Published var phone: String
    @Published var accountType: AccountType
    @Published var pfp: UIImage?
    @Published var pfpUrl: String?
    
    init(profile: UserProfile) {
        self.name = profile.name
        self.email = profile.email
        self.phone = profile.phone
        self.accountType = profile.accountType
        self.pfp = profile.pfp
        self.pfpUrl = profile.pfpUrl
    }
    
}
