//
//  BrowseView.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 11/10/22.
//

import SwiftUI

struct BrowseView: View {
    
    @StateObject private var viewModel = BrowseViewModel()
    
    @State private var isLoading = true
    @State private var isFilterOpen = false
    
    private var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    private var filteredGames: [Game] {
        if viewModel.searchText.isEmpty {
            return viewModel.games
        } else {
            return viewModel.searchedGames
        }
    }
    private var filteredGenerals: [General] {
        if viewModel.searchText.isEmpty {
            return viewModel.generals
        } else {
            return viewModel.searchedGenerals
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("MainColor").ignoresSafeArea()
                ScrollView {
                    LazyVGrid(columns: twoColumnGrid) {
                        if isLoading {
                            ProgressView().tint(.white)
                        } else {
                            switch viewModel.selectedFilter {
                            case .games:
                                ForEach(filteredGames) { item in
                                    NavigationLink(value: item) {
                                        BrowseGridView(
                                            game: item,
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
                            default:
                                ForEach(filteredGenerals) { item in
                                    NavigationLink(value: item) {
                                        BrowseGridView(
                                            game: nil,
                                            general: item,
                                            state: .genres
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
                    }
                    .navigationDestination(for: Game.self) { game in
                        DetailView(
                            itemId: game.id,
                            gameFilter: viewModel.selectedFilter
                        )
                        .navigationTitle("Detail")
                    }
                    .navigationDestination(for: General.self) { general in
                        if general.topGames == [] {
                            DetailView(
                                itemId: general.id,
                                gameFilter: viewModel.selectedFilter,
                                topGames: general.games.map { response in
                                    response.id
                                }
                            )
                            .navigationTitle("Detail")
                        } else {
                            DetailView(
                                itemId: general.id,
                                gameFilter: viewModel.selectedFilter,
                                topGames: general.topGames ?? []
                            )
                            .navigationTitle("Detail")
                        }
                    }
                }
                .navigationTitle("Browse")
                .searchable(text: $viewModel.searchText)
                .toolbar {
                    Button {
                        isFilterOpen.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
                .sheet(isPresented: $isFilterOpen) {
                    CategoryView(
                        data: GameFilter.allCases,
                        selectedFilter: viewModel.selectedFilter
                    ) { filter in
                        viewModel.setSelectedFilter(filter: filter)
                        isFilterOpen.toggle()
                    }
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                }
                .onReceive(
                    viewModel.$searchText.debounce(
                        for: 1,
                        scheduler: RunLoop.main
                    )
                ) { output in
                    Task {
                        isLoading = true
                        await viewModel.getSearchedDataList(
                            selectedFilter: viewModel.selectedFilter,
                            searchText: viewModel.searchText
                        )
                        isLoading = false
                    }
                }
                .onChange(of: viewModel.selectedFilter) { newValue in
                    Task {
                        isLoading = true
                        await viewModel.getDataList(by: viewModel.selectedFilter)
                        isLoading = false
                    }
                }
                .onAppear {
                    Task {
                        isLoading = true
                        await viewModel.getDataList(by: viewModel.selectedFilter)
                        isLoading = false
                    }
                }
            }
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
