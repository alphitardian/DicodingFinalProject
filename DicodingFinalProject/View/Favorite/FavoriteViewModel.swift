//
//  FavoriteViewModel.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 16/10/22.
//

import Foundation

class FavoriteViewModel: ObservableObject {
    
    @Published var favorites = [Detail]()
    
    private let localService = LocalService()
    
    @MainActor
    func getAllFavorite() async {
        favorites = await localService.getAllFavorite()
    }
}
