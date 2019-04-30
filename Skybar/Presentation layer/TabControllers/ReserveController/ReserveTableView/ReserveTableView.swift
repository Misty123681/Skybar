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

    var layerCorners:UIView! = nil
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var guestsLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    var reservation:Reservation! = nil
    weak var parentControler:ReserveController! = nil
    
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
            layerCorners = UIView(frame: self.bounds)
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
    
    @IBAction func toEventAction(_ sender: Any) {
        parentControler.selectReservation(info: self.reservation)
    }
    
    func setInfo(reservation:Reservation,parent:ReserveController){
        self.reservation = reservation
        self.parentControler = parent
        
        statusLbl.text = reservation.reservationStatusTypeName?.uppercased()
        
        if let reservationStatus = self.reservation.reservationStatusID,let resStatus = ReservationStatus(rawValue: reservationStatus){
            switch resStatus{
            case .Pending:
                statusLbl.textColor = .orange
                break
            case .Rejected:
                statusLbl.textColor = UIColor.init(red: 241.0/255.0, green: 50.0/255.0, blue: 67.0/255.0, alpha: 1)
                break
            default://Confirmed
                statusLbl.textColor = UIColor.init(red: 33.0/255.0, green: 164.0/255.0, blue: 0, alpha: 1)
                break
            }
        }
        
//        if let reservationtypeID = self.reservation.reservationTypeID,let type:ReservationType = ReservationType(rawValue:reservationtypeID){
//            switch type{
//            case .bar:
//                self.dateLbl.text = "Bar"
//                break
//            case .table:
//                self.dateLbl.text = "Table"
//                break
//            }
//        }
        
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