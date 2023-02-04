//
//  AcceptDonationView.swift
//  hackathon-project
//
//  Created by Sanchith on 2/3/23.
//

import Foundation
import SwiftUI

struct AcceptDonationView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let profile: UserProfile
    
    let completion: ([String], String) -> Void
    
    @State var address: [String]? =  nil
    
    @State var selectAddress = false
    
    @State var info = ""
    
    @State var alertMessage = ""
    @State var alertPresented = false
    
    var body: some View {
        
        NavigationView {
            
            List {
                
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
                            Label("Change address", systemImage: "pencil")
                        } else {
                            Label("Select Address", systemImage: "pencil")
                        }
                    }
                    
                } footer: {
                    Text("The food will be delivered to this address")
                }
                    
                Section {
                    TextField("Any additional info?", text: $info)
                }
                    
                Section {
                    Button {
                        
                        guard let address = address else {
                            showAlert("Please select an address.")
                            return
                        }
                        
                        self.completion(address, info)
                        self.dismiss()
                        
                    } label: {
                        Text("Accept")
                    }
                } footer: {
                    Text("Contact the donor for more details.")
                }
                
            }
            .navigationTitle("Accept Donation")
            .sheet(isPresented: $selectAddress) {
                SelectAddressView(profile: profile) { selection in
                    self.address = selection
                }
            }
            .alert(isPresented: $alertPresented) {
                Alert(title: Text(self.alertMessage))
            }
            
            
        }
        
    }
    
    private func showAlert(_ message: String) {
        self.alertMessage = message
        self.alertPresented = true
    }
    
}
