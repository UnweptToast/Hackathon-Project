//
//  DonationsTabView.swift
//  hackathon-project
//
//  Created by Sanchith on 1/29/23.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct DonationsTabView: View {

    
    var body: some View {
            TabView {
                
                DonationsView()
                    .tabItem {
                        Label("Donations", systemImage: "indianrupeesign.circle.fill")
                    }
                
                DonationsActivitiesView()
                    .tabItem {
                        Label("Activity", systemImage: "arrow.up.arrow.down")
                    }
                
            }
    }
    
}

