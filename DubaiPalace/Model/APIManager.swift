//
//  APIManager.swift
//  DubaiPalace
//
//  Created by user on 2022/7/12.
//

import Alamofire
import SwiftyJSON

class APIManager {
    
    static let shared = APIManager()
//    static func loadAPI(httpMethod: HTTPMethod, urlString: String, body: [String:Any]?) {
//        
//        AF.request(urlString, method: httpMethod, parameters: body).responseJSON { (response) in
//          print(response)
//        }
//        
//    }
    
    static func postApiConfig() {
        
        let body = ["app_version": "9.9.99",
                    "OS": 1,
                    "App": "ndbpp",
                    "IsDev" : 1] as [String : Any]
        
        AF.request("http://appctl.bckappts.info/mob_controller/judgeUpdate.php", method: .post, parameters: body).responseJSON { (response) in
            
            guard let data = response.data else { return }
            
            do {
                let json = try JSON(data: data)
                let result = AppConfig(feedback: json["feedback"].intValue,
                                       logID: json["log_id"].stringValue,
                                       sessID: json["sess_id"].stringValue,
                                       domainUrl: json["domain_url"].stringValue,
                                       appUpdateUrl: json["appUpDate_url"].stringValue,
                                       appKeyCode: json["app"].stringValue,
                                       webUrl: json["web_url"].stringValue,
                                       isDev: json["isDev"].stringValue == "0" ? false : true,
                                       checkLink: json["check_link"].stringValue)
                
            print(result)
            }
            catch let Error {
                print("Error: \(Error)")
            }

        }
        
    }
}
