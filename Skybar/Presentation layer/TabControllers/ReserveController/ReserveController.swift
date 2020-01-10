//
//  ReserveController.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/3/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
/**
 enum for event reservation status
 
 #  important  #
   - 1 for submitted
   - 2 pending the request
   - 3 Approved the request
   - 4 Approved
 */

enum ReservationStatus:Int{
    case Submitted = 1
    case Pending = 2
    case Approved = 3
    case Rejected = 4
}

class ReserveController: ParentController {
    
    // MARK:- Outlets
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var eventsContainer: UIScrollView!
    @IBOutlet weak var tableContainer: UIScrollView!
    
     // MARK:- Variables
    var cacheEventImages = [NSCache<NSString, UIImage>]()
    var events:[Event]!
    var editEvent = false
    var filter = false
    
     // MARK:- view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cacheEventImages = [NSCache<NSString, UIImage>]() // cleae cache for event images
        getReservations()
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{return .default}
    }
    
     // MARK:- Functions and IBoutlets
    
    /// search functionlity for events
    ///
    /// - Parameter tf: input as txtfield
    @IBAction func editChange(_ tf: UITextField) {
     
        if (tf.text?.isEmpty)!{
            if let events = events{
                populateEvents(events: events)
            }
        }else if let events = events{
            filter = true
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
    
    
    /// get all current event list
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
    
    
    
    /// get all upcoming reservation list
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
    
 
    /// Tap on one of the upcoming event for modification
    @objc func toEvent(gesture:UIGestureRecognizer){
        if let eventView = gesture.view as? EventView,let info = eventView.event{
            selectEvent(info: info)
        }
    }
    
    
    func selectEvent(info:Event){
        
        if let reservationstatusID = info.reservationInfo?.reservationStatusID{
            switch reservationstatusID{
            case 1,2,3,4: // asking for modification
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
    

    /// segue method called before perform the segue
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
