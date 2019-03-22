//
//  InstaView.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/6/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import AVKit

class InstaView: UIView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var parent:InstaDelegate! = nil
    var instaArray:[InstaMedia]! = nil
    let cellIdentifier = "SubInstaCell"
    var currentIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    @objc func scrollToIndex(){
        collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    func setIndex(index:Int){
        currentIndex = index
        if let _ = instaArray{
            if currentIndex < instaArray.count{
                self.perform(#selector(scrollToIndex), with: nil, afterDelay: 0.2)
            }
        }
    }
    func setConfig(arr:[InstaMedia],parent:InstaDelegate){
        self.instaArray = arr
        self.parent = parent
        collectionView.reloadData()
    }
    
    @IBAction func closeAction(_ sender: Any) {
       self.removeFromSuperview()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = instaArray{
            return instaArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SubInstaCell
        cell.setMedia(instaArray[indexPath.row], index: indexPath.row, parent: parent!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.getWidth(), height: collectionView.getHeight()*0.5)
    }

}
