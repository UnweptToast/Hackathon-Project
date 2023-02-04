//
//  DonationItemView.swift
//  hackathon-project
//
//  Created by Sanchith on 2/2/23.
//

import Foundation
import SwiftUI

struct DonationItemView: View {
    
    let post: DonorPost
    
    @State var image: UIImage? = nil
    
    var body: some View {
            
            VStack(alignment: .leading) {
                Text(post.post.items)
                    .font(.headline)
                    
                Text("For \(post.post.qty) people approx.")
                    .foregroundColor(Color(.secondaryLabel))
                
                Text("From: \(post.by)")
                    .font(.subheadline)
                    .foregroundColor(Color(.secondaryLabel))
            }
        
    }
    
}

struct DonationItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        List {
            
            DonationItemView(post: DonorPost(by: "dsanchith@gmail.com", post: NoImagePost(post: Post(items: "Pasta", qty: 20, address: ["", "ABCDEFGHIJKL"], info: "white sauce pasta made at 12:30 pm today", status: .posted), imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/hackathon-project-1eebb.appspot.com/o/Posts%2FD08BDBFD-695E-4D6B-884A-AFFCAE85B8ED?alt=media&token=856407a5-8929-4c70-b25d-57942f07da02"), status: .posted))
            
            DonationItemView(post: DonorPost(by: "dsanchith@gmail.com", post: NoImagePost(post: Post(items: "Pasta", qty: 20, address: ["", "ABCDEFGHIJKL"], info: "white sauce pasta made at 12:30 pm today", status: .posted), imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/hackathon-project-1eebb.appspot.com/o/Posts%2FD08BDBFD-695E-4D6B-884A-AFFCAE85B8ED?alt=media&token=856407a5-8929-4c70-b25d-57942f07da02"), status: .posted))
            
            DonationItemView(post: DonorPost(by: "dsanchith@gmail.com", post: NoImagePost(post: Post(items: "Pasta", qty: 20, address: ["", "ABCDEFGHIJKL"], info: "white sauce pasta made at 12:30 pm today", status: .posted), imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/hackathon-project-1eebb.appspot.com/o/Posts%2FD08BDBFD-695E-4D6B-884A-AFFCAE85B8ED?alt=media&token=856407a5-8929-4c70-b25d-57942f07da02"), status: .posted))
            
            DonationItemView(post: DonorPost(by: "dsanchith@gmail.com", post: NoImagePost(post: Post(items: "Pasta", qty: 20, address: ["", "ABCDEFGHIJKL"], info: "white sauce pasta made at 12:30 pm today", status: .posted), imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/hackathon-project-1eebb.appspot.com/o/Posts%2FD08BDBFD-695E-4D6B-884A-AFFCAE85B8ED?alt=media&token=856407a5-8929-4c70-b25d-57942f07da02"), status: .posted))

        }
        .listStyle(.plain)
        
    }
    
}
