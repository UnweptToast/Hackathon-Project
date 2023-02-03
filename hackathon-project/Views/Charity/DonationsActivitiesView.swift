//
//  DonationsActivitiesView.swift
//  hackathon-project
//
//  Created by Sanchith on 2/3/23.
//

import Foundation
import SwiftUI

struct DonationsActivitiesView: View {
    
    @State var liveActivity: Post? = nil
    @State var liveActivites: [AcceptedPost]? = nil
    
    @State var history: [AcceptedPost]? = nil
    
    @State var liveActivityFetched = false
    @State var historyFetched = false
    @State var liveActivitesFetched = false
    
    @State var alertPresented = false
    @State var alertMessage = ""

    @State var selectedActivity: AcceptedPost? = nil
    
    @State var profile: UserProfile? = nil
    
    var body: some View {
        
        NavigationView {
            List {
                
                Section {
                    
                    if let liveActivites = self.liveActivites, self.liveActivitesFetched {
                        if liveActivites.count != 0 {

                            ForEach(liveActivites) { post in
                                
                                Button {
                                    self.selectedActivity = post
                                } label: {
                                    AcceptedPostItemView(post: post)
                                }
                                
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
                        
                        Text("You haven't received any donations in the past.")
                            .foregroundColor(Color(.secondaryLabel))
                        
                    }
                    
                } header: {
                    Text("History")
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
            
                DataManager.shared.getLiveDonations(profile: profile) { success, posts in
                    
                    guard success else {
                        showAlert("Could not fetch live activities.")
                        return
                    }
                    
                    self.liveActivites = posts
                    self.liveActivitesFetched = true
                    
                    
                    
                    print("LIVE ACTIVITIES FETCHED")
                    
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
        
    }
    
    private func showAlert(_ message: String) {
        self.alertMessage = message
        self.alertPresented = true
    }
    
}
