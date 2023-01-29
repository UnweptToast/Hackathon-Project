//
//  DonationsView.swift
//  hackathon-project
//
//  Created by Sanchith on 1/29/23.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct DonationsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                Text("Hello")
                
            }
            .navigationTitle("Donations")
            .toolbar {

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out", role: .destructive) {
                        try! Auth.auth().signOut()
                        self.dismiss()
                    }
                }

            }
        }
        
    }
    
}

struct DonationsView_Previews: PreviewProvider {
    static var previews: some View {
        DonationsView()
    }
}
