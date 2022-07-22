//
//  LobbyVC.swift
//  DubaiPalace
//
//  Created by user on 2022/7/22.
//

import UIKit
import CoreAudio

class LobbyVC: UIViewController {

    
    @IBOutlet weak var headCollectionView: UICollectionView!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    private var selectIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        
        // Do any additional setup after loading the view.
    }
    

    private func initView() {
        self.headCollectionView.register(UINib(nibName: "GameTypeCell", bundle: nil), forCellWithReuseIdentifier: "GameTypeCell")
    }

}

extension LobbyVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.headCollectionView {
            return ModelSingleton.shared.gameList.count

        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.headCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameTypeCell", for: indexPath) as! GameTypeCell
            let gameArray = ModelSingleton.shared.gameList
            cell.setData(title: gameArray[indexPath.row].gtShortName, defaultImg: gameArray[indexPath.row].gtIcon, activeImgUrl: gameArray[indexPath.row].gtActiveIcon)
            cell.isSelect = indexPath.row == selectIndex
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.headCollectionView {
            selectIndex = indexPath.row
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionView.reloadData()
        }
    }
    
    
}
