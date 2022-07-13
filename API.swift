//
//  AppConfig.swift
//  DubaiPalace
//
//  Created by user on 2022/7/12.
//

import Foundation

enum APIInfo: String {
    case AppConfig = "http://appctl.bckappts.info/mob_controller/judgeUpdate.php"
    case SendLog = "http://appctl.bckappts.info/app_log/apl_insertweilog.php"
}

public struct AppConfig {
    var feedback : Int
    var logID : String
    var sessID : String
    var domainUrl : String
    var appUpdateUrl : String
    var appKeyCode : String
    var webUrl : String
    var isDev : Bool
    var checkLink : String
}

