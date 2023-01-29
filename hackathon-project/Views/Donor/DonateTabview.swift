//
//  DonateTabview.swift
//  hackathon-project
//
//  Created by Sanchith on 1/29/23.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct DonateTabView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            TabView {
                
                DonateView()
                    .tabItem {
                        Label("Donate", systemImage: "house.fill")
                    }
                
            }
    }
    
}
