//
//  ReserveTableView.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/3/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

enum ReservationType:Int {
    case bar = 1
    case table = 2
}

class ReserveTableView: UIView {

     //MARK:- Outlets
  
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var guestsLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
      //MARK:- variable
    var layerCorners:UIView! = nil
    var reservation:Reservation! = nil
    weak var parentControler:ReserveController! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(callAction))
        self.addGestureRecognizer(tap)
    }
    
    
    /// call on tap
    @objc func callAction(){
        if let url = URL(string: "tel://\(ServiceUser.contactPhoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _ = layerCorners{}else{
            self.layoutIfNeeded()
            layerCorners = UIView(frame: self.bounds)
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
    
    @IBAction func toEventAction(_ sender: Any) {
        parentControler.selectReservation(info: self.reservation)
    }
    
    func setInfo(reservation:Reservation,parent:ReserveController){
        
        self.reservation = reservation
        self.parentControler = parent
        
        statusLbl.text = reservation.reservationStatusTypeName?.uppercased()
        
        
        /// reservation status
        if let reservationStatus = self.reservation.reservationStatusID{
            switch reservationStatus{
            case 1://Processing||Submitted
               let image = #imageLiteral(resourceName: "pendingIcon")
                statusLbl.textColor = UIColor.init(red: 255.0/255.0, green: 140.0/255.0, blue: 0.0/255.0, alpha: 1)
              statusImg.image = image.maskWithColor(color: UIColor.init(red: 255.0/255.0, green: 140.0/255.0, blue: 0.0/255.0, alpha: 1))
                break
            case 2://WalkinOnly||WaitList||Pending
                let image = #imageLiteral(resourceName: "waiting-list")
                self.statusLbl.textColor = UIColor.init(red: 255.0/255.0, green: 140.0/255.0, blue: 0.0/255.0, alpha: 1)
                self.statusImg.image = image.maskWithColor(color: UIColor.init(red: 255.0/255.0, green: 140.0/255.0, blue: 0.0/255.0, alpha: 1))
                break
             
            case 4://Rejected||FullCapacity
                let image = #imageLiteral(resourceName: "rejectedIcon")
                self.statusLbl.textColor = UIColor.init(red: 241.0/255.0, green: 50.0/255.0, blue: 67.0/255.0, alpha: 1)
                 self.statusImg.image = image.maskWithColor(color:UIColor.init(red: 241.0/255.0, green: 50.0/255.0, blue: 67.0/255.0, alpha: 1))
                break
            case 3://Confirmed||Approved
               let image = #imageLiteral(resourceName: "approveIcon")
                self.statusImg.image = image.maskWithColor(color:UIColor.init(red: 0.13, green: 0.64, blue: 0, alpha: 1))
                self.statusLbl.textColor = UIColor(red: 0.13, green: 0.64, blue: 0, alpha: 1)
                break
            default: // others
                self.statusLbl.textColor = UIColor.init(red: 241.0/255.0, green: 50.0/255.0, blue: 67.0/255.0, alpha: 1)
                break
             
            }
        }
        
        if let reservationtypeName = self.reservation.reservationTypeName{
            self.dateLbl.text = reservationtypeName
        }
        
        if let resDate = self.reservation.eventDate{
            if let date = Date(jsonDate: resDate){
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
                formatter.dateFormat = "dd MMM yyyy"
                
                let monthDayStr = formatter.string(from: date) // string purpose I add here
                self.dateLbl.text! += ", \(monthDayStr.uppercased())"
            }
        }
        
        if let count = self.reservation.numberOfGuests{
            guestsLbl.text = "\(count) Guests"
        }
        
    }
}

