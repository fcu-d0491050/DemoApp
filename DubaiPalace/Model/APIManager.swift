//
//  APIManager.swift
//  DubaiPalace
//
//  Created by user on 2022/7/12.
//

import Alamofire
import RxAlamofire
import SwiftyJSON
import RxSwift

class APIManager {
    
    static let shared = APIManager()
    
    static func loadAPI(httpMethod: HTTPMethod, urlString: String, headers: [String:String] = [:], body: [String:Any]?) -> Observable<JSON> {
        
        let _request = request(httpMethod, urlString, parameters: body, encoding: URLEncoding.default)
        return _request.responseData().map { (response, data) in
            do {
                let jsonObj = try JSON(data: data)
                return jsonObj
            }
            catch let Error {
                print("Error: \(Error)")
                throw Error
            }
        }
    }
    
}

extension APIManager {
    
    func postApiConfig() -> Observable<JSON> {
        let body = ["app_version": "9.9.99",
                    "OS": 1,
                    "App": "ndbpp",
                    "IsDev" : 1] as [String : Any]
        return APIManager.loadAPI(httpMethod: .post, urlString: APIInfo.AppConfig, body: body)
    }
    
    func sendLog(content: ContentData) -> Observable<JSON> {
        var _jsonString = ""
        let dic = ["useful": ["cpu_used" : content.mobileInfo.cpuUsed,
                              "mem_free" : content.mobileInfo.memFree,
                              "device_name" : content.mobileInfo.deviceName,
                              "access" : content.mobileInfo.access,
                              "useful_space" : content.mobileInfo.usefulSpace,
                              "nt_operator_name" : content.mobileInfo.operatorName,
                              "mem_used" : content.mobileInfo.memUsed],
                   "datas": ["user_agent" : content.appInfo.userAgent,
                             "phone_start_time" : content.appInfo.phoneStartTime,
                             "status" : content.appInfo.stauts,
                             "appapp" : content.appInfo.appKey,
                             "log_id" : content.appInfo.logID,
                             "device_id" : content.appInfo.deviceID,
                             "response" : content.appInfo.response,
                             "sess_id" : content.appInfo.sessID,
                             "request_url" : content.appInfo.requestUrl,
                             "phone_end_time" : content.appInfo.phoneEndTime
                            ]]
        
        if let jsonData = try? JSONEncoder().encode(dic) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                _jsonString = jsonString
            }
        }
        let body = ["crlMode": "app_log",
                    "content": _jsonString] as [String : Any]
        return APIManager.loadAPI(httpMethod: .post, urlString: APIInfo.SendLog, body: body)
        
    }
    
    func checkLink() -> Observable<JSON> {
        return APIManager.loadAPI(httpMethod: .get, urlString: ModelSingleton.shared.requestUrl + "check_link", body: [:])
    }
    
    func ipVerify(ip: String) -> Observable<JSON> {
        let headers = [
            "Lang": "zh_CN"]
        let body = ["ip": ip] as [String : Any]
        return APIManager.loadAPI(httpMethod: .post, urlString: ModelSingleton.shared.requestUrl + APIInfo.ipVerify, headers: headers, body: body)
    }
    
    func getGameList() -> Observable<JSON> {
        let headers = [
            "Lang": "zh_CN"]
        let body = ["site_id" : 1,
                    "currency" : "RMB",
                    "suppory_device" : 2,
                    "template": "H5_1_mobile"] as [String : Any]
        return APIManager.loadAPI(httpMethod: .post, urlString: ModelSingleton.shared.requestUrl + APIInfo.gameListV3, headers: headers, body: body)
    }
}
