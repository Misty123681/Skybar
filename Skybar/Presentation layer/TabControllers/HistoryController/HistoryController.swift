//
//  HistoryController.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/6/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

enum TimelineType:Int {
    case visit = 1
    case reservation = 2
    case notification = 3
}

class HistoryController: ParentController {
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var container: UIScrollView!
    
    var statsView:StatsView = StatsView.fromNib()
    
    func populateChart(json:[Any]){
        addStatsView()
        statsView.populateInfo(info: json)
    }
    
    func getChart(){
        loader.startAnimating()
        ServiceInterface.getVisitsCharts { (success, result) in
            OperationQueue.main.addOperation({
                self.loader.stopAnimating()
            })
            
            if let data = result as? Data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
                    print(json!)
                    OperationQueue.main.addOperation({
                        self.populateChart(json:json!)
                    })
                }
                catch{
                    
                }
            }
        }
    }
    
    func addStatsView(){
        self.view.layoutIfNeeded()
        statsView.frame = CGRect(x: 0, y: 10, width: container.frame.size.width, height: statsView.frame.size.height)
        container.addSubview(statsView)
    }
    
    func populateTimeline(timeline:Timeline){

        self.view.layoutIfNeeded()
        
        var y:CGFloat = statsView.frame.size.height+20
        
        for single in timeline{
            
            switch TimelineType(rawValue: single.timelineItemType)!{
            case .visit:
                if let visit = single.visit{
                    let historyView:HistoryView = HistoryView.fromNib()
                    historyView.frame = CGRect(x: 0, y: y, width: container.frame.size.width, height: historyView.frame.size.height)
                    y += (historyView.frame.size.height+20)
                    historyView.setInfo(visit: visit)
                    container.addSubview(historyView)
                    
//                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toInvoice))
//                    historyView.addGestureRecognizer(tapGesture)
                }
                break
            case .reservation:
                if let reservation = single.reservation{
                    let reservationView:LastReservationView = LastReservationView.fromNib()
                    reservationView.frame = CGRect(x: 0, y: y, width: container.frame.size.width, height: reservationView.frame.size.height)
                    y += (reservationView.frame.size.height+20)
                    reservationView.setInfo(reservation: reservation)
                    container.addSubview(reservationView)
                }
                break
            case .notification:
                if let notification = single.notification{
                    let notificationView:NotificationView = NotificationView.fromNib()
                    notificationView.frame = CGRect(x: 0, y: y, width: container.frame.size.width, height: notificationView.frame.size.height)
                    y += (notificationView.frame.size.height+20)
                    notificationView.setInfo(notification: notification)
                    container.addSubview(notificationView)
                }
                break
            }
            
        }
        
        container.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: y, right: 0)
    }
    
    func getTimeline(){
        loader.startAnimating()
        ServiceInterface.getTimelineInfo{ (success, result) in
            OperationQueue.main.addOperation({
                self.loader.stopAnimating()
            })
            if success {
                do{
                    let timeline = try JSONDecoder().decode(Timeline.self, from: result as! Data)
                    print(timeline)
                    OperationQueue.main.addOperation {
                        self.populateTimeline(timeline: timeline)
                    }
                }
                catch let error {
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
        getChart()
        getTimeline()
        
        if let profile = ServiceUser.profile{
            titleLbl.text =  "Your Summary"
                //profile.level+" Summary"
            descriptionLbl.text = "Thank you for being a great \(profile.level)"
        }
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
//        let layer = UIView(frame: statsView.bounds)
//        layer.layer.cornerRadius = 13
//        layer.backgroundColor = UIColor.white
//        layer.layer.shadowOffset = CGSize.zero
//        layer.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.11).cgColor
//        layer.layer.shadowOpacity = 1
//        layer.layer.shadowRadius = 10
//        self.statsView.addSubview(layer)
//        self.statsView.sendSubview(toBack: layer)
    }
    
    @objc func toInvoice(gestureRecognizer:UIGestureRecognizer){
        self.performSegue(withIdentifier: "toInvoice", sender: gestureRecognizer.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInvoice"{
            if let view = sender as? HistoryView,let cntrl = segue.destination as? InvoiceController{
                cntrl.visitObj = view.visit
            }
        }
    }
    

}
