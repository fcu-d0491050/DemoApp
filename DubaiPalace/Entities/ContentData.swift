//
//  ContentData.swift
//  DubaiPalace
//
//  Created by user on 2022/7/13.
//

public struct ContentData {
    var mobileInfo: MobileInfo?
    var appInfo: AppInfo?
    
}

public struct MobileInfo {
    var cpuUsed: String
    var memFree: String
    var deviceName: String
    var access: String
    var usefulSpace: String
    var operatorName: String
    var memUsed: String
}

public struct AppInfo {
    var userAgent: String
    var phoneStartTime: String
    var stauts: String
    var appKey: String
    var logID: String
    var deviceID: String
    var response: String
    var sessID: String
    var requestUrl: String
    var phoneEndTime: String
}
