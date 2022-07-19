//
//  LaunchVC.swift
//  DubaiPalace
//
//  Created by user on 2022/7/18.
//

import UIKit

import UIKit
import RxSwift
import CoreTelephony
import Network


class LaunchVC: UIViewController {
    
    private var viewModel: LaunchVM?
    private var contentData = ContentData()
    private var status : LogStatus = .none
    private var logID = ""
    private var progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: 250, height: 10))

    private var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LaunchVM()
        initView()
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
    
    private func initView() {
        progressView.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2 + 100)
        progressView.setProgress(0.0, animated: true)
        progressView.progressTintColor = UIColor.yellow
        self.view.addSubview(progressView)
    }
    
    private func subscribeSubject() {
        
        self.viewModel?.appConfigSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                self.sendLogAfterAppConfig(result)
                self.progressView.progress = 0.2
            }).disposed(by: disposeBag)
        self.viewModel?.postAppConfig()
        
        self.viewModel?.sendLogSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch self.status {
                case .afterAppConfig:
                    self.status = .beforeCheckLink
                    self.sendLogBeforeCheckLink()
                    self.progressView.progress = 0.4
                case .beforeCheckLink:
                    self.logID = result.logID
                    self.viewModel?.checkLink()
                    self.progressView.progress = 0.6
                case .afterCheckLink:
                    self.viewModel?.ipVerify(self.getIPAddress())
                    self.progressView.progress = 0.8
                case .none:
                    break
                }
            }).disposed(by: disposeBag)
        
        self.viewModel?.checkLinkSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isLinkPass in
                guard isLinkPass.data else { return } //網頁正常
                self.status = .afterCheckLink
                self.sendLogAfterCheckLink()
            }).disposed(by: disposeBag)
        
        self.viewModel?.ipVerifySubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                //status後三碼為100即為成功，非100為其他錯誤碼
                if result.apiResult.status.suffix(3) == "100" {
                    if result.data {
                        self.viewModel?.getGameList()
                    } else {
                        print(result.apiResult.status.suffix(3))
                    }
                } else {
                    self.showAlert(message: "錯誤：status後三碼非100")
                }
                print(result)
            }).disposed(by: disposeBag)
        
        self.viewModel?.gameListSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                self.progressView.progress = 1
                let vc = LoginVC()
                self.navigationController?.pushViewController(vc, animated: false)
            }).disposed(by: disposeBag)
        
        
        //apprdtest01, qwe123
        
        
    }
    
    private func sendLogAfterAppConfig(_ appConfig: AppConfig) {
        let userAgent = "mobile,iPhone Mobile, name: \(UIDevice.current.name), systemVersion: \(UIDevice.current.systemVersion), label: Apple, model: \(UIDevice.current.model)"
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
//        let networkInfo = CTTelephonyNetworkInfo()
//        let carrier = networkInfo.subscriberCellularProvider
//        if let currentRadioTech = networkInfo.currentRadioAccessTechnology {
//            let access = getNetworkType(currentRadioTech: currentRadioTech)
//            let cellular = carrier?.carrierName ?? "No SIM Card"
//        }
//
        logID = appConfig.logID
        contentData = ContentData(mobileInfo: MobileInfo(cpuUsed: "", memFree: "", deviceName: UIDevice.current.name, access: "", usefulSpace: "", operatorName: "", memUsed: ""), appInfo: AppInfo(userAgent: userAgent, phoneStartTime: "", stauts: "2", appKey: appConfig.appKeyCode, logID: appConfig.logID, deviceID: deviceID, response: "", sessID: appConfig.sessID, requestUrl: appConfig.domainUrl, phoneEndTime: ""))
        self.status = .afterAppConfig
        self.viewModel?.sendLog(content: contentData, status: self.status)
    }
    
    private func sendLogBeforeCheckLink() {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        contentData.appInfo?.phoneStartTime = String(timeInterval)
        contentData.appInfo?.logID = ""
        contentData.appInfo?.stauts = "1"
        self.viewModel?.sendLog(content: contentData, status: self.status)
    }
    
    private func sendLogAfterCheckLink() {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        contentData.appInfo?.phoneEndTime = String(timeInterval)
        contentData.appInfo?.stauts = "2"
        contentData.appInfo?.logID = self.logID
        contentData.appInfo?.requestUrl = ModelSingleton.shared.requestUrl
        self.viewModel?.sendLog(content: contentData, status: self.status)
    }
    
}

extension LaunchVC {
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "提示", message: "\(message)", preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(updateAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }
    
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
