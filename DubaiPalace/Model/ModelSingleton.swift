//
//  ModelSingleton.swift
//  DubaiPalace
//
//  Created by user on 2022/7/14.
//

import Foundation

public class ModelSingleton: NSObject {
    public private(set) var requestUrl: String = ""
    public static let shared: ModelSingleton = ModelSingleton()

    public func setRequestUrl(_ url: String) {
        self.requestUrl = url
    }

}
