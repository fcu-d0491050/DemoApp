//
//  BaseTBC.swift
//  DubaiPalace
//
//  Created by user on 2022/7/21.
//

import UIKit

enum TabPage {
    case Home
    case User
    
    var tabTitle: String {
        switch self {
        case .Home:
            return "首页"
        case .User:
            return "帐户"
        }
    }
    
    var tabImg: UIImage {
        switch self {
        case .Home:
            return UIImage(systemName: "house")!
        case .User:
            return UIImage(systemName: "person")!
    
        }
    }
    
    var selectedTabImg: UIImage {
        switch self {
        case .Home:
            return UIImage(systemName: "house.fill")!
        case .User:
            return UIImage(systemName: "person.fill")!
    
        }
    }
    
    var navTitle: String {
        switch self {
        case .Home:
            return "首頁大廳"
        case .User:
            return "個人資料"
        }
    }
    
    var viewCntroller: UIViewController {
        switch self {
        case .Home:
            return LobbyVC()
        case .User:
            return ProfileVC()
        }
    }
}

class BaseTBC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTabBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func initTabBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        var controllers: [UIViewController] = []
        let pages: [TabPage] = [.Home, .User]
        for page in pages {
            let vc = page.viewCntroller
            vc.title = page.navTitle
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.tabBarItem = UITabBarItem(title: page.tabTitle, image: page.tabImg, selectedImage: page.selectedTabImg)
            controllers.append(navigationController)
        }
  
        self.viewControllers = controllers
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension BaseTBC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //
    }
}
