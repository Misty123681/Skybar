//
//  RatingViewController.swift
//  Skybar
//
//  Created by Suresh.Ch on 06/01/20.
//  Copyright © 2020 CSP SOLUTIONS. All rights reserved.
//

import UIKit
import Cosmos


class RatingViewController: UIViewController{
    var atmosphereRating = 0
    var serviceRating = 0
    var musicRating = 0
    var overAllRating = 0
    // MARK: outlets for VC
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var boomBoxLbl: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var rateexpLbl: UILabel!
    @IBOutlet weak var tellUsLbl: UILabel!
    @IBOutlet weak var atmosphereLbl: UILabel!
    @IBOutlet weak var serviceLbl: UILabel!
    @IBOutlet weak var musicLbl: UILabel!
    @IBOutlet weak var overAllLbl: UILabel!
    @IBOutlet weak var atmosphereCosmos: CosmosView!
    @IBOutlet weak var serviceCosmos: CosmosView!
    @IBOutlet weak var musicCosmos: CosmosView!
    @IBOutlet weak var overAllCosmos: CosmosView!
    // MARK: Calling delegate methods to return rating values
    override func viewDidLoad() {
        super.viewDidLoad()
        atmosphereCosmos.didFinishTouchingCosmos = didFinishAtmosphereTouchingCosmos
        serviceCosmos.didFinishTouchingCosmos = didFinishServiceTouchingCosmos
        musicCosmos.didFinishTouchingCosmos = didFinishMusicTouchingCosmos
        overAllCosmos.didFinishTouchingCosmos = didFinishOverAllTouchingCosmos
    }
    
    // MARK: VC life cycle methods
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    // MARK: Methods using in ViewController
    @IBAction func backButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
       
    }
    
     // MARK: submit action  API Integration
    @IBAction func submitButton(_ sender: UIButton) {
        
        print("=\(atmosphereRating)==\(serviceRating)===\(musicRating)====\(overAllRating)")

        GlobalUI.showLoading(self.view)
        ServiceInterface.submitUserRating( eventId: "", musicRatingValue: String(musicRating), ServiceRatingValue: String(serviceRating), AtmosphereRatingValue: String(atmosphereRating), OverallRatingValue: String(overAllRating), handler: { (success, result) in
            GlobalUI.hideLoading()
            if success {
                if let data = result as? Data{
                    if var code = String(data: data, encoding: String.Encoding.utf8){
                        code = code.replacingOccurrences(of: "\"", with: "")
                        if(!code.isEmpty){
                            GlobalUI.showMessage(title: "Rating", message: "rating of the event", cntrl: self)
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            GlobalUI.showMessage(title: "Error", message: "rating could not be sent", cntrl: self)
                        }
                    }
                }
            }else{
                if let res = result as? String{
                    GlobalUI.showMessage(title: "Error", message: res, cntrl: self)
                }
            }
        })
       
        
    }
    
    @IBAction func skipButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: Delegates methods for storing a rating values
    private func didFinishAtmosphereTouchingCosmos(_ rating: Double) {
        atmosphereRating = Int(Float(rating))
        debugPrint(atmosphereRating)
    }
    private func didFinishServiceTouchingCosmos(_ rating: Double) {
        serviceRating = Int(Float(rating))
        debugPrint(serviceRating)
    }
    private func didFinishMusicTouchingCosmos(_ rating: Double) {
        musicRating = Int(Float(rating))
        debugPrint(musicRating)
    }
    private func didFinishOverAllTouchingCosmos(_ rating: Double) {
        overAllRating = Int(Float(rating))
        debugPrint(overAllRating)
        
    }
    
}



    


