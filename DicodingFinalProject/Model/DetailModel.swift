//
//  DetailModel.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 11/10/22.
//

import UIKit

struct DetailResponse: ApiResponse {
    let id: Int
    let name: String
    let slug: String
    let gamesCount: Int
    let backgroundImage: URL?
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case gamesCount = "games_count"
        case backgroundImage = "image_background"
        case description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.slug = try container.decode(String.self, forKey: .slug)
        self.gamesCount = try container.decode(Int.self, forKey: .gamesCount)
        self.description = try container.decode(String.self, forKey: .description)
        
        let imagePath = try container.decodeIfPresent(String.self, forKey: .backgroundImage)
        self.backgroundImage = URL(string: imagePath ?? "")
    }
}

struct Detail: Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
    let backgroundImage: URL?
    let gamesCount: Int
    let rating: Double
    let releasedDate: String?
    
    init(
        id: Int,
        name: String,
        description: String,
        backgroundImage: URL?,
        gamesCount: Int,
        rating: Double,
        releasedDate: String?
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.backgroundImage = backgroundImage
        self.gamesCount = gamesCount
        self.rating = rating
        self.releasedDate = releasedDate
    }
}

extension DetailResponse {
    func toDetail() -> Detail {
        return Detail(
            id: self.id,
            name: self.name,
            description: self.description,
            backgroundImage: self.backgroundImage,
            gamesCount: self.gamesCount,
            rating: 0.0,
            releasedDate: ""
        )
    }
}

extension Detail {
    func toGame() -> Game {
        return Game(
            id: self.id,
            name: self.name,
            description: self.description,
            backgroundImage: self.backgroundImage,
            releaseDate: self.releasedDate ?? "",
            rating: self.rating
        )
    }
}
