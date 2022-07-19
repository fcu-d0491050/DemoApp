//
//  Extension_Localization.swift
//  DubaiPalace
//
//  Created by user on 2022/7/19.
//

import UIKit

extension UIViewController {
    
    //錯誤訊息
    func showAlert(message: String) {
        let alert = UIAlertController(title: "提示", message: "\(message)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension Data {
    
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    
    var sha256: Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes({
            _ = CC_SHA256($0, CC_LONG(self.count), &digest)
        })
        return Data(bytes: digest)
    }
    
}

extension String {
    
    func sha256(salt: String) -> Data {
        return (self + salt).data(using: .utf8)!.sha256
    }
    
}
