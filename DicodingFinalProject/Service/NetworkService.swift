//
//  NetworkService.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 11/10/22.
//

import Foundation

class NetworkService {
    
    private let baseUrl = "https://api.rawg.io/api"
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "TMDB-Info", ofType: "plist") else {
                fatalError("Couldn't find file 'TMDB-Info.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find key 'API_KEY'")
            }
            return value
        }
    }
    
    func getGameList() async throws -> [Game] {
        var components = URLComponents(string: "\(baseUrl)/games")!
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        let request = URLRequest(url: components.url!)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data.")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(BaseResponses<GameResponse>.self, from: data)
        
        return result.results.map { gameResponse in
            gameResponse.toGame()
        }
    }
    
    func getGeneralList(filter: GameFilter) async throws -> [General] {
        var components = URLComponents(string: "\(baseUrl)/\(filter)")!
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        let request = URLRequest(url: components.url!)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data.")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(BaseResponses<GeneralResponse>.self, from: data)
        
        return result.results.map { generalResponse in
            generalResponse.toGeneral()
        }
    }
    
    func getDetail<T: ApiResponse>(id: Int, selectedFilter: GameFilter) async throws -> T {
        var components = URLComponents(string: "\(baseUrl)/\(selectedFilter)/\(id)")!
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        let request = URLRequest(url: components.url!)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data.")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(T.self, from: data)
        
        return result
    }
    
    func getSearchData<T: ApiResponse>(searchText: String, filter: GameFilter) async throws -> [T] {
        var components = URLComponents(string: "\(baseUrl)/\(filter)")!
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "search", value: searchText)
        ]
        
        let request = URLRequest(url: components.url!)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data.")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(BaseResponses<T>.self, from: data)
        
        return result.results
    }
    
}
