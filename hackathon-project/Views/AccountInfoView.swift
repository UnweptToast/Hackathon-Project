//
//  AccountInfoView.swift
//  hackathon-project
//
//  Created by Sanchith on 1/30/23.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct AccountInfoView: View {
    
    @Environment(\.dismiss) var dismiss
 
    @State var profile: UserProfile
    
    @State var addresses: [String: String]? = nil
    
    @State var addAddress = false
    
    @State var alertPresented = false
    @State var alertMessage = ""
    
    @State var signedOut: () -> Void
    
    var body: some View {

            NavigationView {
                 
                    List {
                        
                        VStack(alignment: .center) {
                            
                            if let image = profile.pfp {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.width / 2.5)
                                    .background(.gray)
                                    .clipShape(Circle())
                                    .aspectRatio(contentMode: .fill)
                                    .padding(.top)
                                    .padding(.top)
                            } else {
                                ZStack {
                                    Circle()
                                        .foregroundColor(.gray)
                                        .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.width / 2.5)
                                    if let first = profile.name.first {
                                        Text(String(first))
                                            .font(.system(size: 65.0, weight: .semibold, design: .rounded))
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.top)
                                .padding(.top)
                            }
                            
                            Text(profile.name)
                                .font(.title)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                                .padding(.bottom, 5)
                            
                            Text("\(profile.email)")
                                .font(.title2)
                                .foregroundColor(Color(.gray))
                            
                            Text("\(profile.phone)")
                                .font(.title2)
                                .foregroundColor(Color(.gray))
                                .frame(width: UIScreen.main.bounds.width)
                                .padding(.bottom)
                        }

                        Section {
                            
                            if let addresses = self.addresses {
                                
                                ForEach(Array(addresses.keys), id: \.self) { key in
                                    
                                        VStack(alignment: .leading) {
                                            Text(key)
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                                .padding(3)
                                            
                                            Text(addresses[key]!)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }

                                        
                                }
                                
                            }
                            
                            Button {
                                
                                self.addAddress = true
                                
                            } label: {
                                HStack {
                                    
                                    Image(systemName: "plus")
                                        .padding(.vertical, 10)
                                        .clipShape(Circle())
                                    
                                    Text("Add an address")
                                    
                                }
                            }

                            
                        } header: {
                            Text("Addresses")
                        }
                        
                        Section {
                            
                            Button {
                                
                                self.signedOut()
                                self.dismiss()
                                
                            } label: {
                                
                                Text("Sign Out")
                                    .frame(width: UIScreen.main.bounds.width)
                                    .foregroundColor(.red)
                                    .padding(.vertical, 5)
                                
                            }

                            
                        }
                        
                    }
                    .headerProminence(.increased)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle(Text("Account Info"))
            }
            .alert(isPresented: $alertPresented, content: {
                Alert(title: Text(self.alertMessage))
            })
            .onAppear {
                
                DataManager.shared.getAddresses(email: profile.email, accountType: profile.accountType) { success, result in
                    
                    guard success else {
                        return
                    }
                    
                    guard let result = result else {
                        self.addresses = [:]
                        return
                    }
                    
                    self.addresses = result
                    
                }
                
            }
            .sheet(isPresented: $addAddress) {
                AddAddressView() { address in
                    DataManager.shared.addAddress(email: profile.email, accountType: profile.accountType, address: address) { success in
                        //#150, 8th cross, 19th main, BTM layout, 2nd Stage, Bangalore - 560076
                        guard success else {
                            showAlert("There was an error adding this address. Try again later.")
                            return
                        }
                        
                        guard self.addresses != nil else {
                            showAlert("An unknown error occured")
                            return
                        }
                        
                        self.addresses![address[0]] = address[1]
                        
                    }
                }
            }
        
    }
    
    private func showAlert(_ message: String) {
        self.alertMessage = message
        self.alertPresented = true
    }
    
}

struct AccountInfoView_Previews: PreviewProvider {
    
    static var previews: some View {
        AccountInfoView(profile: UserProfile(name: "Sanchith", email: "dsanchith@gmail.com", phone: "7760100227", accountType: .donor, pfp: UIImage(systemName: "house.fill"), pfpUrl: "")) {
            
        }
    }
    
}
