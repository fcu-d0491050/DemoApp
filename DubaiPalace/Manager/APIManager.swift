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
    
    static func loadAPI(httpMethod: HTTPMethod, urlString: String, headers: HTTPHeaders = [:], body: [String:Any]?, isJsonBody: Bool = false, getAuthorization: Bool = false) -> Observable<JSON> {
        
        if isJsonBody {
            var request = URLRequest(url: URL(string: urlString)!)
            request.httpMethod = httpMethod.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.headers = headers
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: body ?? [:], options: .prettyPrinted) {
                request.httpBody = jsonData
            }
            
            return RxAlamofire.request(request).responseData().map { (response, data) in
                do {
                    if getAuthorization {
                        ModelSingleton.shared.setAuthorization(response.allHeaderFields["Authorization"] as? String ?? "")
                    }
                    let jsonObj = try JSON(data: data)
                    return jsonObj
                }
                catch let Error {
                    print("Error: \(Error)")
                    throw Error
                }
            }
        } else {
            let _request = request(httpMethod, urlString, parameters: body, encoding: URLEncoding.default, headers: headers)
            return _request.responseData().map { (response, data) in
                do {
                    //                    print(response.allHeaderFields)
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
        let dic = ["useful": ["cpu_used" : content.mobileInfo?.cpuUsed,
                              "mem_free" : content.mobileInfo?.memFree,
                              "device_name" : content.mobileInfo?.deviceName,
                              "access" : content.mobileInfo?.access,
                              "useful_space" : content.mobileInfo?.usefulSpace,
                              "nt_operator_name" : content.mobileInfo?.operatorName,
                              "mem_used" : content.mobileInfo?.memUsed],
                   "datas": ["user_agent" : content.appInfo?.userAgent,
                             "phone_start_time" : content.appInfo?.phoneStartTime,
                             "status" : content.appInfo?.stauts,
                             "appapp" : content.appInfo?.appKey,
                             "log_id" : content.appInfo?.logID,
                             "device_id" : content.appInfo?.deviceID,
                             "response" : content.appInfo?.response,
                             "sess_id" : content.appInfo?.sessID,
                             "request_url" : content.appInfo?.requestUrl,
                             "phone_end_time" : content.appInfo?.phoneEndTime
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
            "Lang": "zh_CN"] as HTTPHeaders
        let body = ["ip": ip] as [String : Any]
        return APIManager.loadAPI(httpMethod: .post, urlString: ModelSingleton.shared.requestUrl + APIInfo.ipVerify, headers: headers, body: body)
    }
    
    func getGameList() -> Observable<JSON> {
        var headers = [:] as HTTPHeaders
        if ModelSingleton.shared.authorization == "" {
            headers = [
                "Lang": "zh_CN"]
        } else {
            headers = [
                "Lang": "zh_CN",
                "Authorization": ModelSingleton.shared.authorization]
            
        }
        let body = ["site_id" : 1,
                    "currency" : "RMB",
                    "support_device" : 2,
                    "template": "H5_1_mobile"] as [String : Any]
        return APIManager.loadAPI(httpMethod: .post, urlString: ModelSingleton.shared.requestUrl + APIInfo.gameListV3, headers: headers, body: body, isJsonBody: true)
        
    }
    
    func accountLogin(account: String, password: String, timeStamp: Int) -> Observable<JSON> {
        let clearString = """
                {"api_key":"\(AppKey.ApiKey)","timestamp":\(timeStamp)}
                """
        let sign = clearString.hmac(algorithm: HMACAlgorithm.SHA256, key: AppKey.SecretKey)
        let headers = ["Lang" : "zh_CN",
                       "API-KEY" : AppKey.ApiKey,
                       "SIGN" : sign,
                       "TIMESTAMP" : "\(timeStamp)"] as HTTPHeaders
        let body = ["account": account,
                    "password": password,
                    "site_id": 1,
                    "device": 3,
                    "login_type": 3,
                    "system": "iOS",
                    "system_version": UIDevice.current.systemVersion,
                    "app_version": "1.8.63",
                    "host": ModelSingleton.shared.requestUrl,
                    "udid": UUID().uuidString,
                    "system_group": 1]  as [String : Any]
        return APIManager.loadAPI(httpMethod: .post, urlString: ModelSingleton.shared.requestUrl + APIInfo.login, headers: headers, body: body, isJsonBody: true, getAuthorization: true)
    }
    
}
