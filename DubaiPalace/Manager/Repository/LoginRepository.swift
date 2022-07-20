//
//  LoginRepository.swift
//  DubaiPalace
//
//  Created by user on 2022/7/13.
//

import RxSwift
import Network
import UIKit

public protocol LoginRepositoryInterface {
    func postAppConfig() -> Observable<AppConfig>
    func sendLog(content: ContentData) -> Observable<LogDetail>
    func checkLink() -> Observable<Result<Bool>>
    func ipVerify(_ ip : String) -> Observable<Result<Bool>>
    func getGameList() -> Observable<Result<[GameList]>>
}

public class LoginRepository {
    public static let shared = LoginRepository()
    private let disposeBag = DisposeBag()
    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
}

extension LoginRepository: LoginRepositoryInterface {
    
    public func postAppConfig() -> Observable<AppConfig> {
        let subject = PublishSubject<AppConfig>()
        apiManager.postApiConfig()
            .subscribe(onNext: { apiResult in
                let result = AppConfig(feedback: apiResult["feedback"].intValue,
                                       logID: apiResult["log_id"].stringValue,
                                       sessID: apiResult["sess_id"].stringValue,
                                       domainUrl: apiResult["domain_url"].stringValue,
                                       appUpdateUrl: apiResult["appUpDate_url"].stringValue,
                                       appKeyCode: apiResult["app"].stringValue,
                                       webUrl: apiResult["web_url"].stringValue,
                                       isDev: apiResult["isDev"].stringValue == "0" ? false : true,
                                       checkLink: apiResult["check_link"].stringValue)
                let requestUrl = apiResult["web_url"].stringValue
                ModelSingleton.shared.setRequestUrl(requestUrl)
                subject.onNext(result)
            }, onError: { error in
                subject.onError(error)
                
            }).disposed(by: disposeBag)
        return subject.asObserver()
    }
    
    public func sendLog(content: ContentData) -> Observable<LogDetail> {
        let subject = PublishSubject<LogDetail>()
        apiManager.sendLog(content: content)
            .subscribe(onNext: { apiResult in
                let result = LogDetail(success: apiResult["success"].intValue,
                                       sessID: apiResult["sess_id"].stringValue,
                                       logID: apiResult["log_id"].stringValue)
                subject.onNext(result)
            }, onError: { error in
                subject.onError(error)
                
            }).disposed(by: disposeBag)
        return subject.asObserver()
    }
    
    public func checkLink() -> Observable<Result<Bool>> {
        let subject = PublishSubject<Result<Bool>>()
        apiManager.checkLink()
            .subscribe(onNext: { apiResult in
                let result = Result(data: apiResult["status"].intValue == 1, apiResult: HeaderResult(status: apiResult["header"]["status"].stringValue, description: apiResult["header"]["desc"].stringValue))
                subject.onNext(result)
            }, onError: { error in
                subject.onError(error)
            }).disposed(by: disposeBag)
        return subject.asObserver()
        
    }
    
    public func ipVerify(_ ip: String) -> Observable<Result<Bool>> {
        let subject = PublishSubject<Result<Bool>>()
        apiManager.ipVerify(ip: ip)
            .subscribe(onNext: { apiResult in
                let result = Result(data: apiResult["body"]["ip_check_result"].boolValue, apiResult: HeaderResult(status: apiResult["header"]["status"].stringValue, description: apiResult["header"]["desc"].stringValue))
                subject.onNext(result)
            }, onError: { error in
                subject.onError(error)
            }).disposed(by: disposeBag)
        return subject.asObserver()
    }
    
    public func getGameList() -> Observable<Result<[GameList]>> {
        let subject = PublishSubject<Result<[GameList]>>()
        apiManager.getGameList()
            .subscribe(onNext: { apiResult in
                let dataArray = apiResult["body"]["data"].arrayValue
                let gameArray = dataArray.map { gameInfo -> GameList in
                    let gpArray = gameInfo["gp_list"].arrayValue
                    let gpList = gpArray.map { gpInfo -> gp in
                        let gp = gp(gpID: gpInfo["gp_id"].stringValue,
                                    gtID: gpInfo["gt_id"].intValue,
                                    house: gpInfo["house"].stringValue,
                                    gameType: gpInfo["game_type"].stringValue,
                                    gameCode: gpInfo["game_code"].stringValue,
                                    gameName: gpInfo["game_name"].stringValue,
                                    gtSort: gpInfo["gt_sort"].intValue,
                                    gpName: gpInfo["gp_name"].stringValue,
                                    gpGtName: gpInfo["gp_gt_name"].stringValue,
                                    gpGtSort: gpInfo["gp_gt_sort"].intValue,
                                    banner: gpInfo["banner"].stringValue,
                                    customized: gpInfo["customized"].intValue,
                                    iconLight: gpInfo["icon_light"].stringValue,
                                    iconDark: gpInfo["icon_dark"].stringValue)
                        return gp
                    }
                    let gameList = GameList(gtID: gameInfo["gt_id"].intValue,
                                            gtName: gameInfo["gt_name"].stringValue,
                                            gtShortName: gameInfo["gt_name_short"].stringValue,
                                            gtIcon: gameInfo["gt_icon"].stringValue,
                                            gtActiveIcon: gameInfo["gt_icon_active"].stringValue,
                                            gpList: gpList)
                    return gameList
                }
                
                let result = Result(data: gameArray, apiResult: HeaderResult(status: apiResult["header"]["status"].stringValue, description: apiResult["header"]["desc"].stringValue))
                ModelSingleton.shared.setGameList(gameArray)
                subject.onNext(result)
            }, onError: { error in
                subject.onError(error)
            }).disposed(by: disposeBag)
        return subject.asObserver()
        
    }
    
}

//let KEY_CODE = "ndbpp"
//let APP_API_KEY = "6d2add3b7474ff72"
//let APP_SECRET_KEY = "b3f12ec27eca12073641821fbbbb442c"
