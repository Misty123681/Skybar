//
//  WalkThrouController.swift
//  Skybar
//
//  Created by Christopher Nassar on 12/4/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class WalkThrouController: ParentController{
    
    // MARK:- properties
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var nextArrow: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK:- properties
    var descriptionArr = [String]()
    var titleArr = [String]()
    var imageArr = [String]()
    var tutorialCellIdentifier = "TutorialCell"
    var congratCellIdentifier = "CongratsCell"
    
    // MARK:- view cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    // MARK:- Methods
    fileprivate func setUpData() {
        
        titleArr.append("Free careem pick up and drop off".capitalized)
        descriptionArr.append("Don't drink and drive, just order a Careem ride from the app for free")
        imageArr.append("careem_screen")
        
        titleArr.append("Free careem pick up and drop off".capitalized)
        descriptionArr.append("Please Use Promo Code ")
        imageArr.append("careem_screen")
        
        titleArr.append("Make Reservations".capitalized)
        descriptionArr.append("Book in priority a table or seats at the bar from the app")
        imageArr.append("reservation_screen")
        
        titleArr.append("Guest List".capitalized)
        descriptionArr.append("Put the names of your guests on your guestlist via the private entrance")
        imageArr.append("guestlist_screen")
        
        titleArr.append("View your open tab in real time".capitalized)
        descriptionArr.append("Keep track of your consumption and discounts in real time")
        imageArr.append("table_screen")
        
        titleArr.append("Rate The Night".capitalized)
        descriptionArr.append("Tap on the stars to let us know your satisfaction level on that night ")
        imageArr.append("rate_screen")
        
        titleArr.append("Refer A Star".capitalized)
        descriptionArr.append("Refer star candidates to this program")
        imageArr.append("refer_screen")
        
        let nib = UINib(nibName: tutorialCellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: tutorialCellIdentifier)
        
        let nib1 = UINib(nibName: congratCellIdentifier, bundle: nil)
        collectionView.register(nib1, forCellWithReuseIdentifier: congratCellIdentifier)
    }
    
    
    @IBAction func nextAction(_ sender: Any) {
        let index = Int(collectionView.contentOffset.x/collectionView.getWidth())
        
        if (index == 6){
            if let _ = self.navigationController{
                self.performSegue(withIdentifier: "toHome", sender: nil)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        titleLbl.text = titleArr[index]
        pageControl.currentPage = index
        collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x+collectionView.getWidth(), y: 0), animated: true)
    }
    
    
}

// MARK:- extension
extension WalkThrouController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            if let profile = ServiceUser.profile{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: congratCellIdentifier, for: indexPath) as! CongratsCell
                cell.setInformation(profileID: profile.id, fName: profile.firstName, lName: profile.lastName)
                return cell
            }
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tutorialCellIdentifier, for: indexPath) as! TutorialCell
        
        if indexPath.row == imageArr.count - 1 {
            cell.setInformation(imageName: imageArr[indexPath.row], descriptionStr: descriptionArr[indexPath.row], parent: self,startBtn: false)
            
        }else{
            cell.setInformation(imageName: imageArr[indexPath.row], descriptionStr: descriptionArr[indexPath.row], parent: self)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.getWidth(), height: collectionView.getHeight())
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x/scrollView.getWidth())
        guard  index <= 6 else{
            return
        }
        if index == 0 {
            titleLbl.text = ""
        }else {
            titleLbl.text = titleArr[index]
        }
        nextBtn.isHidden = false
        nextArrow.isHidden = false
        
        if index == imageArr.count - 1 {
            nextBtn.isHidden = true
            nextArrow.isHidden = true
        }
        
        pageControl.currentPage = index
    }
    
}
