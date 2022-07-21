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
    func accountLogin(account: String, password: String, timeStamp: Int)
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

    func accountLogin(account: String, password: String, timeStamp: Int) {
        loginRepository.accountLogin(account: account, password: password, timeStamp: timeStamp)
            .subscribe(onNext: { result in
                self.loginSubject.onNext(result)
            }).disposed(by: disposeBag)
    }
    
    
  
}
