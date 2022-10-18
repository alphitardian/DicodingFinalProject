//
//  ProfileView.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 11/10/22.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isEditProfile = false
    @State private var userImage = UIImage()
    @State private var userName = ""
    @State private var userProfession = ""
    @State private var userState = false
    
    private func refreshProfile() {
        viewModel.synchronize()
        userName = viewModel.getUserName()
        userProfession = viewModel.getUserProfession()
        userImage = viewModel.getUserImage()
        userState = viewModel.getUserState()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("MainColor").ignoresSafeArea()
                VStack {
                    if userState {
                        Image(uiImage: userImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .padding(.bottom)
                        Text(userName)
                            .bold()
                            .font(.title2)
                            .padding(.bottom, 2)
                        Text(userProfession)
                    } else {
                        Text("Please input your profile")
                    }
                }
                .navigationTitle("Profile")
                .foregroundColor(.white)
                .toolbar {
                    Button {
                        isEditProfile = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
                .sheet(isPresented: $isEditProfile) {
                    refreshProfile()
                } content: {
                    EditProfileView(viewModel: viewModel) {
                        self.isEditProfile = false
                        refreshProfile()
                    }
                }
                .onAppear {
                    refreshProfile()
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
