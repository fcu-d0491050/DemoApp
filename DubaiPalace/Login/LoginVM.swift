//
//  LoginVM.swift
//  DubaiPalace
//
//  Created by user on 2022/7/13.
//

import RxSwift
import Foundation

protocol LoginVMInterface {
    
    var loginSubject: PublishSubject<Result<MemberInfo>> { get }
    func accountLogin(ac: String, pwd: String, sign: String, timeStamp: String)
}

class LoginVM {
   
    let loginSubject = PublishSubject<Result<MemberInfo>>()
    
    private let loginRepository: LoginRepositoryInterface
    private let disposeBag = DisposeBag()
    
    init(loginRepository: LoginRepositoryInterface = LoginRepository.shared) {
        self.loginRepository = loginRepository
    }
}

extension LoginVM: LoginVMInterface {

    func accountLogin(ac: String, pwd: String, sign: String, timeStamp: String) {
        loginRepository.accountLogin(account: ac, password: pwd, sign: sign, timeStamp: timeStamp)
            .subscribe(onNext: { result in
                self.loginSubject.onNext(result)
            }).disposed(by: disposeBag)
    }
    
    
  
}
