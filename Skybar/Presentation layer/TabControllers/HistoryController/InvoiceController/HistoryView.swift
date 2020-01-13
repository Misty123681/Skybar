//
//  HistoryView.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/6/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class HistoryView: UIView {
    
     //MARK:- outlets
    
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
    
     //MARK:- Variable
    var visit:Visit! = nil
    var layerCorners:UIView! = nil
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _ = layerCorners{}else{
            self.layoutIfNeeded()
            layerCorners = UIView(frame: self.innerView.frame)
            layerCorners.layer.cornerRadius = 13
            layerCorners.backgroundColor = whiteClr
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
    
     //MARK:- rating slider changed
    @IBAction func valueChanged(_ sender: Any) {
        starManipulation(value: Int(self.slider!.value))
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.setRatingAPI(rating: self.slider!.value)
        }
    }
    
     //MARK:- report as this wasn't me
    @IBAction func thisWasntMeBtnTapped(_ sender: Any) {
        
        ServiceInterface.thisWasNotMeAPI(caseNumber: true, handler: { (success, result) in
            GlobalUI.hideLoading()
            if success {
                if let data = result as? Data{
                    if var code = String(data: data, encoding: String.Encoding.utf8){
                        code = code.replacingOccurrences(of: "\"", with: "")
                       debugPrint(code)
                        var mesgStg :String = ""
                        if code == "true"{
                            mesgStg = "Your request has been submit successfully."
                        }else if code == "false"{
                           mesgStg = "Something went wrong. Please try again later."
                        }
                        
                        let alertView = UIAlertController(title: "Sucess", message:mesgStg, preferredStyle: .alert)

                        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                        UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
                        
                    }
                }
            }else{
                if let res = result as? String{

                }
            }
        })
        
        
    }

    
    
    func setInfo(visit:Visit){
        self.visit = visit
        
        self.titleLbl.text = self.visit.eventName
        self.descriptionLbl.text = self.visit.visitSummary
        
        self.getImage(key:self.visit.eventImage ?? "")
    

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
            //self.slider.isEnabled = false
        }
        
    }
    
    
   //MARK:-  set rating
    func setRatingAPI(rating:Float){
        ServiceInterface.setRating(visitID: visit.id!, rating: rating){ (success, result) in
            if success{}
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
