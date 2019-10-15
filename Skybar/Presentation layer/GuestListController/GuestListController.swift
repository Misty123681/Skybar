//
//  GuestListController.swift
//  Skybar
//
//  Created by Christopher Nassar on 1/6/19.
//  Copyright © 2019 Christopher Nassar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class GuestListController: ParentController {

    @IBOutlet weak var accessCodeLbl: UILabel!
    @IBOutlet weak var accessCodeShareBtn: UIButton!
    @IBOutlet weak var calendarIcon: UIImageView!
    @IBOutlet weak var container: UIScrollView!
    var event:NearestEventDetails! = nil
    @IBOutlet weak var doorOpenLbl: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var guestCountLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var guests:[GuestElement]!
    var eventID = ""
    var reservationCode = ""
    var shareAll = ""
    
    @IBAction func shareAccessCode(_ sender: Any) {
        shareAll = "\(dateLbl.text ?? "")\n \(titleLbl.text ?? "")\n\n Please Use: \(accessCodeLbl.text!)"
      //  let shareAll = ["Please Use \(accessCodeLbl.text!)"]
        let activityViewController = UIActivityViewController(activityItems: [shareAll] as [Any], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func populateGuests(){
        self.view.layoutIfNeeded()
        container.subviews.forEach({ $0.removeFromSuperview() })
        var y:CGFloat = 20
        
        let guestView:GuestView = GuestView.fromNib()
        guestView.frame = CGRect(x: 16, y: y, width: self.container.getWidth()-32, height: guestView.getHeight())
        guestView.innerView.isHidden = true
        guestView.parent = self
        guestView.eventId = eventID
        
        y += guestView.getHeight()+15
        self.container.addSubview(guestView)
        
        GlobalUI.showLoading(self.view)
        ServiceInterface.getStarGuests(eventID:eventID,handler: { (success, result) in
            GlobalUI.hideLoading()
            if success {
                do{
                    let guests = try JSONDecoder().decode(Guest.self, from: result as! Data)
                    self.guests = guests
                    guestView.guestCount = self.guests.count
                    OperationQueue.main.addOperation {
                        
                        for guest in guests{
                            let guestView:GuestView = GuestView.fromNib()
                            guestView.frame = CGRect(x: 16, y: y, width: self.container.getWidth()-32, height: guestView.getHeight())
                            guestView.setInfo(guest: guest, guestCount: self.guests.count, eventId: self.eventID, parent: self)
                            y += guestView.getHeight()+15
                            self.container.addSubview(guestView)
                        }
                        
                        let minHeight:CGFloat = 100
                        self.container.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: y+minHeight, right: 0)
                        
                        self.guestCountLbl.isHidden = (self.guests.count == 0)
                        self.guestCountLbl.text = "Guests(\(self.guests.count)/8)"
                        
                        self.accessCodeLbl.isHidden = self.guestCountLbl.isHidden
                        self.accessCodeShareBtn.isHidden = self.guestCountLbl.isHidden
                       
                    }
                    
                }
                catch let error{
                    print(error)
                }
            }else{
                if let res = result as? String{
                    GlobalUI.showMessage(title: "Error", message: res, cntrl: self)
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
        self.populateGuests()
        accessCodeLbl.text = "Access Code: \(reservationCode)"
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 100
        // Do any additional setup after loading the view.
    }
    
    func setInfo(){
        if let _ = self.event{
            calendarIcon.isHidden = false
            if let name = self.event.name{
                titleLbl.text = name
            }
            if let name = self.event.description{
               // descriptionLbl.text = name
            }
            
            
            doorOpenLbl.text = "Doors open at"
            if let door = self.event.doorOpen{
                doorOpenLbl.text! += door
            }
            if let key = self.event.eventImage{
                self.getImage(key:key)
            }
            if let eventDate = self.event.eventDate{
                if let date = Date(jsonDate: eventDate){
                    let formatter = DateFormatter()
                    // initially set the format based on your datepicker date / server String
                    formatter.dateFormat = "MMM dd, yyyy"
                    
                    let monthDayStr = formatter.string(from: date) // string purpose I add here
                    dateLbl.text = monthDayStr.uppercased()
                }
            }
        }else{
            calendarIcon.isHidden = true
        }
    }
    
    
    func getImage(key:String){
        self.loader.startAnimating()
        ServiceInterface.resizeImage(imageKey: key,width:Float(self.imageView.getWidth()),height:Float(self.imageView.getHeight()), handler: { (success, result) in
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
