//
//  DetailViewModel.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 12/10/22.
//

import Foundation

class DetailViewModel: ObservableObject {
    
    private let networkService = NetworkService()
    private let localService = LocalService()
    
    @Published var selectedItem: Detail?
    
    func setSelectedGame(gameDetail: Detail?) {
        selectedItem = gameDetail
    }
    
    func getDetail(id: Int, selectedFilter: GameFilter) async -> Detail? {
        do {
            switch selectedFilter {
            case .games:
                let selected: GameDetailResponse = try await networkService.getDetail(
                    id: id,
                    selectedFilter: selectedFilter
                )
                return selected.toDetail()
            default:
                let selected: DetailResponse = try await networkService.getDetail(
                    id: id,
                    selectedFilter: selectedFilter
                )
                return selected.toDetail()
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    func getFavoriteDetail(id: Int) async -> Detail? {
        return await localService.getFavorite(id: id)
    }
    
    func addToFavorite(game: Detail, completion: @escaping () -> Void) {
        localService.addFavorite(
            game.id,
            game.name,
            game.description,
            game.backgroundImage!,
            game.releasedDate ?? "",
            game.rating,
            game.gamesCount,
            completion: completion
        )
    }
    
    func removeFromFavorite(game: Detail, completion: @escaping () -> Void) {
        localService.deleteFavorite(id: game.id, completion: completion)
    }
    
}
