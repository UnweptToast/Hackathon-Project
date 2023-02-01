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
            .onAppear {
                
                DataManager.shared.getAddresses(email: profile.email, accountType: profile.accountType) { success, result in
                    
                    guard success else { return }
                    
                    self.addresses = result
                    
                }
                
            }
            .navigationTitle("Select Address")
        }
        
    }
    
}
