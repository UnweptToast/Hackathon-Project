//
//  PostItemView.swift
//  hackathon-project
//
//  Created by Sanchith on 2/2/23.
//

import Foundation
import SwiftUI

struct PostItemView: View {
    
    let post: Post
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(post.items)
                    .font(.headline)
                
                Text("For \(post.qty) people approx.")
                    .foregroundColor(Color(.secondaryLabel))
                
            }
            Spacer()
            if post.status == .posted {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.yellow)
            }
            if post.status == .accepted {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.green)
            }
            if post.status == .completed {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.gray)
            }
            Text(post.status?.rawValue.capitalized ?? "")
                .font(.footnote)
        }
        
    }
    
}


struct AcceptedPostItemView: View {
    
    let post: AcceptedPost
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(post.post.post.items)
                    .font(.headline)
                
                Text("For \(post.post.post.qty) people approx.")
                    .foregroundColor(Color(.secondaryLabel))
                
            }
            Spacer()
            if post.post.status == .posted {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.yellow)
            }
            if post.post.status == .accepted {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.green)
            }
            if post.post.status == .completed {
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.gray)
            }
            Text(post.post.status.rawValue.capitalized)
                .font(.footnote)
        }
        
    }
    
}


struct PostItemView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PostItemView(post: Post(items: "Pasta", qty: 4, image: nil, address: ["", "TISB, Dommasandra, Bengaluru - 560123"], info: "", status: .posted))
            PostItemView(post: Post(items: "Pasta", qty: 4, image: nil, address: ["", "TISB, Dommasandra, Bengaluru - 560123"], info: "", status: .completed))
            PostItemView(post: Post(items: "Pasta", qty: 4, image: nil, address: ["", "TISB, Dommasandra, Bengaluru - 560123"], info: "", status: .accepted))
        }
        .listStyle(.plain)
    }
}
