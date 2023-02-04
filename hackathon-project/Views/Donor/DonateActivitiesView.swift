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
    
    @State var history: [AcceptedPost]? = nil
    
    @State var liveActivityFetched = false
    @State var historyFetched = false
    
    @State var alertPresented = false
    @State var alertMessage = ""
    
    @State var showLiveActivityDetails = false
    
    @State var selectedActivity: AcceptedPost? = nil
    
    @State var profile: UserProfile? = nil
    
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
                    
                    if let history = self.history, history.count > 0, self.historyFetched {
                        
                        ForEach(history) { post in

                            Button {
                                self.selectedActivity = post
                            } label: {
                                AcceptedPostItemView(post: post)
                            }
                            
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
                
                self.profile = profile
                
                DataManager.shared.getLivePost(profile: profile) { post in
                    
                    self.liveActivity = post
                    self.liveActivityFetched = true
                    print("DONE")
                }
                
                DataManager.shared.getHistory(profile: profile) { success, posts in
                    
                    guard success else {
                        showAlert("Could not fetch history.")
                        return
                    }
                    
                    self.historyFetched = true
                    self.history = posts
                    
                }
                
            }
        }
        .sheet(item: $selectedActivity) { post in
            
            if let profile = self.profile {
                AcceptedPostDetailsView(currentUser: profile, post: post)
            }
        }
        .sheet(isPresented: $showLiveActivityDetails) {
            if let liveActivity = self.liveActivity, let profile = self.profile {
                PostDetailsView(currentUser: profile, post: liveActivity)
            }
        }
        
    }
    
    private func showAlert(_ message: String) {
        self.alertMessage = message
        self.alertPresented = true
    }
    
}
