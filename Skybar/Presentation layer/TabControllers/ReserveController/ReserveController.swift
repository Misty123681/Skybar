//
//  ReserveController.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/3/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

enum ReservationStatus:Int{
    case Submitted = 1
    case Pending = 2
    case Approved = 3
    case Rejected = 4
}

class ReserveController: ParentController {

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var eventsContainer: UIScrollView!
    @IBOutlet weak var tableContainer: UIScrollView!
    var events:[Event]!
    var editEvent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEvents()
        ServiceInterface.setSeenReservationNotifications { (success, result) in
            
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func editChange(_ tf: UITextField) {
     
        if (tf.text?.isEmpty)!{
            if let events = events{
                populateEvents(events: events)
            }
        }else if let events = events{
            let searchedTxt = tf.text?.capitalized
            var filteredEvents = [Event]()
            for event in events{
                if let name = event.name,let description = event.description{
                    if (name.capitalized.contains(searchedTxt!)) {
                            filteredEvents.append(event)
                    }else{
                        if (description.capitalized.contains(searchedTxt!)){
                            filteredEvents.append(event)
                        }
                    }
                }
            }
            
            populateEvents(events: filteredEvents)
        }
    }
    
    func populateEvents(events:[Event]){
        self.view.layoutIfNeeded()
        eventsContainer.subviews.forEach({ $0.removeFromSuperview() })
        var i = 0
        var y:CGFloat = 0
        
        let width = eventsContainer.frame.size.width-20
        
        for event in events {
            let eventView:EventView = EventView.fromNib()
            self.view.layoutIfNeeded()
            eventView.frame = CGRect(x: 10, y: y, width: width, height: eventView.frame.size.height)
            i += 1
            y += (eventView.frame.size.height+20)
            eventView.setInfo(event: event, controller: self, cnt: events.count)

            eventsContainer.addSubview(eventView)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toEvent))
            eventView.addGestureRecognizer(tapGesture)
        }
        
        eventsContainer.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: y, right: 0)
    }
    
    func getEvents(){
        ServiceInterface.getCurrentEvents{ (success, result) in
            if let data = result as? Data{
                do{
                    let events = try JSONDecoder().decode([Event].self, from: data)
                    OperationQueue.main.addOperation({
                        self.events =  events
                        self.populateEvents(events:events)
                    })
                }
                catch{
                    
                }
            }
        }
    }
    
    func populateReservations(reservations:[Reservation]){
        self.view.layoutIfNeeded()
        tableContainer.subviews.forEach({ $0.removeFromSuperview() })
        var i = 0
        var x:CGFloat = 10
        
        let width = tableContainer.frame.size.width*0.7
        
        for reservation in reservations {
            let table:ReserveTableView = ReserveTableView.fromNib()
            self.view.layoutIfNeeded()
            table.frame = CGRect(x: x, y: 0, width: width, height: tableContainer.frame.size.height-10)
            i += 1
            table.center = CGPoint(x: table.center.x, y: tableContainer.frame.size.height/2)
            x += (table.frame.size.width+20)
            table.setInfo(reservation: reservation, parent: self)
            
            tableContainer.addSubview(table)
        }
        
        tableContainer.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: x)
    }
    
    func selectReservation(info:Reservation){
        
        /*if let reservationstatusID = info.reservationStatusID,let resStatus = ReservationStatus(rawValue: reservationstatusID){
            switch resStatus{
            case .Submitted,.Approved,.Pending,.Processing,.WalkinOnly, .WaitList, .Confirmed:
                let alert = UIAlertController(title: "Are you sure you want to Modify the Reservation?", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    self.editEvent = true
                    self.performSegue(withIdentifier: "toEvent", sender: info)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case .Rejected,.FullCapacity:
                self.editEvent = false
                self.performSegue(withIdentifier: "toEvent", sender: info)
                break
            }
        }*/
        
        if let reservationstatusID = info.reservationStatusID{
            switch reservationstatusID{
            case 1,2,3,4:
                let alert = UIAlertController(title: "Are you sure you want to Modify the Reservation?", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    self.editEvent = true
                    self.performSegue(withIdentifier: "toEvent", sender: info)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            
            default://Rejected
                self.editEvent = false
                self.performSegue(withIdentifier: "toEvent", sender: info)
                break
            }
        }
    }
    
    func selectEvent(info:Event){
        
        /*if let reservationstatusID = info.reservationInfo?.reservationStatusID,let resStatus = ReservationStatus(rawValue: reservationstatusID){
            switch resStatus{
            case .Submitted,.Approved,.Pending:
                let alert = UIAlertController(title: "Are you sure you want to Modify the Reservation?", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    self.editEvent = true
                    self.performSegue(withIdentifier: "toEvent", sender: info)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case .Rejected:
                self.editEvent = false
                self.performSegue(withIdentifier: "toEvent", sender: info)
                break
            }
        }else{
            self.editEvent = false
            self.performSegue(withIdentifier: "toEvent", sender: info)
        }*/
        
        if let reservationstatusID = info.reservationInfo?.reservationStatusID{
            switch reservationstatusID{
            case 1,2,3:
                let alert = UIAlertController(title: "Are you sure you want to Modify the Reservation?", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    self.editEvent = true
                    self.performSegue(withIdentifier: "toEvent", sender: info)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            default://Rejected
                self.editEvent = false
                self.performSegue(withIdentifier: "toEvent", sender: info)
                break
            }
        }else{
            self.editEvent = false
            self.performSegue(withIdentifier: "toEvent", sender: info)
        }
        
    }
    
    func getReservations(){
        ServiceInterface.getMyResevations{ (success, result) in
            if let data = result as? Data{
                do{
                    let reservations = try JSONDecoder().decode([Reservation].self, from: data)
                    OperationQueue.main.addOperation({
                        self.populateReservations(reservations:reservations)
                    })
                }
                catch let ex{
                    print(ex)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReservations()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{
            return .default
        }
    }
    
    @objc func toEvent(gesture:UIGestureRecognizer){
        if let eventView = gesture.view as? EventView,let info = eventView.event{
            selectEvent(info: info)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toEvent"){
            let eventCntrl = segue.destination as! EventController
            if let event = sender as? Event{
                eventCntrl.event = event
            }
            if let reservation = sender as? Reservation{
                eventCntrl.reservation = reservation
            }
            eventCntrl.editEvent = editEvent
        }
    }

}
