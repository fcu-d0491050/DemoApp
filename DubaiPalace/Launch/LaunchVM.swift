//
//  LaunchVM.swift
//  DubaiPalace
//
//  Created by user on 2022/7/19.
//

import RxSwift

enum LogStatus {
    case afterAppConfig
    case beforeCheckLink
    case afterCheckLink
    case none
}

protocol LaunchVMInterface {
    
    var appConfigSubject: PublishSubject<AppConfig> { get }
    func postAppConfig()
    
    var sendLogSubject: PublishSubject<LogDetail> { get }
    func sendLog(content: ContentData, status: LogStatus)
    
    var checkLinkSubject: PublishSubject<Bool> { get }
    func checkLink()
    
    var ipVerifySubject: PublishSubject<Result<Bool>> { get }
    func ipVerify(_ ip: String)
    
    var gameListSubject: PublishSubject<Result<[GameList]>> { get }
    func getGameList()
    
}

class LaunchVM {
    let appConfigSubject = PublishSubject<AppConfig>()
    let sendLogSubject = PublishSubject<LogDetail>()
    let checkLinkSubject = PublishSubject<Bool>()
    let ipVerifySubject = PublishSubject<Result<Bool>>()
    let gameListSubject = PublishSubject<Result<[GameList]>>()
    
    private let loginRepository: LoginRepositoryInterface
    private let disposeBag = DisposeBag()
    
    init(loginRepository: LoginRepositoryInterface = LoginRepository.shared) {
        self.loginRepository = loginRepository
    }
}

extension LaunchVM: LaunchVMInterface {
    
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
    
    func getGameList() {
        loginRepository.getGameList()
            .subscribe(onNext: { result in
                self.gameListSubject.onNext(result)
            }).disposed(by: disposeBag)
    }
}

