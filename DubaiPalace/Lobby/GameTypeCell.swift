//
//  GameTypeCell.swift
//  DubaiPalace
//
//  Created by user on 2022/7/22.
//

import UIKit
import Kingfisher

class GameTypeCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbGameType: UILabel!
    
    private var defaultUrl = ""
    private var activeUrl = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(title: String, defaultImg: String, activeImgUrl: String) {
        self.defaultUrl = defaultImg
        self.activeUrl = activeImgUrl
        lbGameType.text = title
    }
    
    var isSelect:Bool = false{
        didSet{
            lbGameType.textColor = isSelect ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            imageView.kf.setImage(with: URL(string: isSelect ? activeUrl : defaultUrl))
        }
    }

}
