//
//  HomeController.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/31/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import Cosmos

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
        gradient.locations = [0, 1]
        gradient.cornerRadius = 8
        layer.layer.addSublayer(gradient)
        self.addSubview(layer)
        self.sendSubviewToBack(layer)
    }
}

class HomeController: ParentController,InstaDelegate,UIScrollViewDelegate {
    var atmosphererating = 0
    var servicerating = 0
    var musicrating = 0
    var overAllrating = 0
    
    //MARK:- Outlet
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
    @IBOutlet weak var fNameLbl: UILabel!
    @IBOutlet weak var takeMeLbl: UILabel!
    @IBOutlet weak var takeMeBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headerThree: UILabel!
    @IBOutlet weak var headerTwo: UILabel!
    @IBOutlet weak var UsePromoLabel: UILabel!
    @IBOutlet weak var headerOne: UILabel!
    @IBOutlet weak var eventsContainer: UIScrollView!
    @IBOutlet weak var containerView: UIScrollView! = nil
    @IBOutlet weak var guestListBadgeLbl: UILabel!
    @IBOutlet weak var refreshLoader: UIActivityIndicatorView!
    
    
    
    //MARK:- Variable
    var timer: Timer!
    var isAnimating = false
    var instaView:InstaView = InstaView.fromNib()
    var medias:[InstaMedia]! = nil
    var switchView:ViewSwitch = .view1
    var isAtSkybar:Bool = false
    var isOpen = true
    var bill:CurrentVisitInfo! = nil
    var careemMsg = ""
    var careemLinks:CareemLinks! = nil
    var skyStatus:SkyStatus! = nil
    var cacheEventImages = [NSCache<NSString, UIImage>]()
    var isedit = false
    var refreshControl: UIRefreshControl!
    var refreshInitialCenter:CGPoint!
    var dragGesture:UIPanGestureRecognizer!
    var guests:[GuestElement]!
    //var frameEvent = CGRect()
    
    //MARK:- View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intializationCode()
        getInstaMedia()
        ServiceUser.setLoggedIn()
        getResetvationNumber()
        getCareemLinks()
        // Register touch handlers
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        cacheEventImages = [NSCache<NSString, UIImage>]()
        getCurrentStatus()
        populateProfileInfo()
        reloadMedia()
        
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
    
    
    /// intialize the code
    fileprivate func intializationCode() {
        NotificationCenter.default.addObserver(self, selector: #selector(NetworkIssue), name: NSNotification.Name(rawValue: "NetworkIssue"), object: nil)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        self.scrollView.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.black
        self.scrollView.addSubview(refreshControl)
        self.view.layoutIfNeeded()
        self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2
        designPrivilegeBtn()
    }
    
    
    
    
    /// If network connection is off hide the loader
    @objc func NetworkIssue() {
        GlobalUI.hideLoading()
    }
    
    
    //MARK:- Function and method
    @IBAction func toReserve(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toReserve", sender: nil)
    }
    
    @IBAction func myGuestListAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toGuestList", sender: nil)
    }
    
    
    /// on instagram cell click open the full page
    ///
    /// - Parameters:
    ///   - media: media is of insta Object
    ///   - index: int index
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
            
            if UIApplication.shared.canOpenURL(URL(string: "careem:")!) {
                if let url = URL(string: urlString){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }else{
                GlobalUI.showMessage(title: "Careem app does not exist", message: "Please download Careem app", cntrl: self)
            }
        }
    }
    //MARK:- Get instagram feeds
    func getInstaMedia(){
        let instaToken = "7537546145.ed04f18.35e74d443a97432493ffc5e355782db0"
        ServiceInterface.getInstagramMedia(token: instaToken) { (success, result) in
            if success {
                do{
                    let medias = try JSONDecoder().decode(InstaMedias.self, from: result as! Data)
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
                reservationNotificationBadgeLbl.isHidden = true
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
        
        _ = self.headerTwo.intrinsicContentSize
        if let isFull = skyStatus.isFullCapacity{
            if isFull{
                self.headerTwo.textColor = UIColor.black
                self.headerTwo.font=UIFont(name:"SourceSansPro-Bold", size: 24)
            }else{
                _ = CIColor(color:UIColor(red: 69.0/255.0, green: 146.0/255.0, blue: 42.0/255.0, alpha: 1))
                _ = CIColor(color:UIColor(red: 188.0/255.0, green: 228.0/255.0, blue: 130.0/255.0, alpha: 1))
                
                self.headerTwo.textColor =  UIColor.black
                self.headerTwo.font=UIFont(name:"SourceSansPro-Bold", size: 24)
            }
        }
        let plz = "Please Use Promo Code "
        let promoCodeText = "KEYTOTHESKY "
        let destination = "\nDestination SKY2.0 For 100% cash back"
        
        let attrString = NSMutableAttributedString(string: plz,
                                                   attributes: [NSAttributedString.Key.font:
                                                    UIFont.init(name: "SourceSansPro-bold",size:16)!,NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]);
        
        
        attrString.append(NSMutableAttributedString(string: promoCodeText,
                                                    attributes: [NSAttributedString.Key.font:
                                                        UIFont.init(name: "SourceSansPro-bold",size:16)!,NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.foregroundColor:UIColor(red: 219/255, green: 166/255, blue: 26/255, alpha: 1.0)]));
        
        attrString.append(NSMutableAttributedString(string: destination,
                                                    attributes: [NSAttributedString.Key.font:
                                                        UIFont.init(name: "SourceSansPro-bold",size:16)!,NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]));
        
        UsePromoLabel.attributedText = attrString;
        
        if let isOpen = skyStatus.isOpen{
            
            self.isOpen = isOpen
            if !isOpen{
                redesignBtn(msg: skyStatus.rideDisabledMsg)
                self.headerTwo.textColor =  UIColor.black
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
            careemIcon.alpha =  1.0 //0.5
            takeMeBtn.alpha =  1.0 //0.5
        }
    }
    
    
    func populateEvents(events:[Event]){
        eventsContainer.delegate = self
        eventsContainer.subviews.forEach({ $0.removeFromSuperview() })
        /// show UI for open tab when isAtskybar = true
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
        eventsContainer.delegate = self
        let width = eventsContainer.frame.size.width*0.8
        for event in events {
            let eventView:EventView = EventView.fromNib()
            eventView.frame = CGRect(x: x, y: 0, width: width, height: eventsContainer.frame.size.height)
            i += 1
            x += (eventView.frame.size.width+20)
            eventView.setInfo(event: event, controller: self,cnt:events.count)
            
            eventsContainer.addSubview(eventView)
            
            //            if event.reservationInfo?.reservationStatusTypeName == "Confirmed"{
            //                frameEvent = eventView.frame
            //            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toEvent))
            eventView.addGestureRecognizer(tapGesture)
        }
        
        eventsContainer.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: x)
        //scrollToPage(0)
        
    }
    
    
    /// pop up user info
    func populateProfileInfo(){
        if let profile = ServiceUser.profile{
            fNameLbl.text = profile.firstName+" "+profile.lastName
            memberLbl.text = "STAR \(String(format: "%04d", profile.starMembershipSeed))"
            getImage()
            let mobile = UserDefaults.standard.value(forKey: "mobile")
            if mobile == nil {
                ServiceUser.setTypeLevel(level: ServiceUser.profile?.level ?? "" )
                ServiceUser.setProfileId(Id: ServiceUser.profile?.id ?? "")
                ServiceUser.setProfile(profile: ServiceUser.profile)
            }
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
                        self.endOfWork()
                        Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: { (timer) in
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
    
    // MARK:- scroll view method  called on ref
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            if !isAnimating {
                doSomething()
            }
        }
    }
    
    func doSomething() {
        self.refreshAllData()
    }
    
    
    func refreshAllData(){
        getInstaMedia()
        ServiceInterface.getCurrentSkyStatus { (success, result) in
            if let data = result as? Data{
                do{
                    self.skyStatus = try JSONDecoder().decode(SkyStatus.self, from: data)
                    OperationQueue.main.addOperation({
                        
                        self.populateHeaders()
                        self.getCurrentEvents()
                        self.endOfWork()
                    })
                }
                catch let ex{
                    print(ex)
                }
            }
        }
    }
    
    @objc func endOfWork() {
        refreshControl.endRefreshing()
        isAnimating = false
    }
    
    
    @objc func appMovedToForeground() {
        self.cacheEventImages = [NSCache<NSString, UIImage>]()
    }
    
    
    func designPrivilegeBtn(){
        privilegeBtn.layer.cornerRadius = 8
        privilegeBtn.backgroundColor = UIColor.black
    }
    
    
    
    func scrollToPage(_ page: Int) {
        UIView.animate(withDuration: 0.5) {
            // self.eventsContainer.contentOffset.x = self.frameEvent.width + 20 * CGFloat(page)
        }
    }
    
    @objc func toEvent(gesture:UITapGestureRecognizer){
        if let eventView = gesture.view as? EventView{
            self.toEventController(event: eventView.event)
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
    
    
    /// reload insta feeds
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
                    if let eventID = self.skyStatus?.nearestEventDetails?.id{
                        dest.eventID = eventID
                    }
                    
                    if let info = self.skyStatus?.nearestEventDetails{
                        dest.event = info
                    }
                    
                    if let code = self.skyStatus?.nearestEventDetails?.reservationInfo?.reservationAccessCode{
                        dest.reservationCode = code
                    }
                    
                }else if segue.identifier == "toInvoice"{
                    if let status = skyStatus,let cntrl = segue.destination as? InvoiceController{
                        cntrl.status = status
                    }
        }
    }
    
    /// refresh the events after push notifiaction Tapped
    func refreshEventData(){
        self.cacheEventImages = [NSCache<NSString, UIImage>]()
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
}


// MARK: - notification related notifiaction
extension HomeController:HomePage{
   
    
    func homeNotification(screenID: String,info: RateUsInfo?) {
        if screenID == "RateUsScreen"{
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let ratingVC = storyboard.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
            ratingVC.rateInfo = info
            
            ratingVC.modalPresentationStyle = .fullScreen
            self.present(ratingVC, animated: false, completion: nil)
            
        }else{
            refreshEventData()
        }
        
    }
    
}
