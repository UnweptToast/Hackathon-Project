//
//  DonorPostDetailsView.swift
//  hackathon-project
//
//  Created by Sanchith on 2/2/23.
//

import Foundation
import SwiftUI

struct DonorPostDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let currentUser: UserProfile
    
    let post: DonorPost
    
    @State var image: UIImage? = nil
    @State var profile: UserProfile? = nil

    @State var alertMessage = ""
    @State var alertPresented = false
    
    @State var showActionSheet = false
    
    @State var showAcceptDonationView = false
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                
                VStack {
                    
                    if let image = self.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(15)
                            .padding()
                            .padding(.bottom, 5)
                    } else if let url = post.post.imageUrl, !url.isEmpty {
                        ZStack {
                            Rectangle()
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(Color(.secondarySystemBackground))
                                .cornerRadius(15)
                                .padding()
                                .padding(.bottom, 5)
                            Text("Loading...")
                                .foregroundColor(Color(.secondaryLabel))
                        }
                    }
                }
                
                VStack {
                    Text("Delivering from")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.vertical, 1)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    Text(post.post.address[1])
                        .font(.title3)
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.horizontal)
                        .padding(.bottom)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    Text("Quantity")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.vertical, 1)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    Text("For \(post.post.qty) people approx.")
                        .font(.title3)
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.bottom)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)

                    

                    .padding(.horizontal)
                    .padding(.vertical, 1)
                    .padding(.bottom)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    if !post.post.info.isEmpty {
                        Text("Additional information")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        
                        Text(post.post.info)
                            .font(.title3)
                            .foregroundColor(Color(.secondaryLabel))
                            .padding(.horizontal)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    }
                }
                
                VStack {
                    
                    if let profile = self.profile {
                        Text("From")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        
                        Text(profile.name)
                            .font(.title3)
                            .foregroundColor(Color(.secondaryLabel))
                            .padding(.horizontal)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        
                        Button {
                            
                            let phone = "+91\(profile.phone)"
                            let mail = profile.email
                            
                            self.showActionSheet = true
                            
                            
                        } label: {
                            HStack {
                                
                                VStack {
                                    
                                    HStack {
                                        Text("Contact Info")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal)
                                            .padding(.vertical, 1)
                                        Spacer()
                                    }
                                
                                    HStack {
                                        Text("Email: \(profile.email)")
                                            .font(.title3)
                                            .foregroundColor(Color(.secondaryLabel))
                                            .padding(.horizontal)
                                        Spacer()
                                    }
                                
                                    HStack {
                                        Text("Phone: +91 \(profile.phone)")
                                            .font(.title3)
                                            .foregroundColor(Color(.secondaryLabel))
                                            .padding(.horizontal)
                                        Spacer()
                                    }
                            }
                            .padding(15)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(20)
                            .padding()
                            .padding(.leading, 10)
                                
                                Spacer()
                                
                            }
                            .tint(.white)
                        }
                        
                        if post.status != .completed {
                            Button {
        
                                self.showAcceptDonationView = true
                                
                            } label: {
                            VStack {
                                Text("Accept Donation")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal)
                                    .padding(.vertical, 1)
                                
                                
                                
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(20)
                            .padding(.horizontal)
                            }
                        }
                    }
                    
                }
                
            }
            .navigationTitle(Text(post.post.items))
            .navigationBarBackButtonHidden()
            .sheet(isPresented: $showAcceptDonationView, content: {
                
                if let profile = self.profile {
                    AcceptDonationView(profile: self.currentUser) { address, info in
                        
                        DataManager.shared.acceptPost(by: profile.email, to: currentUser.email, address: address[1], info: info) { success in
                            
                            guard success else {
                                showAlert("Something went wrong. Please try again later.")
                                return
                            }
                            
                            self.dismiss()
                            
                        }
                        
                    }
                }
            })
            .onAppear {
                
                DataManager.shared.getImage(url: post.post.imageUrl ?? "") { image in
                    
                    self.image = image
                    
                }
                
            }
            .onAppear {
                
                DataManager.shared.getProfile(email: post.by, accountType: .donor) { success, result in
                    
                    guard let result = result, success else {
                        self.showAlert("Error fetching donor's profile. Please try again later.")
                        return
                    }
                    
                    self.profile = result
                    
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        self.dismiss()
                    }
                }
            }
            .alert(isPresented: $alertPresented) {
                Alert(title: Text(self.alertMessage))
            }
            .confirmationDialog("", isPresented: $showActionSheet) {
                
                if let profile = profile {
                    Button("Phone") {
                        if UIApplication.shared.canOpenURL(URL(string: "tel://+91\(profile.phone)")!) {
                            UIApplication.shared.open(URL(string: "tel://+91\(profile.phone)")!)
                        }
                    }
                    
                    Button("Mail") {
                        if UIApplication.shared.canOpenURL(URL(string: "mailto:\(profile.email)")!) {
                            UIApplication.shared.open(URL(string: "mailto:\(profile.email)")!)
                        }
                    }
                }
            }
        }
        
    }
    
    private func showAlert(_ message: String) {
        self.alertMessage = message
        self.alertPresented = true
    }
    
}
