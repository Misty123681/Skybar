//
//  LastReservationView.swift
//  Skybar
//
//  Created by Christopher Nassar on 11/1/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class LastReservationView: UIView {
    
     //MARK:- outlets
    @IBOutlet weak var updateDateLbl: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var guestsLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
     //MARK:- Variable
    var reservation:Reservation! = nil
    var layerCorners:UIView! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(callAction))
        self.addGestureRecognizer(tap)
    }
    
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
        if let _ = layerCorners{
            
        }else{
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
    
    func setInfo(reservation:Reservation){
        
        self.reservation = reservation
        statusLbl.text = reservation.reservationStatusTypeName?.uppercased()
        
        switch statusLbl.text{
        case "PENDING":
            statusLbl.textColor = .orange
            break
        case "REJECTED":
            statusLbl.textColor = UIColor.init(red: 241.0/255.0, green: 50.0/255.0, blue: 67.0/255.0, alpha: 1)
            break
        default://Confirmed
            statusLbl.textColor = UIColor.init(red: 33.0/255.0, green: 164.0/255.0, blue: 0, alpha: 1)
            break
        }
        
        
        if let reservationtypeID = self.reservation.reservationTypeID,let type:ReservationType = ReservationType(rawValue:reservationtypeID){
            switch type{
            case .bar:
                self.dateLbl.text = "Bar"
                break
            case .table:
                self.dateLbl.text = "Table"
                break
            }
        }
        
        if let reservationDateCreated = reservation.eventDate{
            if let date = Date(jsonDate: reservationDateCreated){
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
                formatter.dateFormat = "dd MMM yyyy"
                
                let monthDayStr = formatter.string(from: date) // string purpose I add here
                self.updateDateLbl.text! += "\(monthDayStr.uppercased()) - RESERVATION"
            }
        }
        
        guestsLbl.text = "\(String(describing: reservation.numberOfGuests)) Guests"
        
    }

}
