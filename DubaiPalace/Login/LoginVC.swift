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
                self.getMobileInfo(result)
            }).disposed(by: disposeBag)
        self.viewModel?.postAppConfig()
        
        self.viewModel?.sendLogSubject
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                print(result)
            }).disposed(by: disposeBag)
        
    }
    
    private func getMobileInfo(_ appConfig: AppConfig) {
        let userAgent = "mobile,iPhone Mobile, name: \(UIDevice.current.name), systemVersion: \(UIDevice.current.systemVersion), label: Apple, model: \(UIDevice.current.model)"
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
//        let networkInfo = CTTelephonyNetworkInfo()
//        let carrier = networkInfo.subscriberCellularProvider
//        if let currentRadioTech = networkInfo.currentRadioAccessTechnology {
//            let access = getNetworkType(currentRadioTech: currentRadioTech)
//            let cellular = carrier?.carrierName ?? "No SIM Card"
//        }
//
        let contentData = ContentData(mobileInfo: MobileInfo(cpuUsed: "", memFree: "", deviceName: UIDevice.current.name, access: "", usefulSpace: "", operatorName: "", memUsed: ""), appInfo: AppInfo(userAgent: userAgent, phoneStartTime: "", stauts: "2", appKey: appConfig.appKeyCode, logID: appConfig.logID, deviceID: deviceID, response: "", sessID: appConfig.sessID, requestUrl: appConfig.domainUrl, phoneEndTime: ""))
        self.viewModel?.sendLog(content: contentData)
    }
    
    
}

extension LoginVC {
    
    private func getNetworkType(currentRadioTech: String) -> String {
        
        var networkType = ""
        
        let nwPathMonitor = NWPathMonitor()
        nwPathMonitor.pathUpdateHandler = { path in
            
            if path.usesInterfaceType(.wifi) {
                networkType = "WiFi"
            } else if path.usesInterfaceType(.cellular) {
                switch currentRadioTech {
                case CTRadioAccessTechnologyGPRS:
                    networkType = "2G"
                case CTRadioAccessTechnologyEdge:
                    networkType = "2G"
                case CTRadioAccessTechnologyCDMA1x:
                    networkType = "2G"
                case CTRadioAccessTechnologyeHRPD:
                    networkType = "3G"
                case CTRadioAccessTechnologyHSDPA:
                    networkType = "3G"
                case CTRadioAccessTechnologyCDMAEVDORev0:
                    networkType = "3G"
                case CTRadioAccessTechnologyCDMAEVDORevA:
                    networkType = "3G"
                case CTRadioAccessTechnologyCDMAEVDORevB:
                    networkType = "3G"
                case CTRadioAccessTechnologyHSUPA:
                    networkType = "3G"
                case CTRadioAccessTechnologyLTE:
                    networkType = "4G"
                default:
                    break
                }
            } else if path.usesInterfaceType(.wiredEthernet) {
                networkType = "Wired Ethernet"
            } else if path.usesInterfaceType(.loopback) {
                networkType = "Loopback"
            } else if path.usesInterfaceType(.other) {
                networkType = "other"
            }
        }
        nwPathMonitor.start(queue: .main)
        return networkType
    }
    
}

