//
//  DetailView.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 11/10/22.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject private var viewModel = DetailViewModel()
    @State private var isLoading = true
    @State private var isFavorite = false
    
    private var itemId: Int?
    private var gameFilter: GameFilter
    private var topGames: [Int]
    
    init(itemId: Int, gameFilter: GameFilter, topGames: [Int] = []) {
        self.itemId = itemId
        self.gameFilter = gameFilter
        self.topGames = topGames
    }
    
    var body: some View {
        ZStack {
            Color("MainColor").ignoresSafeArea()
            ScrollView {
                switch gameFilter {
                case .games:
                    if isLoading {
                        ProgressView().tint(.white)
                    } else {
                        GameDetailView(selectedGame: viewModel.selectedItem)
                            .toolbar {
                                Button {
                                    if isFavorite {
                                        if let item = viewModel.selectedItem {
                                            viewModel.removeFromFavorite(game: item) {
                                                print("Delete success")
                                            }
                                        }
                                    } else {
                                        if let item = viewModel.selectedItem {
                                            viewModel.addToFavorite(game: item) {
                                                print("Add success")
                                            }
                                        }
                                    }
                                    isFavorite.toggle()
                                } label: {
                                    if isFavorite {
                                        Image(systemName: "star.fill")
                                    } else {
                                        Image(systemName: "star")
                                    }
                                }
                            }
                    }
                default:
                    if isLoading {
                        ProgressView().tint(.white)
                    } else {
                        GeneralDetailView(
                            viewModel: viewModel,
                            selectedItem: viewModel.selectedItem,
                            topGames: topGames
                        )
                    }
                }
            }
        }
        .foregroundColor(.white)
        .onAppear {
            Task {
                let detail = await viewModel.getFavoriteDetail(id: itemId ?? 0)
                viewModel.setSelectedGame(gameDetail: detail)
                isFavorite = detail != nil
                
                if !isFavorite {
                    viewModel.setSelectedGame(
                        gameDetail: await viewModel.getDetail(
                            id: itemId ?? 0,
                            selectedFilter: gameFilter
                        )
                    )
                }
                isLoading = false
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(itemId: 305, gameFilter: .games)
    }
}
