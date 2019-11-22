//
//  InvoiceController.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/7/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class InvoiceController: ParentController {
    
    //MARK:- Outlets

    @IBOutlet weak var totalPaidLbl: UILabel!
    @IBOutlet weak var discountPercentLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var totalConsumptionLbl: UILabel!
    @IBOutlet weak var container: UIScrollView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK:- Variable
    var visitObj:Visit! = nil
    var status:SkyStatus! = nil
    
    //MARK:- view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let totalBill = visitObj?.totalBillValue,let discountProvided = visitObj?.discountProvided, let totalPaid = visitObj?.totalPaid{
            totalConsumptionLbl.text = totalBill.toCurrency()
            discountLbl.text = "- \(discountProvided.toCurrency())"
            totalPaidLbl.text = totalPaid.toCurrency()
            if let discount = visitObj.discount{
                discountPercentLbl.text = "Rewards discount \(discount)%"
            }
            descriptionLbl.text = visitObj.visitSummary
        }
        
        if let eventImage = visitObj?.eventImage{
            self.getImage(key:eventImage)
        }

        if let dateVisited = visitObj?.dateVisited{
            if let date = Date(jsonDate: dateVisited){
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
                formatter.dateFormat = "MMM dd, yyyy"
                
                let str = formatter.string(from: date) // string purpose I add here
                dateLbl.text = str.uppercased()
            }
        }
        
        if let visitID = visitObj?.id{
            ServiceInterface.GetVisitBill(visitID: visitID, handler: { (success, result) in
                if let data = result as? Data{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
                        print(json!)
                        OperationQueue.main.addOperation({
                            self.populateInvoice(json:json!)
                        })
                    }
                    catch{
                        
                    }
                }
            })
        }
        
        if let totalBill = status?.currentVisitInfo?.yourCurrentTab,let discountProvided = status?.currentVisitInfo?.totalDiscountValue{
            totalConsumptionLbl.text = totalBill.toCurrency()
            discountLbl.text = "- \(discountProvided.toCurrency())"
            totalPaidLbl.text = (totalBill-discountProvided).toCurrency()
            descriptionLbl.text = status?.nearestEventDetails?.description
        }
        
        if let eventImage = status?.nearestEventDetails?.eventImage{
            self.getImage(key:eventImage)
        }
        
        if let dateVisited = status?.nearestEventDetails?.eventDate{
            if let date = Date(jsonDate: dateVisited){
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
                formatter.dateFormat = "MMM dd, yyyy"
                
                let str = formatter.string(from: date) // string purpose I add here
                dateLbl.text = str.uppercased()
            }
        }
        
        if let visitID = status.currentVisitInfo?.visitID{
            ServiceInterface.GetVisitBill(visitID: visitID, handler: { (success, result) in
                if let data = result as? Data{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
                        print(json!)
                        OperationQueue.main.addOperation({
                            self.populateInvoice(json:json!)
                        })
                    }
                    catch{}
                }
            })
        }
    }
    
    func populateInvoice(json:[Any]){
        self.view.layoutIfNeeded()
        container.subviews.forEach({ $0.removeFromSuperview() })
        
        var y:CGFloat = 0
        
        for details in json{
            let billView:BillCell = BillCell.fromNib()
            billView.frame = CGRect(x: 0, y: y, width: container.frame.size.width, height: billView.frame.size.height)
            y += billView.frame.size.height
            if let details = details as? [String:Any]{
                billView.setInfo(info: details)
            }
            container.addSubview(billView)
        }
        
        container.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: y, right: 0)
    }
    
    @IBAction func backAction(_ sender: Any) {
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }

  
    func getImage(key:String){
        ServiceInterface.getImage(imageName: key, handler: { (success, result) in
            OperationQueue.main.addOperation {
                if success {
                    if let data = result as? Data{
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
        })
    }

}
