//
//  DonateView.swift
//  hackathon-project
//
//  Created by Sanchith on 1/29/23.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct DonateView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var profile: UserProfile? = nil
    
    @State var alertMessage = ""
    @State var alertPresented = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                Form {
                 
                    Text("Hello")
                    
                }
                
            }
            .navigationTitle("Donate")
            .alert(isPresented: $alertPresented, content: {
                Alert(title: Text(self.alertMessage))
            })
            .toolbar {

                ToolbarItem(placement: .navigationBarTrailing) {
                    
//                    Button("Sign Out", role: .destructive) {
//                        try! Auth.auth().signOut()
//                        self.dismiss()
//                    }
                    
                    Button {
                        try! Auth.auth().signOut()
                        self.dismiss()
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
        }
        .onAppear {
            
            DataManager.shared.getProfile(email: Auth.auth().currentUser!.email!, accountType: AccountType(rawValue: UserDefaults.standard.value(forKey: "accountType") as! String)!) { success, profile in
                
                guard success else {
                    showAlert("Could not fetch user profile. Please try again later.")
                    return
                }
                
                self.profile = profile
                
            }
            
        }
    }
    
    private func showAlert(_ message: String) {
        self.alertMessage = message
        self.alertPresented = true
    }
    
}

struct DonateView_Previews: PreviewProvider {
    static var previews: some View {
        DonateView()
    }
}
