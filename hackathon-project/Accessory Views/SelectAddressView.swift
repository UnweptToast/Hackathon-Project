//
//  SelectAddressView.swift
//  hackathon-project
//
//  Created by Sanchith on 1/31/23.
//

import Foundation
import SwiftUI

struct SelectAddressView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var profile: UserProfile
    
    @State var addresses: [String: String]? = nil
    
    @State var addressSelected: ([String]) -> Void
    
    var body: some View {
        
        NavigationView {
            if addresses == nil || addresses?.count ?? 0 != 0 {
                List {
                    
                    Section {
                        if let addresses = self.addresses {

                            ForEach(Array(addresses.keys), id: \.self) { key in
                                Button {
                                    let keyString = key as String
                                    self.addressSelected([keyString, addresses[keyString]!])
                                    self.dismiss()
                                    
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text(key)
                                            .foregroundColor(Color(.label))
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .padding(3)

                                        Text(addresses[key]!)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }



                            }

                        }
                        
                    }
                    
                }
                .navigationTitle("Select Address")

            }
            else {
                Text("Could not find any saved addresses. You can add an address in the account info screen.")
                    .foregroundColor(Color(.secondaryLabel))
                    .padding(10)
                    .navigationTitle("Select Address")
            }
        }
        .onAppear {
            
            DataManager.shared.getAddresses(email: profile.email, accountType: profile.accountType) { success, result in
                
                guard success else { return }
                
                if let result = result {
                    self.addresses = result
                } else {
                    self.addresses = [:]
                }
                
            }
            
        }
        
    }
    
}
