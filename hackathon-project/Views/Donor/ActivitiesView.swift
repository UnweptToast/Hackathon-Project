//
//  ActivitiesView.swift
//  hackathon-project
//
//  Created by Sanchith on 2/1/23.
//

import Foundation
import SwiftUI

struct ActivitiesView: View {
    
    @State var liveActivity: Post? = nil
    
    @State var history: [Post]? = nil
    
    @State var liveActivityFetched = false
    @State var historyFetched = false
    
    @State var alertPresented = false
    @State var alertMessage = ""
    
    @State var showLiveActivityDetails = false
    
    var body: some View {
        
        NavigationView {
            List {
                
                Section {
                    
                    if liveActivityFetched {
                        if let liveActivity = self.liveActivity {

                            Button {
                                self.showLiveActivityDetails = true
                            } label: {
                                PostItemView(post: liveActivity)
                            }

                            
                        } else {
                            
                            Text("No donations happening right now.")
                                .foregroundColor(Color(.secondaryLabel))
                            
                        }
                    }
                    
                } header: {
                    Text("Active right now")
                }
                
                Section {
                    
                    if let history = self.history, history.count > 0 {
                        
                        ForEach(0..<history.count) { int in

                            Text("Item \(int)")
                            
                        }
                        
                    } else {
                        
                        Text("You haven't made any donations in the past.")
                            .foregroundColor(Color(.secondaryLabel))
                        
                    }
                    
                } header: {
                    Text("Past donations")
                }
                
            }
            .listStyle(.plain)
            .navigationTitle("Activities")
            .onAppear {
                
                guard let profile = ProfileManager.shared.profile else {
                    showAlert("Could not fetch your profile. Please try again.")
                    return
                }
                
                DataManager.shared.getLivePost(profile: profile) { post in
                    
                    self.liveActivity = post
                    self.liveActivityFetched = true
                    print("DONE")
                }
                
            }
        }
        .sheet(isPresented: $showLiveActivityDetails) {
            if let liveActivity = self.liveActivity {
                PostDetailsView(post: liveActivity)
            }
        }
        
    }
    
    private func showAlert(_ message: String) {
        self.alertMessage = message
        self.alertPresented = true
    }
    
}
