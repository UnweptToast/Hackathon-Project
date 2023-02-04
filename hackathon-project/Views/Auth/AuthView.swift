//
//  AuthView.swift
//  hackathon-project
//
//  Created by Sanchith on 1/29/23.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct AuthView: View {
    
    @State var showHomeScreen = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                Spacer()
                
                NavigationLink {
                    LoginView()
                } label: {
                    Text("Login")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 40)
                        .background(.blue)
                        .cornerRadius(20)
                }
                
                NavigationLink {
                    SignUpView()
                } label: {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .padding()
                }


                
            }
            .navigationTitle(Text("FoodHive"))
            .background {
                
                Image("App background 1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    
                    
                    
            }
            .fullScreenCover(isPresented: $showHomeScreen) {
                
                let accType = UserDefaults.standard.value(forKey: "accountType") as? String ?? ""
                
                if AccountType(rawValue: accType) == .charity {
                    DonationsTabView()
                } else if AccountType(rawValue: accType) == .donor {
                    DonateTabView()
                }
                
            }
            .onAppear {
                if Auth.auth().currentUser != nil {
                    if let _ = UserDefaults.standard.value(forKey: "accountType") as? String {
                        self.showHomeScreen = true
                    }
                }
            }
            
        }
        .background(.secondary)
        
    }
    
}
