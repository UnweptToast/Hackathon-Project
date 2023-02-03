//
//  DonorPost.swift
//  hackathon-project
//
//  Created by Sanchith on 2/2/23.
//

import Foundation

struct DonorPost: Identifiable {
    
    let id = UUID()
    let by: String
    let post: NoImagePost
    let status: DonationStatus
    
}

struct NoImagePost {
    
    let items: String
    let qty: Int
    let imageUrl: String?
    let address: [String]
    let info: String
    let status: DonationStatus?
    
    init(items: String, qty: Int, imageUrl: String?, address: [String], info: String, status: DonationStatus?) {
        self.items = items
        self.qty = qty
        self.imageUrl = imageUrl
        self.address = address
        self.info = info
        self.status = status
    }
    
    init(post: Post, imageUrl: String) {
        
        self.items = post.items
        self.qty = post.qty
        self.address = post.address
        self.info = post.info
        self.status = post.status
        self.imageUrl = imageUrl
        
    }
    
}
