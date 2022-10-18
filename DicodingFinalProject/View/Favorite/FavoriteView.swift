//
//  FavoriteView.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 13/10/22.
//

import SwiftUI

struct FavoriteView: View {
    
    @StateObject private var viewModel = FavoriteViewModel()
    
    private var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("MainColor").ignoresSafeArea()
                if viewModel.favorites.isEmpty {
                    VStack {
                        Text("No favorite added yet.")
                    }
                    .navigationTitle("Favorite")
                } else {
                    ScrollView {
                        LazyVGrid(columns: twoColumnGrid) {
                            ForEach(viewModel.favorites) { item in
                                NavigationLink(value: item) {
                                    BrowseGridView(
                                        game: item.toGame(),
                                        general: nil,
                                        state: .games
                                    )
                                }
                                .foregroundColor(.black)
                                .frame(
                                    width: UIScreen.main.bounds.width / 2 - 18,
                                    height: UIScreen.main.bounds.height / 3 - 32
                                )
                            }
                        }
                    }
                    .navigationDestination(for: Detail.self) { favorite in
                        DetailView(itemId: favorite.id, gameFilter: .games)
                            .navigationTitle("Detail")
                    }
                    .navigationTitle("Favorite")
                }
            }
        }
        .task {
            await viewModel.getAllFavorite()
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
