//
//  EventView.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/3/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class EventView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var reserveLbl: UILabel!
    @IBOutlet weak var reserveIcon: UIImageView!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var reserveBtn: UIButton!
    
    var layerCorners:UIView! = nil
    var event:Event! = nil
    weak var controller:UIViewController! = nil
    var shareLink = ""
    var cacheArr = [NSCache<NSString, UIImage>]()
    var documentInteractionController:UIDocumentInteractionController!
    var shareAll =  ""
    var dateEvent:String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func shareAction(_ sender: Any) {
        if shareLink.isEmpty{
            if let name = self.event.name, let _ = self.event.description{
                if event.reservationInfo?.reservationAccessCode == "" || event.reservationInfo?.reservationAccessCode == nil{
                    shareAll = "\(dateEvent ?? "")\n \(name)"

                }else{
                    shareAll = "\(dateEvent ?? "")\n \(name)\n\n Please Use \(event.reservationInfo?.reservationAccessCode ?? "")"

                }
                let activityViewController = UIActivityViewController(activityItems: [shareAll] as [Any], applicationActivities: nil)
                controller.present(activityViewController, animated: true, completion: nil)
            }
        }else{
            let shareAll = [shareLink]
            let activityViewController = UIActivityViewController(activityItems: shareAll as [Any], applicationActivities: nil)
            controller.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func reserveAction(_ sender: Any) {
        if let controller = controller as? ReserveController{
            controller.selectEvent(info: event)
        }else if let controller = controller as? HomeController{
            controller.toEventController(event: event)
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
    
    func getShareLink(){
        ServiceInterface.getShareLink(eventID: event.id!) { (success, result) in
            if success{
                if let result = result as? String{
                    self.shareLink = result
                }
            }
        }
    }
    
    func setInfo(event:Event,controller:UIViewController,cnt:Int){
        
        self.controller = controller
        self.event = event

        getShareLink()
        titleLbl.text = self.event.name
        descriptionLbl.text = self.event.description
        let image = self.event.eventImage
            self.getImage(key:image ?? "",cnt:cnt)
        //}

        if let info = event.reservationInfo{
            if let typeName = info.reservationStatusTypeName{
                self.reserveLbl.text = typeName
            }
              self.lblShare.text = "Share"
            if let statusID = info.reservationStatusID{
    
                    switch statusID{
                    case 1://Processing||Submitted
                          let image = #imageLiteral(resourceName: "pendingIcon")
                        self.reserveLbl.textColor = UIColor.init(red: 255.0/255.0, green: 140.0/255.0, blue: 0.0/255.0, alpha: 1)
                        self.reserveIcon.image = image.maskWithColor(color: UIColor.init(red: 255.0/255.0, green: 140.0/255.0, blue: 0.0/255.0, alpha: 1))
                            break
                    case 4://Rejected||FullCapacity
                         let image = #imageLiteral(resourceName: "rejectedIcon")
                        self.reserveLbl.textColor = UIColor.init(red: 241.0/255.0, green: 50.0/255.0, blue: 67.0/255.0, alpha: 1)
                         self.reserveIcon.image = image.maskWithColor(color:UIColor.init(red: 241.0/255.0, green: 50.0/255.0, blue: 67.0/255.0, alpha: 1))
                        break
                    case 2://WalkinOnly||WaitList||Pending
                          let image = #imageLiteral(resourceName: "waiting-list")
                        self.reserveLbl.textColor = UIColor.init(red: 255.0/255.0, green: 140.0/255.0, blue: 0.0/255.0, alpha: 1)
                        self.reserveIcon.image = image.maskWithColor(color: UIColor.init(red: 255.0/255.0, green: 140.0/255.0, blue: 0.0/255.0, alpha: 1))
                        break
                    case 3://Confirmed||Approved
                        let image = #imageLiteral(resourceName: "approveIcon")
                        self.reserveIcon.image = image.maskWithColor(color:UIColor.init(red: 0.13, green: 0.64, blue: 0, alpha: 1))
                        self.reserveLbl.textColor = UIColor(red: 0.13, green: 0.64, blue: 0, alpha: 1)
                        self.lblShare.text = info.reservationAccessCode ?? ""
                        break
                    default:
                        self.reserveLbl.textColor = UIColor.init(red: 241.0/255.0, green: 50.0/255.0, blue: 67.0/255.0, alpha: 1)
                        break
                    }

            }
        }
        
        if let eventDate = self.event.eventDate{
            if let date = Date(jsonDate: eventDate){
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
                formatter.dateFormat = "MMM dd, yyyy"
                
                let monthDayStr = formatter.string(from: date) // string purpose I add here
                dateEvent = monthDayStr.uppercased()
            }
        }
        
        
        if let eventDate = self.event.eventDate{
            if let date = Date(jsonDate: eventDate){
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
                formatter.dateFormat = "MMM dd"
                
                let monthDayStr = formatter.string(from: date) // string purpose I add here
                monthLbl.text = monthDayStr.uppercased()
               
                formatter.dateFormat = "EEE"
                let dayStr = formatter.string(from: date) // string purpose I add here
                dayLbl.text = dayStr.uppercased()
            }
        }
    }
    
    
    fileprivate func getEventImage(_ key: String,cnt:Int) {
        self.loader.startAnimating()
        ServiceInterface.resizeImage(imageKey: key,width: Float(imageView.getWidth()),height: Float(imageView.getHeight()), handler: { (success, result) in
            OperationQueue.main.addOperation {
                self.loader.stopAnimating()
                if success {
                    if let data = result as? Data,let img = UIImage(data: data){
                        self.imageView.image = img
                        let imageCache = NSCache<NSString, UIImage>()
                        imageCache.setObject(img, forKey: key as NSString)
                        if let controller = self.controller as? HomeController{
                            if  controller.cacheEventImages.count == cnt{
                            }else{
                                 controller.cacheEventImages.append(imageCache)
                            }
                        }
                        if let controller = self.controller as? ReserveController{
                            controller.cacheEventImages.append(imageCache)
                        }
                    }
                }
            }
        })
    }
    
    
    // MARK:- check event image in cache
    func getImage(key:String,cnt:Int){

        if let controller = self.controller as? HomeController{
            self.cacheArr = controller.cacheEventImages
            if self.cacheArr.count == cnt{
                self.cacheArr.forEach { (cache) in
                    if let cachedImage = cache.object(forKey: key as NSString) {
                        self.imageView.image = cachedImage
                    }
                }
            }else{
                getEventImage(key, cnt: cnt)
            }
        }
        if let controller = self.controller as? ReserveController{
            self.cacheArr = controller.cacheEventImages
            if controller.filter == true{
                self.cacheArr.forEach { (cache) in
                    if let cachedImage = cache.object(forKey: key as NSString) {
                        self.imageView.image = cachedImage
                    }
                }
            }else{
                 getEventImage(key, cnt: cnt)
            }
            
        }
     
      
    }

}

