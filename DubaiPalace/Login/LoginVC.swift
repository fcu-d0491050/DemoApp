//
//  LoginVC.swift
//  DubaiPalace
//
//  Created by user on 2022/7/12.
//

import UIKit
import RxSwift
import SwiftVideoBackground

class LoginVC: UIViewController {
    
    private var showPassword: Bool = false
    private var viewModel: LoginVM?
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var videoBackground: UIView!
    @IBOutlet weak var accountTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var pwdEyeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
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
    
    @IBAction func showPasswordAction(_ sender: Any) {
        switch showPassword {
        case true:
            pwdTxtField.isSecureTextEntry = false
            pwdEyeBtn.setImage(UIImage(named: "icon_open"), for: .normal)
        case false:
            pwdTxtField.isSecureTextEntry = true
            pwdEyeBtn.setImage(UIImage(named: "icon_close"), for: .normal)
        }
        showPassword = !showPassword
    }
    
    
    @IBAction func didClickLoginBtn(_ sender: Any) {
        let account = accountTxtField.text ?? ""
        let password = pwdTxtField.text ?? ""
        guard !account.isEmpty else {
            showAlert(message: "用户名不能为空")
            return
        }
        guard !password.isEmpty else {
            showAlert(message: "密码不能为空")
            return
        }
        
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        self.viewModel?.accountLogin(account: account, password: password, timeStamp: timeStamp)
    }
    
    @IBAction func didClickBrowseBtn(_ sender: Any) {
        
    }
    
    private func initView() {
        self.navigationItem.hidesBackButton = true
        try? VideoBackground.shared.play(view: videoBackground, videoName: "login", videoType: "mp4", darkness: 0.50)
    }
    
    private func subscribeSubject() {
        
        self.viewModel?.loginSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                if result.apiResult.status.suffix(3) == "100" {
                    //登入成功
                    print("登入成功")
                } else {
                    self.showAlert(message: result.apiResult.description)
                }
            }).disposed(by: disposeBag)
        
    }
    
}
