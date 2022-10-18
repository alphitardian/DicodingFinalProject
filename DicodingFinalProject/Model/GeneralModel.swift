//
//  GeneralModel.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 11/10/22.
//

import UIKit

struct GeneralResponse: ApiResponse {
    let id: Int
    let name: String
    let slug: String
    let gamesCount: Int
    let backgroundImage: URL?
    let games: [GeneralGameResponse]?
    let topGames: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case gamesCount = "games_count"
        case backgroundImage = "image_background"
        case games
        case topGames = "top_games"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.slug = try container.decode(String.self, forKey: .slug)
        self.gamesCount = try container.decode(Int.self, forKey: .gamesCount)
        self.games = try container.decodeIfPresent([GeneralGameResponse].self, forKey: .games)
        self.topGames = try container.decodeIfPresent([Int].self, forKey: .topGames)
        
        let imagePath = try container.decodeIfPresent(String.self, forKey: .backgroundImage)
        self.backgroundImage = URL(string: imagePath ?? "https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png")
    }
}

struct GeneralGameResponse: ApiResponse, Hashable {
    let id: Int
    let slug: String
    let name: String
}

struct General: Identifiable, Hashable {
    let id: Int
    let name: String
    let backgroundImage: URL?
    let gamesCount: Int
    var games: [GeneralGameResponse]
    var topGames: [Int]?
    
    var image: UIImage?
    
    init(
        id: Int,
        name: String,
        backgroundImage: URL?,
        gamesCount: Int,
        games: [GeneralGameResponse] = [],
        topGames: [Int] = []
    ) {
        self.id = id
        self.name = name
        self.backgroundImage = backgroundImage
        self.gamesCount = gamesCount
        self.games = games
        self.topGames = topGames
    }
}

extension GeneralResponse {
    func toGeneral() -> General {
        return General(
            id: self.id,
            name: self.name,
            backgroundImage: self.backgroundImage,
            gamesCount: self.gamesCount,
            games: self.games ?? [],
            topGames: self.topGames ?? []
        )
    }
}
