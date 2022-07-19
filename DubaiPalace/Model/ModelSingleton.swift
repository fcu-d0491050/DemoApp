//
//  ModelSingleton.swift
//  DubaiPalace
//
//  Created by user on 2022/7/14.
//

import Foundation

public class ModelSingleton: NSObject {
    
    public static let shared: ModelSingleton = ModelSingleton()
    public private(set) var requestUrl: String = ""
    public private(set) var gameList: [GameList] = []



    public func setRequestUrl(_ url: String) {
        self.requestUrl = url
    }
    
    public func setGameList(_ gameList: [GameList]) {
        self.gameList = gameList
    }

}
