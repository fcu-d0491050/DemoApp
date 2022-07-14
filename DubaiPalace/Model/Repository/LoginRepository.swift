//
//  LoginRepository.swift
//  DubaiPalace
//
//  Created by user on 2022/7/13.
//

import RxSwift

public protocol LoginRepositoryInterface {
    func postAppConfig() -> Observable<AppConfig>
    func sendLog(content: ContentData) -> Observable<LogDetail>
    func checkLink() -> Observable<CheckLinkStatus>
    func ipVerify(_ ip : String) -> Observable<IpCheck>
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
    
    public func checkLink() -> Observable<CheckLinkStatus> {
        let subject = PublishSubject<CheckLinkStatus>()
        apiManager.checkLink()
            .subscribe(onNext: { apiResult in
                let result = CheckLinkStatus(isSuccess: apiResult["status"].intValue == 1)
                subject.onNext(result)
            }, onError: { error in
                subject.onError(error)
            }).disposed(by: disposeBag)
        return subject.asObserver()
        
    }
    
    public func ipVerify(_ ip: String) -> Observable<IpCheck> {
        let subject = PublishSubject<IpCheck>()
        apiManager.ipVerify(ip: ip)
            .subscribe(onNext: { apiResult in
                let result = IpCheck(status: apiResult["header"]["status"].stringValue, ipCheckResult: apiResult["body"]["ip_check_result"].boolValue)
                subject.onNext(result)
            }, onError: { error in
                subject.onError(error)
            }).disposed(by: disposeBag)
        return subject.asObserver()
    }
    
}
