//
//  ApiResponse.swift
//  DicodingFinalProject
//
//  Created by Ardian Pramudya Alphita on 11/10/22.
//

import Foundation

protocol ApiResponse: Codable {}

struct BaseResponses<T: ApiResponse>: Codable {
    let count: Int
    let nextUrl: String?
    let previousUrl: String?
    let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case count
        case nextUrl = "next"
        case previousUrl = "previous"
        case results
    }
}
