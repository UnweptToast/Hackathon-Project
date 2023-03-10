//
//  Post.swift
//  hackathon-project
//
//  Created by Sanchith on 2/1/23.
//

import Foundation
import UIKit

struct Post {
    
    let items: String
    let qty: Int
    var image: UIImage?
    let address: [String]
    let info: String
    let status: DonationStatus?
    let to: AcceptedBy?
    
    init(items: String, qty: Int, image: UIImage? = nil, address: [String], info: String, status: DonationStatus?) {
        self.items = items
        self.qty = qty
        self.image = image
        self.address = address
        self.info = info
        self.status = status
        self.to = nil
    }
    
    init(post: Post, to: AcceptedBy) {
        self.items = post.items
        self.qty = post.qty
        self.image = post.image
        self.address = post.address
        self.info = post.info
        self.status = post.status
        self.to = to
    }
    
}

struct AcceptedBy {
    let address: String
    let email: String
    let info: String
}
