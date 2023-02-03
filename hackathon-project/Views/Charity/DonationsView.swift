//
//  DonationsView.swift
//  hackathon-project
//
//  Created by Sanchith on 1/29/23.
//

import Foundation
import SwiftUI
import FirebaseAuth


struct DonationsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var profile: UserProfile? = nil
    
    @State var alertMessage = ""
    @State var alertPresented = false
  
    @State var address: [String]? = nil
    
    @State var showProfile = false
    
    @State var donations: [DonorPost]? = nil
    
    @State var displayMode: NavigationBarItem.TitleDisplayMode = .large
    
    @State var selectedPost: DonorPost? = nil
  
    var body: some View {
        
        NavigationView {
            List {
                
                if let donations = donations {
                    
                    ForEach(0..<donations.count, id: \.self) { int in
                        
                        let post = donations[int]
                        Button {
                            self.selectedPost = post
                        } label: {
                            DonationItemView(post: post)
                        }

                        
                    }
                    
                }
                
            }
            .listStyle(.plain)
            .scrollDismissesKeyboard(.interactively)
            .alert(isPresented: $alertPresented, content: {
                Alert(title: Text(self.alertMessage))
            })
            .toolbar {

                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        
                        if let profile = self.profile {
                            self.showProfile = true
                        }
                        
                    } label: {
                        if let user = profile {
                            
                            if let image = user.pfp {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            } else {
                                ZStack {
                                    Circle()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.gray)
                                    if let first = user.name.first {
                                        Text(String(first))
                                            .font(.system(size: 23.0, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                    }
                                }
                                    
                            }
                            
                        }
                    }



                }

            }
            .navigationTitle("Donations")
        }
        .sheet(isPresented: $showProfile, content: {
            
            AccountInfoView(profile: profile!) {
                try! Auth.auth().signOut()
                self.dismiss()
            }
            
        })
        .fullScreenCover(item: $selectedPost, content: { post in
            if let profile = self.profile {
                DonorPostDetailsView(currentUser: profile, post: post)
            }
        })
        .onAppear {
            
            DataManager.shared.getProfile(email: Auth.auth().currentUser!.email!, accountType: AccountType(rawValue: UserDefaults.standard.value(forKey: "accountType") as! String)!) { success, profile in
                
                guard success else {
                    showAlert("Could not fetch user profile. Please try again later.")
                    return
                }
                
                ProfileManager.shared.profile = profile
                
                self.profile = profile
                
            }
            
        }
        .onAppear {
            
            DataManager.shared.getCurrentPosts { success, posts in
                guard success else {
                    showAlert("Error fetching data. Please try again later.")
                    return
                }
                
                self.donations = posts
                print("POST COUNT: \(posts?.count ?? 0)")
                
            }
            
        }
    }
    
    private func showAlert(_ message: String) {
        self.alertMessage = message
        self.alertPresented = true
    }
    
}

struct DonationsView_Previews: PreviewProvider {
    static var previews: some View {
        DonationsView(address: [])
    }
}
