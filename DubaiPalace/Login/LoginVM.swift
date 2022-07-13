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
}

class LoginVM {
    let appConfigSubject = PublishSubject<AppConfig>()
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
}
