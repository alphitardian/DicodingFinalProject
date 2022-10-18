//
//  GameModel.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 11/10/22.
//

import UIKit

struct GameResponse: ApiResponse {
    let id: Int
    let slug: String
    let name: String
    let released: String?
    let toBeAnnounced: Bool?
    let backgroundImage: URL
    let rating: Double?
    let topRating: Int?
    let ratingCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case name
        case released
        case toBeAnnounced = "tba"
        case backgroundImage = "background_image"
        case rating
        case topRating = "rating_top"
        case ratingCount = "ratings_count"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.slug = try container.decode(String.self, forKey: .slug)
        self.name = try container.decode(String.self, forKey: .name)
        self.released = try container.decode(String.self, forKey: .released)
        self.toBeAnnounced = try container.decodeIfPresent(Bool.self, forKey: .toBeAnnounced)
        
        let imagePath = try container.decode(String.self, forKey: .backgroundImage)
        self.backgroundImage = URL(string: imagePath)!
        
        self.rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        self.topRating = try container.decodeIfPresent(Int.self, forKey: .topRating)
        self.ratingCount = try container.decodeIfPresent(Int.self, forKey: .ratingCount)
    }
}

struct GameDetailResponse: ApiResponse {
    let id: Int
    let slug: String
    let name: String
    let description: String?
    let released: String?
    let toBeAnnounced: Bool?
    let backgroundImage: URL?
    let rating: Double?
    let topRating: Int?
    let ratingCount: Int?
    let metacritic: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case name
        case description
        case released
        case toBeAnnounced = "tba"
        case backgroundImage = "background_image"
        case rating
        case topRating = "rating_top"
        case ratingCount = "ratings_count"
        case metacritic
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.slug = try container.decode(String.self, forKey: .slug)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.released = try container.decodeIfPresent(String.self, forKey: .released)
        self.toBeAnnounced = try container.decodeIfPresent(Bool.self, forKey: .toBeAnnounced)
        
        let imagePath = try container.decodeIfPresent(String.self, forKey: .backgroundImage)
        self.backgroundImage = URL(string: imagePath ?? "https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png")
        
        self.rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        self.topRating = try container.decodeIfPresent(Int.self, forKey: .topRating)
        self.ratingCount = try container.decodeIfPresent(Int.self, forKey: .ratingCount)
        self.metacritic = try container.decodeIfPresent(Int.self, forKey: .metacritic)
    }
}

struct Game: Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
    let backgroundImage: URL?
    let releaseDate: String
    let rating: Double
    
    init(
        id: Int,
        name: String,
        description: String = "",
        backgroundImage: URL?,
        releaseDate: String,
        rating: Double = 0.0
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.backgroundImage = backgroundImage
        self.releaseDate = releaseDate
        self.rating = rating
    }
}

extension GameResponse {
    func toGame() -> Game {
        return Game(
            id: self.id,
            name: self.name,
            backgroundImage: self.backgroundImage,
            releaseDate: self.released ?? "",
            rating: self.rating ?? 0.0
        )
    }
}

extension GameDetailResponse {
    func toGame() -> Game {
        return Game(
            id: self.id,
            name: self.name,
            description: self.description ?? "",
            backgroundImage: self.backgroundImage,
            releaseDate: self.released ?? "",
            rating: self.rating ?? 0.0
        )
    }
    
    func toDetail() -> Detail {
        return Detail(
            id: self.id,
            name: self.name,
            description: self.description ?? "",
            backgroundImage: self.backgroundImage,
            gamesCount: 0,
            rating: self.rating ?? 0.0,
            releasedDate: self.released
        )
    }
}
