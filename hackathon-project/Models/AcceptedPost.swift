//
//  File.swift
//  hackathon-project
//
//  Created by Sanchith on 2/3/23.
//

import Foundation
import SwiftUI

struct AcceptedPost: Identifiable {
    
    let id = UUID()
    let address: String
    let info: String
    let email: String
    let post: DonorPost
    
}
