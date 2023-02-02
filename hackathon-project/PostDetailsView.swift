//
//  PostDetails.swift
//  hackathon-project
//
//  Created by Sanchith on 2/2/23.
//

import Foundation
import SwiftUI

struct PostDetailsView: View {
    
    let post: Post
    
    var body: some View {
        
        NavigationView {
            List {
                    
                    Section {
                        VStack {
                            Text(post.items)
                                .font(.system(size: 35, weight: .semibold))
                                .padding(.top)
                                .padding(.horizontal)
                            
                            if let image = post.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .background(.red)
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(10)
                                    .padding(10)
                                    .padding(.bottom, 5)
                            }
                        }
                    }
                
                Section {
                    VStack {
                        Text("Delivering from")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                        
                        Text(post.address[1])
                            .font(.title3)
                            .foregroundColor(Color(.secondaryLabel))
                            .padding(.horizontal)
                            .padding(.bottom)
                        
                        Text("Quantity")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                        
                        Text("For \(post.qty) people approx.")
                            .font(.title3)
                            .foregroundColor(Color(.secondaryLabel))
                            .padding(.horizontal)
                            .padding(.bottom)
                        
                        Text("Delivery status")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                        
                        HStack {
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
                                .font(.callout)
                                .foregroundColor(Color(.secondaryLabel))
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 1)
                        .padding(.bottom)
                        
                        if !post.info.isEmpty {
                            Text("Additional information")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                                .padding(.vertical, 1)
                            
                            Text(post.info)
                                .font(.title3)
                                .foregroundColor(Color(.secondaryLabel))
                                .padding(.horizontal)
                        }
                    }
                }
                
            }
            .navigationTitle("Activity details")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
}


struct PostDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            PostDetailsView(post: Post(items: "Pasta", qty: 4, image: UIImage(systemName: "house.fill"), address: ["", "#150, 8th cross, 19th main, BTM layout, 2nd Stage, Bangalore - 560076"], info: "White sauce pasta prepared at 12:30 in the afternoon.", status: .posted))
        }
    }
    
}
