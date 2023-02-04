//
//  PostDetails.swift
//  hackathon-project
//
//  Created by Sanchith on 2/2/23.
//

import Foundation
import SwiftUI


struct PostDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let currentUser: UserProfile
    
    let post: Post
    
    @State var profile: UserProfile? = nil

    @State var alertMessage = ""
    @State var alertPresented = false
    
    @State var showActionSheet = false
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                
                VStack {
                    
                    if let image = post.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(15)
                            .padding()
                            .padding(.bottom, 5)
                    }
                }
                
                VStack {
                    Text("Delivering from")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.vertical, 1)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    Text(post.address[1])
                        .font(.title3)
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.horizontal)
                        .padding(.bottom)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    Text("Quantity")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.vertical, 1)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    Text("For \(post.qty) people approx.")
                        .font(.title3)
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.bottom)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)

                    

                    .padding(.horizontal)
                    .padding(.vertical, 1)
                    .padding(.bottom)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    if !post.info.isEmpty {
                        Text("Additional information")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        
                        Text(post.info)
                            .font(.title3)
                            .foregroundColor(Color(.secondaryLabel))
                            .padding(.horizontal)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    }
                }
                
                VStack {
                    
                    if let profile = self.profile {
                        Text("Accepted by:")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        
                        Text(profile.name)
                            .font(.title3)
                            .foregroundColor(Color(.secondaryLabel))
                            .padding(.horizontal)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        
                        Button {
                            
                            let phone = "+91\(profile.phone)"
                            let mail = profile.email
                            
                            self.showActionSheet = true
                            
                            
                        } label: {
                            HStack {
                                
                                VStack {
                                    
                                    HStack {
                                        Text("Contact Info")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal)
                                            .padding(.vertical, 1)
                                        Spacer()
                                    }
                                
                                    HStack {
                                        Text("Email: \(profile.email)")
                                            .font(.title3)
                                            .foregroundColor(Color(.secondaryLabel))
                                            .padding(.horizontal)
                                        Spacer()
                                    }
                                
                                    HStack {
                                        Text("Phone: +91 \(profile.phone)")
                                            .font(.title3)
                                            .foregroundColor(Color(.secondaryLabel))
                                            .padding(.horizontal)
                                        Spacer()
                                    }
                            }
                            .padding(10)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(20)
                            .padding()
                            .padding(.leading, 10)
                                
                                Spacer()
                                
                            }
                            .tint(.white)
                        
                            }
                        
                    }
                    
                }
                
            }
            .navigationTitle(Text(post.items))
            .onAppear {
                
                guard let to = post.to else { return }
                
                DataManager.shared.getProfile(email: to.email, accountType: .charity) { success, result in

                    guard let result = result, success else {
                        self.showAlert("Error fetching user's profile. Please try again later.")
                        return
                    }

                    self.profile = result

                }

                
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        self.dismiss()
                    }
                }
            }
            .alert(isPresented: $alertPresented) {
                Alert(title: Text(self.alertMessage))
            }
            .confirmationDialog("", isPresented: $showActionSheet) {
                
                if let profile = profile {
                    Button("Phone") {
                        if UIApplication.shared.canOpenURL(URL(string: "tel://+91\(profile.phone)")!) {
                            UIApplication.shared.open(URL(string: "tel://+91\(profile.phone)")!)
                        }
                    }
                    
                    Button("Mail") {
                        if UIApplication.shared.canOpenURL(URL(string: "mailto:\(profile.email)")!) {
                            UIApplication.shared.open(URL(string: "mailto:\(profile.email)")!)
                        }
                    }
                }
            }
        }
        
    }
    
    private func showAlert(_ message: String) {
        self.alertMessage = message
        self.alertPresented = true
    }
    
}

//struct PostDetailsView: View {
//
//    let post: Post
//
//    var body: some View {
//
//        NavigationView {
//            List {
//
//                    Section {
//                        VStack {
//                            Text(post.items)
//                                .font(.system(size: 35, weight: .semibold))
//                                .padding(.top)
//                                .padding(.horizontal)
//
//                            if let image = post.image {
//                                Image(uiImage: image)
//                                    .resizable()
//                                    .background(.red)
//                                    .aspectRatio(contentMode: .fill)
//                                    .cornerRadius(10)
//                                    .padding(10)
//                                    .padding(.bottom, 5)
//                            }
//                        }
//                    }
//
//                Section {
//                    VStack {
//                        Text("Delivering from")
//                            .font(.title3)
//                            .fontWeight(.semibold)
//                            .padding(.horizontal)
//                            .padding(.vertical, 1)
//
//                        Text(post.address[1])
//                            .font(.title3)
//                            .foregroundColor(Color(.secondaryLabel))
//                            .padding(.horizontal)
//                            .padding(.bottom)
//
//                        Text("Quantity")
//                            .font(.title3)
//                            .fontWeight(.semibold)
//                            .padding(.horizontal)
//                            .padding(.vertical, 1)
//
//                        Text("For \(post.qty) people approx.")
//                            .font(.title3)
//                            .foregroundColor(Color(.secondaryLabel))
//                            .padding(.horizontal)
//                            .padding(.bottom)
//
//                        Text("Delivery status")
//                            .font(.title3)
//                            .fontWeight(.semibold)
//                            .padding(.horizontal)
//                            .padding(.vertical, 1)
//
//                        HStack {
//                            if post.status == .posted {
//                                Circle()
//                                    .frame(width: 10, height: 10)
//                                    .foregroundColor(.yellow)
//                            }
//                            if post.status == .accepted {
//                                Circle()
//                                    .frame(width: 10, height: 10)
//                                    .foregroundColor(.green)
//                            }
//                            if post.status == .completed {
//                                Circle()
//                                    .frame(width: 10, height: 10)
//                                    .foregroundColor(.gray)
//                            }
//                            Text(post.status?.rawValue.capitalized ?? "")
//                                .font(.callout)
//                                .foregroundColor(Color(.secondaryLabel))
//                        }
//                        .padding(.horizontal)
//                        .padding(.vertical, 1)
//                        .padding(.bottom)
//
//                        if !post.info.isEmpty {
//                            Text("Additional information")
//                                .font(.title3)
//                                .fontWeight(.semibold)
//                                .padding(.horizontal)
//                                .padding(.vertical, 1)
//
//                            Text(post.info)
//                                .font(.title3)
//                                .foregroundColor(Color(.secondaryLabel))
//                                .padding(.horizontal)
//                        }
//                    }
//                }
//
//            }
//            .navigationTitle("Activity details")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//
//    }
//
//}

struct AcceptedPostDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let currentUser: UserProfile
    
    let post: AcceptedPost
    
    @State var image: UIImage? = nil
    @State var profile: UserProfile? = nil

    @State var alertMessage = ""
    @State var alertPresented = false
    
    @State var showActionSheet = false
    
    @State var isCompleted = false
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                
                VStack {
                    
                    if let image = self.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(15)
                            .padding()
                            .padding(.bottom, 5)
                    } else if let url = post.post.post.imageUrl, !url.isEmpty {
                        ZStack {
                            Rectangle()
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(Color(.secondarySystemBackground))
                                .cornerRadius(15)
                                .padding()
                                .padding(.bottom, 5)
                            Text("Loading...")
                                .foregroundColor(Color(.secondaryLabel))
                        }
                    }
                }
                
                VStack {
                    Text("Delivering from")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.vertical, 1)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    Text(post.post.post.address[1])
                        .font(.title3)
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.horizontal)
                        .padding(.bottom)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    Text("Quantity")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.vertical, 1)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    Text("For \(post.post.post.qty) people approx.")
                        .font(.title3)
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.bottom)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)

                    

                    .padding(.horizontal)
                    .padding(.vertical, 1)
                    .padding(.bottom)
                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    
                    if !post.post.post.info.isEmpty {
                        Text("Additional information")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        
                        Text(post.post.post.info)
                            .font(.title3)
                            .foregroundColor(Color(.secondaryLabel))
                            .padding(.horizontal)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    }
                }
                
                VStack {
                    
                    if let profile = self.profile {
                        Text(self.currentUser.accountType == .donor ? "Recipient" : "Donor")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        
                        Text(profile.name)
                            .font(.title3)
                            .foregroundColor(Color(.secondaryLabel))
                            .padding(.horizontal)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        
                        Button {
                            
                            let phone = "+91\(profile.phone)"
                            let mail = profile.email
                            
                            self.showActionSheet = true
                            
                            
                        } label: {
                            HStack {
                                
                                VStack {
                                    
                                    HStack {
                                        Text("Contact Info")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal)
                                            .padding(.vertical, 1)
                                        Spacer()
                                    }
                                
                                    HStack {
                                        Text("Email: \(profile.email)")
                                            .font(.title3)
                                            .foregroundColor(Color(.secondaryLabel))
                                            .padding(.horizontal)
                                        Spacer()
                                    }
                                
                                    HStack {
                                        Text("Phone: +91 \(profile.phone)")
                                            .font(.title3)
                                            .foregroundColor(Color(.secondaryLabel))
                                            .padding(.horizontal)
                                        Spacer()
                                    }
                            }
                            .padding(10)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(20)
                            .padding()
                            .padding(.leading, 10)
                                
                                Spacer()
                                
                            }
                            .tint(.white)
                        }
                        
                        if post.post.status != .completed {
                            Button {
        
                                self.isCompleted = true
                                DataManager.shared.completeDonation(post: post) { success in
                                    
                                    guard success else {
                                        showAlert("An unknown error occured. Please try again.")
                                        return
                                    }
                                    
                                    self.dismiss()
                                    
                                }
                                
                            } label: {
                            VStack {
                                Text("Mark as completed")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal)
                                    .padding(.vertical, 1)
                                
                                
                                
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(20)
                            .padding(.horizontal)
                            }
                        }
                        
                    }
                    
                }
                
            }
            .navigationTitle(Text(post.post.post.items))
            .onAppear {
                
                DataManager.shared.getImage(url: post.post.post.imageUrl ?? "") { image in
                    
                    self.image = image
                    
                }
                
            }
            .onAppear {
                
                DataManager.shared.getProfile(email: currentUser.accountType == .charity ? post.post.by : post.email, accountType: currentUser.accountType == .charity ? .donor : .charity) { success, result in
                    
                    guard let result = result, success else {
                        self.showAlert("Error fetching donor's profile. Please try again later.")
                        return
                    }
                    
                    self.profile = result
                    
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        self.dismiss()
                    }
                }
            }
            .alert(isPresented: $alertPresented) {
                Alert(title: Text(self.alertMessage))
            }
            .confirmationDialog("", isPresented: $showActionSheet) {
                
                if let profile = profile {
                    Button("Phone") {
                        if UIApplication.shared.canOpenURL(URL(string: "tel://+91\(profile.phone)")!) {
                            UIApplication.shared.open(URL(string: "tel://+91\(profile.phone)")!)
                        }
                    }
                    
                    Button("Mail") {
                        if UIApplication.shared.canOpenURL(URL(string: "mailto:\(profile.email)")!) {
                            UIApplication.shared.open(URL(string: "mailto:\(profile.email)")!)
                        }
                    }
                }
            }
        }
        
    }
    
    private func showAlert(_ message: String) {
        self.alertMessage = message
        self.alertPresented = true
    }
    
}
