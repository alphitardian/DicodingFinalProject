//
//  BrowseViewModel.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 11/10/22.
//

import Foundation

class BrowseViewModel: ObservableObject {

    @Published var games: [Game] = []
    @Published var generals: [General] = []
    @Published var searchedGames: [Game] = []
    @Published var searchedGenerals: [General] = []
    @Published var selectedItem: General?
    @Published var selectedFilter: GameFilter = .games
    @Published var searchText = ""
    
    private let networkService = NetworkService()
    
    @MainActor
    func getDataList(by filter: GameFilter) async {
        do {
            switch filter {
            case .games:
                self.games = try await networkService.getGameList()
            case .developers:
                self.generals = try await networkService.getGeneralList(filter: .developers)
            case .genres:
                self.generals = try await networkService.getGeneralList(filter: .genres)
            case .publishers:
                self.generals = try await networkService.getGeneralList(filter: .publishers)
            }
        } catch {
            print(error)
        }
    }
    
    func setSelectedFilter(filter: GameFilter) {
        selectedFilter = filter
    }
    
    @MainActor
    func getSearchedDataList(selectedFilter: GameFilter, searchText: String) async {
        do {
            switch selectedFilter {
            case .games:
                let searchedList: [GameDetailResponse] = try await networkService.getSearchData(
                    searchText: searchText,
                    filter: selectedFilter
                )
                searchedGames = searchedList.map { response in
                    response.toGame()
                }
            default:
                let searchedList: [GeneralResponse] = try await networkService.getSearchData(
                    searchText: searchText,
                    filter: selectedFilter
                )
                searchedGenerals = searchedList.map { response in
                    response.toGeneral()
                }
            }
        } catch {
            print(error)
        }
    }
    
    func setSelectedItem(model: General) {
        selectedItem = model
    }
}
