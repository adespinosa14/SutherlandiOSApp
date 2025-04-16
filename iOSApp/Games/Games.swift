//
//  Games.swift
//  iOSApp
//
//  Created by Andrew Espinosa on 1/15/25.
//

import Foundation

struct GameResponse: Codable {
    let game: GameInfo
    let groups: [Group]
}

struct GameInfo: Codable {
    let id: String
    let name: String
}

struct Member: Codable {
    let id: String
    let name: String
    let sound_id: String
}

struct Group: Codable {
    let group_id: String
    let group_name: String
    let members: [Member]
}

struct Games: Codable {
    let id: String
    let name: String
    let groups: [Group]?
}

struct Programs: Codable{
    let id: String
    let name: String
    let state: Bool
    let games: [Games]
}
