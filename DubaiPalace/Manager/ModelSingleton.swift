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
    public private(set) var authorization: String = ""



    public func setRequestUrl(_ url: String) {
        self.requestUrl = url
    }
    
    public func setGameList(_ gameList: [GameList]) {
        self.gameList = gameList
    }
    
    public func setAuthorization(_ token: String) {
        self.authorization = token
    }

}
