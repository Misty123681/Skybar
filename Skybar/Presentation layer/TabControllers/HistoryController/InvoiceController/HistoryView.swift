//
//  HistoryView.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/6/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class HistoryView: UIView {
    var visit:Visit! = nil
    var layerCorners:UIView! = nil
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var consumptionLbl: UILabel!
    @IBOutlet weak var freeConsumptionLbl: UILabel!
    @IBOutlet weak var paidConsumptionLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _ = layerCorners{
            
        }else{
            self.layoutIfNeeded()
            layerCorners = UIView(frame: self.innerView.frame)
            layerCorners.layer.cornerRadius = 13
            layerCorners.backgroundColor = UIColor.white
            layerCorners.layer.shadowOffset = CGSize.zero
            layerCorners.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.11).cgColor
            layerCorners.layer.shadowOpacity = 1
            layerCorners.layer.shadowRadius = 10
            self.addSubview(layerCorners)
            self.sendSubviewToBack(layerCorners)
            
            innerView.layer.masksToBounds = true
            innerView.layer.cornerRadius = 13
        }
    }
    
    func disableAllStars(){
        star1.image = UIImage(named: "stargrey")
        star2.image = UIImage(named: "stargrey")
        star3.image = UIImage(named: "stargrey")
        star4.image = UIImage(named: "stargrey")
        star5.image = UIImage(named: "stargrey")
    }
    
    func starManipulation(value:Int){
        
        switch value {
        case 0:
            disableAllStars()
            break
        case 1:
            disableAllStars()
            star1.image = UIImage(named: "starfill")
            break
        case 2:
            disableAllStars()
            star1.image = UIImage(named: "starfill")
            star2.image = UIImage(named: "starfill")
            break
        case 3:
            disableAllStars()
            star1.image = UIImage(named: "starfill")
            star2.image = UIImage(named: "starfill")
            star3.image = UIImage(named: "starfill")
            break
        case 4:
            disableAllStars()
            star1.image = UIImage(named: "starfill")
            star2.image = UIImage(named: "starfill")
            star3.image = UIImage(named: "starfill")
            star4.image = UIImage(named: "starfill")
            break
        case 5:
            disableAllStars()
            star1.image = UIImage(named: "starfill")
            star2.image = UIImage(named: "starfill")
            star3.image = UIImage(named: "starfill")
            star4.image = UIImage(named: "starfill")
            star5.image = UIImage(named: "starfill")
            break
        default:
            break
        }
    }
    @IBAction func valueChanged(_ sender: Any) {
        starManipulation(value: Int(self.slider!.value))
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.setRatingAPI(rating: self.slider!.value)
        }
    }
    
    
    @IBAction func thisWasntMeBtnTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure, you want to report that this was not you?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            
           
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
       UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func setInfo(visit:Visit){
        self.visit = visit
        
        self.titleLbl.text = self.visit.eventName
        self.descriptionLbl.text = self.visit.visitSummary
        
       // if let eventImage = self.visit.eventImage{
            self.getImage(key:self.visit.eventImage ?? "")
       // }
        
        if let dateVisited = self.visit.dateVisited{
            if let date = Date(jsonDate: dateVisited){
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
                formatter.dateFormat = "MMM dd, yyyy"
                
                let str = formatter.string(from: date) // string purpose I add here
                dateLbl.text = str.uppercased()
            }
        }
        if let totalBill = self.visit.totalBillValue{
            self.consumptionLbl.text = totalBill.toCurrency() //totalBillValue
        }
        
        if let freeBill = self.visit.discountProvided{
            self.freeConsumptionLbl.text = freeBill.toCurrency() // discountProvided
        }
        
        if let paidBill = self.visit.totalPaid{
            self.paidConsumptionLbl.text = paidBill.toCurrency() // totalPaid
        }
        
        
        if let rating = self.visit.visitRatingValue{
            starManipulation(value: Int(rating))
        }
        
    }
    
    
    func thisWasNotMeAPI(){
        ServiceInterface.thisWasNotMeAPI(visitID: "T##String", rating: 2.0) { (success, result) in
            
            if success {
                
            }else{
                
            }
        }
        
    }
    
    func setRatingAPI(rating:Float){
        GlobalUI.showLoading(UIApplication.shared.keyWindow!)
        ServiceInterface.setRating(visitID: visit.id!, rating: rating){ (success, result) in
            GlobalUI.hideLoading()
            if success{
                OperationQueue.main.addOperation({
                    let alert = UIAlertController(title: "You have rated successfully", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                    }
                    alert.addAction(okAction)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                })
            }
            else{
                
            }
        }
    }
    
    func getImage(key:String){
        self.loader.startAnimating()
        ServiceInterface.getImage(imageName: key, handler: { (success, result) in
            OperationQueue.main.addOperation {
                self.loader.stopAnimating()
                if success {
                    if let data = result as? Data{
                        
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
        })
    }
    
    
    

}
