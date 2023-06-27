//
//  ResponseModel.swift
//  NetworkKit_Example
//
//  Created by Nileshkumar M. Prajapati on 2023/06/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ResponseModel: Decodable {
    let hasMore: HasMore
    let tracks: [Track]?
}

// MARK: - HasMore
struct HasMore: Decodable {
    let skip: Int
}

// MARK: - Track
struct Track: Decodable, Identifiable, Hashable {
    static func == (lhs: Track, rhs: Track) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    let id, uID, uNm, text: String?
    let pl: Pl?
    let name, eID: String?
    let img: String?
    let nbP: Int?
    let lov: [String]?
    let nbR, score, nbL: Int?
    let prev: Int?
    let trackID: String?
    let rankIncr: Int?
    var ctx: Ctx?
    let src: Src?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case uID = "uId"
        case uNm, text, pl, name
        case eID = "eId"
        case img, nbP, lov, nbR, score, nbL, prev
        case trackID = "trackId"
        case rankIncr, ctx, src, order
    }
}

enum Ctx: String, Decodable {
    case bk = "bk"
}

// MARK: - Pl
struct Pl: Decodable {
    let name: String?
    let id: Int?
}

// MARK: - Src
struct Src: Decodable {
    let id: String?
    let name: String?
}
