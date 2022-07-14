//
//  LoginVM.swift
//  DubaiPalace
//
//  Created by user on 2022/7/13.
//

import RxSwift

protocol LoginVMInterface {
    
    var appConfigSubject: PublishSubject<AppConfig> { get }
    func postAppConfig()
    
    var sendLogSubject: PublishSubject<LogDetail> { get }
    func sendLog(content: ContentData)
    
}

class LoginVM {
    let appConfigSubject = PublishSubject<AppConfig>()
    let sendLogSubject = PublishSubject<LogDetail>()
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
    
    func sendLog(content: ContentData) {
        loginRepository.sendLog(content: content)
            .subscribe(onNext: { result in
                self.sendLogSubject.onNext(result)
            }).disposed(by: disposeBag)
    }
}
