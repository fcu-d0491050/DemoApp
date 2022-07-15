//
//  APIResult.swift
//  DubaiPalace
//
//  Created by user on 2022/7/14.
//

public struct Result<T> {
    var data: T
    var apiResult: HeaderResult
}

public struct HeaderResult {
    var status: String
    var description: String
}
