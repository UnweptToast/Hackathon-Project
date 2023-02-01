//
//  AddAddressView.swift
//  hackathon-project
//
//  Created by Sanchith on 1/30/23.
//

import Foundation
import SwiftUI

struct AddAddressView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var addressAdded: ([String]) -> Void
    
    @State var text = ""
    
    @State var addressTag = ""
    
    var body: some View {
        
        NavigationView {
            List {
                Section {
                    TextField("Add address", text: $text, axis: .vertical)
                        .lineLimit(5)
                        .frame(minHeight: 40)
                } header: {
                    Text("")
                }
                
                Section {
                    
                    TextField("Save this address as...", text: $addressTag)
                    
                }
                
                Section {
                    Button("Save changes") {
                        
                        let tag = addressTag
                        let address = text
                        self.addressAdded([tag, address])
                        self.dismiss()
                        
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        self.dismiss()
                    }
                }
            }
        }
                
        
    }
    
}

struct AddAddressView_Previews: PreviewProvider {
    
    static var previews: some View {
        AddAddressView { _ in
            
        }
    }
    
}
