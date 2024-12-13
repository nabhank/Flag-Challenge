//
//  QuestionsModel.swift
//  Flags Challenge Demo
//
//  Created by Nabhan K on 12/12/24.
//

import Foundation

struct QuestionResponse: Codable {
    let questions: [Question]
}

struct Question: Codable, Identifiable {
    let id: Int
    let countries: [Country]
    let countryCode: String
    
    var isShown: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "answer_id"
        case countries
        case countryCode = "country_code"
    }
}

struct Country: Codable, Identifiable {
    let id: Int
    let countryName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case countryName = "country_name"
    }
}

