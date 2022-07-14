//
//  LoginVM.swift
//  DubaiPalace
//
//  Created by user on 2022/7/13.
//

import RxSwift

enum LogStatus {
    case afterAppConfig
    case beforeCheckLink
    case afterCheckLink
    case none
}

protocol LoginVMInterface {
    
    var appConfigSubject: PublishSubject<AppConfig> { get }
    func postAppConfig()
    
    var sendLogSubject: PublishSubject<LogDetail> { get }
    func sendLog(content: ContentData, status: LogStatus)
    
    var checkLinkSubject: PublishSubject<CheckLinkStatus> { get }
    func checkLink()
    
    var ipVerifySubject: PublishSubject<IpCheck> { get }
    func ipVerify(_ ip: String)
    
}

class LoginVM {
    let appConfigSubject = PublishSubject<AppConfig>()
    let sendLogSubject = PublishSubject<LogDetail>()
    let checkLinkSubject = PublishSubject<CheckLinkStatus>()
    let ipVerifySubject = PublishSubject<IpCheck>()
    
    private let loginRepository: LoginRepositoryInterface
    private let disposeBag = DisposeBag()
    
    init(loginRepository: LoginRepositoryInterface = LoginRepository.shared) {
        self.loginRepository = loginRepository
    }
}

extension LoginVM: LoginVMInterface {
    
    func postAppConfig() {
        loginRepository.postAppConfig()
            .subscribe(onNext: { result in
                self.appConfigSubject.onNext(result)
            }).disposed(by: disposeBag)
    }
    
    func sendLog(content: ContentData, status: LogStatus) {
        loginRepository.sendLog(content: content)
            .subscribe(onNext: { result in
                self.sendLogSubject.onNext(result)
            }).disposed(by: disposeBag)
    }
    
    func checkLink() {
        loginRepository.checkLink()
            .subscribe(onNext: { result in
                self.checkLinkSubject.onNext(result)
            }).disposed(by: disposeBag)
    }
    
    func ipVerify(_ ip: String) {
        loginRepository.ipVerify(ip)
            .subscribe(onNext: { result in
                self.ipVerifySubject.onNext(result)
            }).disposed(by: disposeBag)
    }
}
