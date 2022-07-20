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
    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var pwdEyeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        try? VideoBackground.shared.play(view: videoBackground, videoName: "login", videoType: "mp4", darkness: 0.50)
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
        
    }
    
    @IBAction func didClickBrowseBtn(_ sender: Any) {
        
    }
    
    
    private func subscribeSubject() {
        
        //apprdtest01, qwe123
        
    }
    
}
