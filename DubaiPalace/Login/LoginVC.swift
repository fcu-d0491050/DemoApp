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
    
    private var viewModel: LoginVM?
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var videoBackground: UIView!
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
    
    private func subscribeSubject() {
        
        //apprdtest01, qwe123
        
    }
    
}
