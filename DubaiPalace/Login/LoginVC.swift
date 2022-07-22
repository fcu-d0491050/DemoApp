//
//  LoginVC.swift
//  DubaiPalace
//
//  Created by user on 2022/7/12.
//

import UIKit
import RxSwift
import SwiftVideoBackground

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var videoBackground: UIView!
    @IBOutlet weak var accountTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var pwdEyeBtn: UIButton!
    @IBOutlet weak var rememberMeBtn: UIButton!
    
    private var showPassword: Bool = false
    private var viewModel: LoginVM?
    private var disposeBag = DisposeBag()
    
    var rememberMe: Bool = UserDefaults.standard.bool(forKey: "remember") {
        didSet{
            rememberMeBtn.setImage(rememberMe ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
            UserDefaults.standard.set(rememberMe, forKey: "remember")
        }
    }
    
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
        showPassword = !showPassword
        switch showPassword {
        case true:
            pwdTxtField.isSecureTextEntry = false
            pwdEyeBtn.setImage(UIImage(named: "icon_open"), for: .normal)
        case false:
            pwdTxtField.isSecureTextEntry = true
            pwdEyeBtn.setImage(UIImage(named: "icon_close"), for: .normal)
        }
    }
    
    @IBAction func didClickRememberBtn(_ sender: Any) {
        rememberMe = !rememberMe
        switch rememberMe {
        case true:
            rememberMeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            UserDefaults.standard.set(true, forKey: "remember")

        case false:
            rememberMeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            UserDefaults.standard.set(false, forKey: "remember")
        }
        //更新是否儲存帳密
        UserDefaults.standard.synchronize()
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
        UserDefaults.standard.set(account, forKey: "account")
        UserDefaults.standard.set(password, forKey: "password")
        self.viewModel?.accountLogin(account: account, password: password, timeStamp: timeStamp)
    }
    
    @IBAction func didClickBrowseBtn(_ sender: Any) {
        let BaseTBC = UIStoryboard(name: "Base", bundle: nil).instantiateViewController(withIdentifier: "BaseTBC")
        self.navigationController?.pushViewController(BaseTBC, animated: false)
    }
    
    private func initView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        try? VideoBackground.shared.play(view: videoBackground, videoName: "login", videoType: "mp4", darkness: 0.50)
        self.accountTxtField.delegate = self
        self.pwdTxtField.delegate = self
        if rememberMe {
            self.accountTxtField.text = UserDefaults.standard.string(forKey: "account")
            self.pwdTxtField.text = UserDefaults.standard.string(forKey: "password")
        }
        rememberMeBtn.setImage(self.rememberMe ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
    }
    
    private func subscribeSubject() {
        
        self.viewModel?.loginSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                //登入成功
                if result.apiResult.status.suffix(3) == "100" {
                    //更新帳密儲存資料
                    UserDefaults.standard.synchronize()
                    print("登入成功")
                    self.viewModel?.getGameList()
                } else {
                    self.showAlert(message: result.apiResult.description)
                }
            }).disposed(by: disposeBag)
        
        self.viewModel?.gameListSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                //登入成功
                if result.apiResult.status.suffix(3) == "100" {
                    print("帶入Authorization的遊戲列表")
                    print(result)
                } else {
                    self.showAlert(message: result.apiResult.description)
                }
            }).disposed(by: disposeBag)
        
        
    }
    
}
