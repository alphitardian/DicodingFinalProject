//
//  EditProfileView.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 14/10/22.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedImage: UIImage?
    @State private var nameTextField = ""
    @State private var professionTextField = ""
    
    var onButtonTap: () -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("MainColor").ignoresSafeArea()
                VStack {
                    ZStack(alignment: .bottomTrailing) {
                        Image(uiImage: selectedImage ?? UIImage())
                            .resizable()
                            .frame(width: 128, height: 128)
                            .background { Color.gray }
                            .cornerRadius(20)
                        PhotosPicker(
                            selection: $selectedItems,
                            maxSelectionCount: 1,
                            matching: .images
                        ) {
                            Text("+")
                                .bold()
                                .font(.largeTitle)
                                .background {
                                    Rectangle()
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(20)
                                        .foregroundColor(.white)
                                        .shadow(radius: 4)
                                }
                        }
                        .offset(x: 10, y: 10)
                    }
                    .padding(.vertical)
                    TextField("Enter your name", text: $nameTextField)
                        .textFieldStyle(.roundedBorder)
                        .padding([.horizontal, .top])
                    TextField("Enter your profession", text: $professionTextField)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    Spacer()
                    Button {
                        viewModel.saveProfile(
                            name: nameTextField,
                            profession: professionTextField,
                            image: selectedImage ?? UIImage()
                        )
                        viewModel.setUserState(true)
                        onButtonTap()
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity, maxHeight: 36)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)

                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar  {
                Button {
                    onButtonTap()
                } label: {
                    Text("Close").bold()
                }
            }
            .onChange(of: selectedItems) { newValue in
                guard let item = selectedItems.first else { return }
                item.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data):
                        if let data = data {
                            self.selectedImage = UIImage(data: data)
                        } else {
                            print("Data is nil")
                        }
                    case .failure(let failure):
                        fatalError("\(failure)")
                    }
                }
            }
            .onAppear {
                nameTextField = viewModel.getUserName()
                professionTextField = viewModel.getUserProfession()
                selectedImage = viewModel.getUserImage()
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static let viewModel = ProfileViewModel()
    static var previews: some View {
        EditProfileView(viewModel: viewModel) {
            
        }
    }
}
