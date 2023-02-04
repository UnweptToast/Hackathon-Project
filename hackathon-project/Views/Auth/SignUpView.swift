//
//  SignUpView.swift
//  hackathon-project
//
//  Created by Sanchith on 1/29/23.
//

import Foundation
import SwiftUI
import FirebaseAuth

enum AccountType: String, CaseIterable, Identifiable {
    
    case none = "None", donor = "Donor", charity = "Charity", volunteer = "Volunteer", deliveryPartner = "Delivery Partner"
    var id: Self { self }
    
}

struct SignUpView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.dismiss) var dismiss
    
    @State var name = ""
    
    @State var phone = ""
    
    @State var email = ""
    
    @State var password = ""
    
    @State var image: UIImage? = nil
    
    @State var isPresented = false
    
    @State var showPicker = false
    
    @State var sourceType: UIImagePickerController.SourceType? = nil
    
    @State var selectedAccType: AccountType = .none
    
    @State var options: [AccountType] = AccountType.allCases
    
    @State var alertMessage = ""
    @State var showAlert = false
    
    @State var showHomeScreen = false
    
    var body: some View {
        Form {
            
            Section {
                Picker("Account type", selection: $selectedAccType) {
                    
                    Text("None").tag(AccountType.none)
                    Text("Donor").tag(AccountType.donor)
                    Text("Charity").tag(AccountType.charity)
                    Text("Volunteer").tag(AccountType.volunteer)
                    Text("Delivery Partner").tag(AccountType.deliveryPartner)
                    
                }
                .pickerStyle(.menu)
            } header: {
                Text("Select account type")
            }
            
            Section {
                TextField("Name", text: $name)
                TextField("Phone no.", text: $phone)
            } header: {
                Text("Personal details")
            }
            
            Section {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
            }
            
            if let image = image {
                
                Section {
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(10)
                            .padding(.vertical, 5)
                        
                        VStack {
                            HStack {
                                Spacer()
                                Button {
                                    self.image = nil
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.label))
                                        .padding(10)
                                        .background(.regularMaterial, in: Circle())
                                        .padding(10)
                                        .padding(.vertical, 5)
                                }
                                
                            }
                            Spacer()
                        }
                        
                    }
                }
                
            } else {
                
                Section {
                    Button {
                        self.isPresented = true
                    } label: {
                        Text("Upload photo (optional)")
                            .foregroundColor(.blue)
                    }
                }
                
            }
            
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Sign Up")
        .fullScreenCover(isPresented: $showPicker, content: {
            PhotoPicker(sourceType: self.sourceType!) { image in
                self.image = image
            }
        })
        .actionSheet(isPresented: $isPresented) {
            ActionSheet(title: Text("Please upload an image of your restaurant logo."), buttons: [
                
                Alert.Button.default(Text("Choose from library"), action: {
                    self.sourceType = .photoLibrary
                    self.showPicker = true
                }),
                
                Alert.Button.default(Text("Take a photo"), action: {
                    self.sourceType = .camera
                    self.showPicker = true
                }),
                
                Alert.Button.cancel()
                
            ])
        }
        .animation(.default, value: image)
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
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(self.alertMessage))
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button {
                    validateCredentials()
                } label: {
                    Text("Done")
                }
                
                
            }
        }
    }
    
    private func validateCredentials() {
        
        guard selectedAccType != .none else {
            self.alertMessage = "Please select an account type"
            self.showAlert = true
            return
        }
        
        guard !name.isEmpty, !phone.isEmpty, !email.isEmpty, !password.isEmpty else {
            self.alertMessage = "Name and phone no. fields are mandatory."
            self.showAlert = true
            return
        }
        
        guard phone.count == 10, let _ = Int64(phone) else {
            self.alertMessage = "Please enter a valid 10-digit phone number (do not use country code)."
            self.showAlert = true
            return
        }
        
        let user = UserProfile(name: name, email: email, phone: phone, accountType: selectedAccType, pfp: image, pfpUrl: nil)
        
        AuthManager.shared.createAccount(profile: user, password: password) { success, imageUrl in
            guard success else {
                self.alertMessage = "Something went wrong while signing in. Please try again later."
                self.showAlert = true
                return
            }
            
            UserDefaults.standard.set(selectedAccType.rawValue, forKey: "accountType")
            print("SELECTED TYPE: \(selectedAccType)")
            self.showHomeScreen = true
            
            
        }
        
    }
    
    private func deleteFields() {
        self.selectedAccType = .none
        self.name = ""
        self.phone = ""
        self.email = ""
        self.password = ""
        self.image = nil
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
