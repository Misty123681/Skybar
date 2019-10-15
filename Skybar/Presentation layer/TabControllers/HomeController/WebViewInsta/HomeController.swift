//
//  HomeController.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/31/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

enum ViewSwitch {
    case view1
    case view2
}

class StartPrivilegeView:UIView{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let layer = UIView(frame: self.bounds)
        layer.layer.cornerRadius = 8
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.black]
            //[
           // UIColor(red:0, green:0.64, blue:0.95, alpha:1).cgColor,
           // UIColor(red:0.04, green:0.22, blue:0.61, alpha:1).cgColor
        //]
        gradient.locations = [0, 1]
        //gradient.startPoint = CGPoint(x: 1, y: 0.2)
        //gradient.endPoint = CGPoint(x: 0.3, y: 0.67)
        gradient.cornerRadius = 8
        layer.layer.addSublayer(gradient)
        
        self.addSubview(layer)
        self.sendSubviewToBack(layer)
    }
}

class HomeController: ParentController,InstaDelegate {
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var privilegeBtn: UIButton!
    @IBOutlet weak var reservationNotificationBadgeLbl: UILabel!
    @IBOutlet weak var dummyTableView: UITableView!
    @IBOutlet weak var guestListImg: UIImageView!
    @IBOutlet weak var guestLisLbl: UILabel!
    @IBOutlet weak var careemIcon: UIImageView!
    @IBOutlet weak var memberLbl: UILabel!
    @IBOutlet weak var instaTitleLbl: UILabel!
    @IBOutlet weak var startPrivilegesLbl: UILabel!
    //@IBOutlet weak var consumptionLbl: UILabel!
    @IBOutlet weak var fNameLbl: UILabel!
    @IBOutlet weak var takeMeLbl: UILabel!
    @IBOutlet weak var takeMeBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headerThree: UILabel!
    @IBOutlet weak var headerTwo: UILabel!
    @IBOutlet weak var UsePromoLabel: UILabel!
    @IBOutlet weak var headerOne: UILabel!
    var instaView:InstaView = InstaView.fromNib()
    @IBOutlet weak var eventsContainer: UIScrollView!
    @IBOutlet weak var containerView: UIScrollView! = nil
    var medias:[InstaMedia]! = nil
    var switchView:ViewSwitch = .view1
    var isAtSkybar:Bool = false
    var isOpen = true
    var bill:CurrentVisitInfo! = nil
    var careemMsg = ""
    let skybarLongitude = 55.297141
    let skybarLatitude = 25.190911
    var careemLinks:CareemLinks! = nil
    var skyStatus:SkyStatus! = nil
    var cacheEventImages = [NSCache<NSString, UIImage>]()
    var isedit = false
    
  

    
    @IBOutlet weak var guestListBadgeLbl: UILabel!
    
    var refreshInitialCenter:CGPoint!
    @IBOutlet weak var refreshLoader: UIActivityIndicatorView!
    var dragGesture:UIPanGestureRecognizer!
    var guests:[GuestElement]!
    
    @IBAction func toReserve(_ sender: Any) {
        self.performSegue(withIdentifier: "toReserve", sender: nil)
    }
    
    @IBAction func myGuestListAction(_ sender: Any) {
        
       // if isAtSkybar{
            self.performSegue(withIdentifier: "toGuestList", sender: nil)
      //  }else{
        //    let alert = UIAlertController(title: "Guest List", message: "Only works on the day of the event", preferredStyle: .alert)
         //   alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         //   self.present(alert, animated: true, completion: nil)
       // }
        
    }
    func openMedia(media: InstaMedia,index:Int) {
        self.view.layoutIfNeeded()
        instaView.frame = self.view.bounds
        instaView.setIndex(index: index)
        self.view.addSubview(instaView)
    }
    
    func closeMedia(media: InstaMedia) {
        instaView.removeFromSuperview()
    }
    
    func openFullScreen(media: InstaMedia) {
        if let image = media.images{
            self.performSegue(withIdentifier: "fullScreen", sender: image.standardResolution.url)
        }
    }
    
    @IBAction func takemetoskyAction(_ sender: Any) {
        
        if !self.isOpen{
            careemMsg = "Please use SKY2.0 Dubai as destination when you want to visit SKY2.0 and use KEYTOTHESKY as promo code in your Careem App for 100% cash back."
            GlobalUI.showMessage(title: "", message: careemMsg, cntrl: self)
            return
        }
        
        var urlString = ""
        
        if let careemObj = careemLinks{
            if isAtSkybar{
                urlString = careemObj.careemTakeMeHomeURL
            }else{
                urlString = careemObj.careemTakeMeHomeURL
            }
            
            //urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            if UIApplication.shared.canOpenURL(URL(string: "careem:")!) {
                if let url = URL(string: urlString){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }else{
                GlobalUI.showMessage(title: "Careem app does not exist", message: "Please download Careem app", cntrl: self)
            }
        }
    }
    func getInstaMedia(){
        let instaToken = "7537546145.ed04f18.35e74d443a97432493ffc5e355782db0"
        ServiceInterface.getInstagramMedia(token: instaToken) { (success, result) in
            if success {
                do{
                    let medias = try JSONDecoder().decode(InstaMedias.self, from: result as! Data)
                    print(medias)
                    self.medias = medias.data
                    OperationQueue.main.addOperation {
                        self.instaView.setConfig(arr: self.medias, parent: self)
                        OperationQueue.main.addOperation({
                            self.reloadMedia()
                        })
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
        }
    }
    
    func populateHeaders(){
        
        if let reservationNotificationsCount = skyStatus.totalReservationNotifications{
            if reservationNotificationsCount > 0 {
                reservationNotificationBadgeLbl.isHidden = false
                if reservationNotificationsCount >= 10{
                    reservationNotificationBadgeLbl.text = "9+"
                }else{
                    reservationNotificationBadgeLbl.text = "\(reservationNotificationsCount)"
                }
            }
        }
        
        if let guestNotificationsCount = skyStatus.totalGuestsInVenueNotifications{
            if guestNotificationsCount > 0 {
                reservationNotificationBadgeLbl.isHidden = false
                if guestNotificationsCount >= 10{
                    guestListBadgeLbl.text = "9+"
                }else{
                    guestListBadgeLbl.text = "\(guestNotificationsCount)"
                }
            }
        }
        
        if let headerOne = skyStatus.headingOne{
            self.headerOne.text = headerOne
        }
        
        if let headerTwo = skyStatus.headingTwo{
            self.headerTwo.text = headerTwo
        }

        self.bill = skyStatus.currentVisitInfo
        
        let size = self.headerTwo.intrinsicContentSize
        if let isFull = skyStatus.isFullCapacity{
            if isFull{
                //let color1 = CIColor(color:UIColor(red: 248.0/255.0, green: 166.0/255.0, blue: 95.0/255.0, alpha: 1))
               // let color2 = CIColor(color:UIColor(red: 245.0/255.0, green: 109.0/255.0, blue: 47.0/255.0, alpha: 1))
                //if let uiimage = GlobalUI.gradientImage(size: size, color1: color1, color2: color2){
                    self.headerTwo.textColor = UIColor.black
                    self.headerTwo.font=UIFont(name:"SourceSansPro-Bold", size: 24)
                    
               // }
            }else{
                let color1 = CIColor(color:UIColor(red: 69.0/255.0, green: 146.0/255.0, blue: 42.0/255.0, alpha: 1))
                let color2 = CIColor(color:UIColor(red: 188.0/255.0, green: 228.0/255.0, blue: 130.0/255.0, alpha: 1))
               // if let uiimage = GlobalUI.gradientImage(size: size, color1: color1, color2: color2){
                    self.headerTwo.textColor =  UIColor.black
                    self.headerTwo.font=UIFont(name:"SourceSansPro-Bold", size: 24)
                    
                //}
            }
        }
        let plz = "Please Use Promo Code "
        let promoCodeText = "KEYTOTHESKY "
        let destination = "\nDestination SKY2.0 For Free Rides"
        
        let attrString = NSMutableAttributedString(string: plz,
                                                   attributes: [NSAttributedString.Key.font:
                                                    UIFont.init(name: "SourceSansPro-bold",size:16)!,NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]);
        
        
        attrString.append(NSMutableAttributedString(string: promoCodeText,
                                                    attributes: [NSAttributedString.Key.font:
                                                        UIFont.init(name: "SourceSansPro-bold",size:16)!,NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.foregroundColor:UIColor.gray]));
        
        attrString.append(NSMutableAttributedString(string: destination,
                                                    attributes: [NSAttributedString.Key.font:
UIFont.init(name: "SourceSansPro-bold",size:16)!,NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]));
   
        UsePromoLabel.attributedText = attrString;
       // UsePromoLabel.sizeToFit() ;
        if let isOpen = skyStatus.isOpen{
            
            self.isOpen = isOpen
            if !isOpen{
                redesignBtn(msg: skyStatus.rideDisabledMsg)
                let color1 = CIColor(color:UIColor(red: 16.0/255.0, green: 60.0/255.0, blue: 153.0/255.0, alpha: 1))
                let color2 = CIColor(color:UIColor(red: 25.0/255.0, green: 146.0/255.0, blue: 224.0/255.0, alpha: 1))
               // if let uiimage = GlobalUI.gradientImage(size: size, color1: color1, color2: color2){
                    self.headerTwo.textColor =  UIColor.black
               // }
                
                instaTitleLbl.text = "We Party Legendary"
                
                
            }else{
                instaTitleLbl.text = "We party legendary"
            }
        }
        
        if let isAtSkybar = skyStatus.isAtSkybar{
            self.isAtSkybar = isAtSkybar
            
            if isAtSkybar{
                
//                if let consumption = skyStatus{
//                    consumptionLbl.text = "Current consumption: \(consumption.toCurrencyNoPrefix())"
//                }
//
                takeMeBtn.setTitle("TAKE ME HOME", for: .normal)
            }else{
                takeMeBtn.setTitle("TAKE ME TO SKY 2.0", for: .normal)
            }
        }
    }
    
    func redesignBtn(msg:String?){
        careemIcon.isHidden = false
        if let msg = msg{
            careemMsg = msg
            careemIcon.alpha = 0.5
            takeMeBtn.alpha = 0.5
        }
    }
    
    
    func populateEvents(events:[Event]){
        eventsContainer.subviews.forEach({ $0.removeFromSuperview() })

        if isAtSkybar{
            self.view.layoutIfNeeded()
            let width = eventsContainer.frame.size.width-20
            let billView:BillView = BillView.fromNib()
            billView.frame = CGRect(x: 0, y: 0, width: width, height: eventsContainer.getHeight()-5)
            if let bill = self.bill{
                billView.setInfo(bill: bill, eventDate: self.skyStatus.nearestEventDetails?.eventDate, discount: Float(self.skyStatus?.discount ?? 0), controller: self)
            }
            
            eventsContainer.addSubview(billView)
            guestLisLbl.alpha = 1
            guestListImg.alpha = 1
            guestListBadgeLbl.alpha = 1
            return
        }
        
        var i = 0
        var x:CGFloat = 0
        self.view.layoutIfNeeded()
        let width = eventsContainer.frame.size.width*0.8
        for event in events {
            let eventView:EventView = EventView.fromNib()
            eventView.frame = CGRect(x: x, y: 0, width: width, height: eventsContainer.frame.size.height)
            i += 1
            x += (eventView.frame.size.width+20)
            eventView.setInfo(event: event, controller: self,cnt:events.count)

            eventsContainer.addSubview(eventView)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toEvent))
            eventView.addGestureRecognizer(tapGesture)
        }
        
        eventsContainer.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: x)
    }
    
    func populateProfileInfo(){
        if let profile = ServiceUser.profile{
            fNameLbl.text = profile.firstName+" "+profile.lastName
            memberLbl.text = "STAR \(String(format: "%04d", profile.starMembershipSeed))"
            getImage()
        }else{
            getProfileInfo()
        }
    }
    
    func getProfileInfo(){
        self.view.layoutIfNeeded()
        GlobalUI.showLoading(self.view)
        
        ServiceInterface.getUserProfileInfo(handler: { (success, result) in
            GlobalUI.hideLoading()
            if success {
                do{
                    let profile = try JSONDecoder().decode(ProfileObject.self, from: result as! Data)
                    ServiceUser.profile = profile
                    OperationQueue.main.addOperation {
                        self.populateProfileInfo()
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
    
    func getImage(){
        if let profile = ServiceUser.profile{
                ServiceInterface.getImage(imageName: "\(profile.id).jpg", handler: { (success, result) in
                
                if success {
                    if let data = result as? Data{
                        OperationQueue.main.addOperation {
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                }else{
                    if let res = result as? String{
                        GlobalUI.showMessage(title: "Error", message: res, cntrl: self)
                    }
                }
            })
        }
    }
    
    func getCurrentStatus(){
        ServiceInterface.getCurrentSkyStatus { (success, result) in
            if let data = result as? Data{
                
                do{
                    self.skyStatus = try JSONDecoder().decode(SkyStatus.self, from: data)
                    OperationQueue.main.addOperation({
                        //self.snap()
                        //self.dragGesture.isEnabled = true
                        self.populateHeaders()
                        self.getCurrentEvents()
                        Timer.scheduledTimer(withTimeInterval: 20, repeats: false, block: { (timer) in
                            self.getCurrentStatus()
                        })
                    })
                }
                catch let ex{
                    print(ex)
                }
            }
        }
    }
    
    func getCurrentEvents(){
        ServiceInterface.getCurrentEvents { (success, result) in
            if let data = result as? Data{
                do{
                    let events = try JSONDecoder().decode([Event].self, from: data)
                    OperationQueue.main.addOperation({
                        self.populateEvents(events:events)
                    })
                }
                catch let ex{
                    print(ex)
                }
            }
        }
    
    }
    
    func getResetvationNumber(){
        self.view.layoutIfNeeded()
        
        ServiceInterface.getReservationNumber(handler: { (success, result) in
            if success {
                if let result = result as? Data{
                    if let number = String(data: result, encoding: String.Encoding.utf8){
                        ServiceUser.storeContactNumber(mobile: number)
                    }
                }
            }else{
                
            }
        })
    }
    
    func getCareemLinks(){
        ServiceInterface.getCareemLinks { (success, result) in
            if success{
                do{
                    self.careemLinks = try JSONDecoder().decode(CareemLinks.self, from: result as! Data)
                }
                catch let error{
                    print(error)
                }
            }else{
                if let res = result as? String{
                    GlobalUI.showMessage(title: "Error", message: res, cntrl: self)
                }
            }
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    
        getInstaMedia()
        ServiceUser.setLoggedIn()
        // Do any additional setup after loading the view.
        getResetvationNumber()
     
        getCareemLinks()
        
        self.view.layoutIfNeeded()
        self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2
        
      //  dragGesture = UIPanGestureRecognizer(target: self, action: #selector(refreshGesture))
       // self.view.addGestureRecognizer(dragGesture)
        
        designPrivilegeBtn()
    }
    
    @objc func appMovedToForeground() {
      self.cacheEventImages = [NSCache<NSString, UIImage>]()
    }
    
    
    func designPrivilegeBtn(){
   
        privilegeBtn.layer.cornerRadius = 8
        privilegeBtn.backgroundColor = UIColor.black
    }
    
    func snap(){
        dragGesture.isEnabled = false
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.getWidth(), height: self.view.getHeight())
        }, completion:{ finished in
            self.dragGesture.isEnabled = true
        })
    }
    
    func refresh(){
       self.getCurrentStatus()
    }
    
    @objc func refreshGesture(gestureRecognizer:UIPanGestureRecognizer){
        let translation = gestureRecognizer.translation(in: self.view)
        let velocity = gestureRecognizer.velocity(in: self.view)
        let threshold:CGFloat = 100
        
        if(velocity.y<0 || self.view.frame.origin.y>=threshold){
            return
        }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            // note: 'view' is optional and need to be unwrapped
            
            self.view.center = CGPoint(x: self.view.center.x, y: self.view.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
            
            if self.view.frame.origin.y>=threshold {
                refresh()
            }
        }else{
            if self.view.frame.origin.y>=threshold {
                refresh()
            }else{
                snap()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.cacheEventImages = [NSCache<NSString, UIImage>]()
        getCurrentStatus()
        self.populateProfileInfo()
        self.reloadMedia()
        
        takeMeBtn.backgroundColor = .white
        takeMeBtn.layer.borderWidth = 2
        takeMeBtn.layer.borderColor = UIColor(red: 0.22, green: 0.71, blue: 0.31, alpha: 1).cgColor
        takeMeBtn.setTitleColor(UIColor(red: 0.22, green: 0.71, blue: 0.31, alpha: 1), for: .normal)
        
        self.view.layoutIfNeeded()
        refreshInitialCenter = refreshLoader!.center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for view in self.view.subviews{
            view.tag = Int(view.center.y)
        }
    }
    
   
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    
  
    @objc func toEvent(gesture:UITapGestureRecognizer){
        
        if let eventView = gesture.view as? EventView{
            if eventView.event.reservationInfo?.reservationStatusID == 1 ||  eventView.event.reservationInfo?.reservationStatusID == 3 || eventView.event.reservationInfo?.reservationStatusID == 4 || eventView.event.reservationInfo?.reservationStatusID == 2{
                let alert = UIAlertController(title: "Are you sure you want to Modify the Reservation?", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                     self.isedit = true
                     self.toEventController(event: eventView.event)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
              
            }else{
                 isedit =  false
                self.toEventController(event: eventView.event)
            }
           
        }
    }
    
    func toEventController(event:Event){
        
        
        if let reservationstatusID = event.reservationInfo?.reservationStatusID{
            switch reservationstatusID{
            case 1,2,3,4:
                let alert = UIAlertController(title: "Are you sure you want to Modify the Reservation?", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    self.isedit = true
                    self.performSegue(withIdentifier: "toEvent", sender: event)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            default://Rejected
                self.isedit = false
                self.performSegue(withIdentifier: "toEvent", sender: event)
                break
            }
        }else{
            self.isedit = false
            self.performSegue(withIdentifier: "toEvent", sender: event)
        }
        

    }
    
    func reloadMedia(){
        
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        if let _ = medias{
        }else{
            return
        }
        self.view.layoutIfNeeded()
        var x:CGFloat = 0
        let height = containerView.frame.size.height
        let width = height

        for (index,media) in medias.enumerated(){
            let view:InstaPhoto = InstaPhoto.fromNib()
            view.frame = CGRect(x: x, y: 0, width: width, height: height)
            view.setInfo(media,parent: self)
            view.tag = index
            containerView.addSubview(view)
            
             x += width + 5
        }
        
        containerView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: x)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEvent"{
            let dest = segue.destination as! EventController
            if let event = sender as? Event{
                dest.event = event
                dest.editEvent = isedit
            }
        }else
        if segue.identifier == "fullScreen"{
            let dest = segue.destination as! FullscreenController
            if let url = sender as? String{
                dest.url = url
            }
        }else
            if segue.identifier == "toGuestList"{
                let dest = segue.destination as! GuestListController
                dest.guests = self.guests
                if let eventID = self.skyStatus.nearestEventDetails?.id{
                    dest.eventID = eventID
                }
                
                if let info = self.skyStatus.nearestEventDetails{
                    dest.event = info
                }
                
                if let code = self.skyStatus.nearestEventDetails?.reservationInfo?.reservationAccessCode{
                    dest.reservationCode = code
                }
                
            }else if segue.identifier == "toInvoice"{
                if let status = skyStatus,let cntrl = segue.destination as? InvoiceController{
                    cntrl.status = status
                }
        }
    }
    

}
