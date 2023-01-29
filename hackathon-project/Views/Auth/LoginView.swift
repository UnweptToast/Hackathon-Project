//
//  LoginView.swift
//  hackathon-project
//
//  Created by Sanchith on 1/29/23.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var email = ""
    
    @State var password = ""
    
    @State var alertMessage = ""
    @State var alertPresented = false
    
    @State var showHomeScreen = false
    
    @State var selectedAccType: AccountType = .none
    
    var body: some View {
        
        Form {
            Section {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
            }
            
            Section {
                Picker("Account Type", selection: $selectedAccType) {
                    
                    Text("None").tag(AccountType.none)
                    Text("Donor").tag(AccountType.donor)
                    Text("Charity").tag(AccountType.charity)
                    Text("Volunteer").tag(AccountType.volunteer)
                    Text("Delivery Partner").tag(AccountType.deliveryPartner)
                    
                }
                .pickerStyle(.menu)
            }
        }
        .navigationTitle("Login")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button("Done", role: .none) {
                    AuthManager.shared.login(email: email, password: password, accountType: selectedAccType) { success, user in
                        
                        guard let user = user, success else {
                            showAlert("Couldn't login to \(email). Please try again later.")
                            return
                        }

                        UserDefaults.standard.set(user.accountType.rawValue, forKey: "accountType")
                        self.selectedAccType = user.accountType
                        self.showHomeScreen = true
                        
                    }
                }
                
            }
        }
        .fullScreenCover(isPresented: $showHomeScreen) {
            if selectedAccType == .donor {
                DonateTabView()
                    .onAppear {
                        dismiss()
                    }
            } else if selectedAccType == .charity {
                DonationsTabView()
                    .onAppear {
                        dismiss()
                    }
            }
        }
        .alert(isPresented: $alertPresented) {
            Alert(title: Text(self.alertMessage))
        }
        
    }
    
    private func deleteFields() {
        
        self.email = ""
        self.password = ""
        
    }
    
    private func showAlert(_ message: String) {
        
        self.alertMessage = message
        self.alertPresented = true
        
    }
    
}
