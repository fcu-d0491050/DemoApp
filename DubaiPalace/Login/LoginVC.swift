//
//  LoginVC.swift
//  DubaiPalace
//
//  Created by user on 2022/7/12.
//

import UIKit
import RxSwift

class LoginVC: UIViewController {
    
    private var viewModel: LoginVM?
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LoginVM()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeSubject()
    }

    private func subscribeSubject() {
        
        self.viewModel?.appConfigSubject
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                print(result)
            }).disposed(by: disposeBag)
        self.viewModel?.postAppConfig()
    }

}

