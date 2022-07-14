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
    func checkLink(url: String)
    
}

class LoginVM {
    let appConfigSubject = PublishSubject<AppConfig>()
    let sendLogSubject = PublishSubject<LogDetail>()
    let checkLinkSubject = PublishSubject<CheckLinkStatus>()
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
    
    func checkLink(url: String) {
        loginRepository.checkLink(url: url)
            .subscribe(onNext: { result in
                self.checkLinkSubject.onNext(result)
            }).disposed(by: disposeBag)
    }
}
