//
//  ProfileManager.swift
//  hackathon-project
//
//  Created by Sanchith on 2/1/23.
//

import Foundation
import SwiftUI

class ProfileManager {
    
    static let shared = ProfileManager()
    
    private init() {}
    
    public var profile: UserProfile?
    
}
