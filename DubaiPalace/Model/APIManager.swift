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
    
    static func loadAPI(httpMethod: HTTPMethod, urlString: String, body: [String:Any]?) -> Observable<JSON> {
        
        let _request = request(httpMethod, urlString, parameters: body)
        
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
        return APIManager.loadAPI(httpMethod: .post, urlString: "http://appctl.bckappts.info/mob_controller/judgeUpdate.php", body: body)
    }
}
