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
    
    @State var foodType = ""
    @State var qty = 0
    @State var qtyString = ""
    
    @State var image: UIImage? = nil
    @State var sourceType: UIImagePickerController.SourceType? = nil
    
    @State var address: [String]? = nil
    
    @State var info = ""
    
    @State var showPicker = false
    
    @State var showActionSheet = false
    
    @State var showProfile = false
    
    @State var selectAddress = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                Form {
                 
                    Section {
                        
                        TextField("Food items", text: $foodType)
                        
                        TextField("Number of people", text: $qtyString)
                            .keyboardType(.numberPad)
                        
                    } header: {
                        Text("Create a post")
                    } footer: {
                        Text("Approximately how many people can this food serve?")
                    }
                    .onChange(of: self.qtyString) { newValue in
                        
                        if !newValue.isEmpty {
                            let QTY = Int(newValue)
                            
                            guard let QTY = QTY else {
                                showAlert("Error logging food quantity. Please try again later.")
                                return
                            }
                            self.qty = QTY
                        }
                        
                    }
                
                    Section {
                        if let image = image {
                                ZStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .cornerRadius(12)
                                        .padding(.vertical, 8)
                                    
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color(.label))
                                                .frame(width: 12, height: 12)
                                                .padding(10)
                                                .background(.regularMaterial, in: Circle())
                                                .padding(10)
                                                .padding(.vertical, 5)
                                                .onTapGesture {
                                                    self.image = nil
                                                    print("Image deleted")
                                                }
                                            
                                        }
                                        Spacer()
                                    }
                                    
                                }
                            
                        } else {
                            
                                Button {
                                    self.showActionSheet = true
                                } label: {
                                    Text("Add photo (optional)")
                                        .foregroundColor(.blue)
                                }
                            
                        }
                    }
                    
                    Section {
                        
                        
                        if let address = self.address {
                            VStack(alignment: .leading) {
                                Text(address[0])
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Text(address[1])
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        
                        Button {
                            
                            self.selectAddress = true
                            
                        } label: {
                            if let address = self.address {
                                Text("Change address")
                            } else {
                                Text("Select address")
                            }
                        }
                        
                    }
                    
                    Section {
                        
                        TextField("Any other additional info?", text: $info, axis: .vertical)
                            .lineLimit(5)
                        
                    }
                    
                    Section {
                        
                        Button {
                            
                            guard !self.foodType.isEmpty, self.qty != 0 else {
                                showAlert("Please enter food items and quantity details.")
                                return
                            }
                            
                            guard let address = self.address, let profile = self.profile else {
                                showAlert("Please enter an address.")
                                return
                            }
                            
                            let post = Post(items: self.foodType, qty: self.qty, image: self.image, address: address, info: self.info, status: .posted)
                            
                            DataManager.shared.createPost(profile: profile, address: address, post: post) { success in
                                
                                guard success else {
                                    showAlert("Error creating post. Please try agian later.")
                                    return
                                }
                                
                                self.foodType = ""
                                self.qty = 0
                                self.qtyString = ""
                                self.image = nil
                                self.address = nil
                                self.info = ""
                                
                                showAlert("Donation has been posted! You can view the status of your donations in the acitivity tab.")
                                
                            }
                            
                        } label: {
                            
                            HStack {
                                
                                Spacer()
                                Text("Post")
                                    .font(.headline)
                                    .padding(5)
                                Spacer()
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Donate")
            .alert(isPresented: $alertPresented, content: {
                Alert(title: Text(self.alertMessage))
            })
            .animation(.default, value: self.image)
            .fullScreenCover(isPresented: $showPicker, content: {
                
                PhotoPicker(sourceType: self.sourceType!) { image in
                    self.image = image
                }
                
            })
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Upload a photo of the packages of food."), buttons: [
                    
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
        }
        .sheet(isPresented: $showProfile, content: {
            
            AccountInfoView(profile: profile!) {
                try! Auth.auth().signOut()
                self.dismiss()
            }
            
        })
        .sheet(isPresented: $selectAddress, content: {
            if let profile = self.profile {
                SelectAddressView(profile: profile) { address in
                    self.address = address
                }
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
    }
    
    private func showAlert(_ message: String) {
        self.alertMessage = message
        self.alertPresented = true
    }
    
}

struct DonateView_Previews: PreviewProvider {
    static var previews: some View {
        DonateView(address: [])
    }
}
