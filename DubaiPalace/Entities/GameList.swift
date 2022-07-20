//
//  GameList.swift
//  DubaiPalace
//
//  Created by user on 2022/7/15.
//

public struct GameList {
    var gtID: Int
    var gtName: String
    var gtShortName: String
    var gtIcon: String
    var gtActiveIcon: String
    var gpList: [gp]?
}

public struct gp {
    var gpID: String
    var gtID: Int
    var house: String
    var gameType: String
    var gameCode: String
    var gameName: String
    var gtSort: Int
    var gpName: String
    var gpGtName: String
    var gpGtSort: Int
    var banner: String
    var customized: Int
    var iconLight: String
    var iconDark: String
}
