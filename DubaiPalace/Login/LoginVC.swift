//
//  LoginVC.swift
//  DubaiPalace
//
//  Created by user on 2022/7/12.
//

import UIKit
import RxSwift
import CoreTelephony
import Network

class LoginVC: UIViewController {
    
    private var viewModel: LoginVM?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.viewModel = LoginVM()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeSubject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func subscribeSubject() {
        
        //apprdtest01, qwe123
        
    }
    
}
