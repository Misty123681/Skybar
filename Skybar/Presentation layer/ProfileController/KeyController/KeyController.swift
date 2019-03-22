//
//  KeyController.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/3/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

extension MKMapView {
    var MERCATOR_OFFSET : Double {
        return 268435456.0
    }
    
    var MERCATOR_RADIUS : Double  {
        return 85445659.44705395
    }
    
    private func longitudeToPixelSpaceX(longitude: Double) -> Double {
        return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0)
    }
    
    private func latitudeToPixelSpaceY(latitude: Double) -> Double {
        return round(MERCATOR_OFFSET - MERCATOR_RADIUS * log((1 + sin(latitude * M_PI / 180.0)) / (1 - sin(latitude * M_PI / 180.0))) / 2.0)
    }
    
    private  func pixelSpaceXToLongitude(pixelX: Double) -> Double {
        return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
    }
    
    private func pixelSpaceYToLatitude(pixelY: Double) -> Double {
        return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
    }
    
    private func coordinateSpan(withMapView mapView: MKMapView, centerCoordinate: CLLocationCoordinate2D, zoomLevel: UInt) ->MKCoordinateSpan {
        let centerPixelX = longitudeToPixelSpaceX(longitude: centerCoordinate.longitude)
        let centerPixelY = latitudeToPixelSpaceY(latitude: centerCoordinate.latitude)
        
        let zoomExponent = Double(20 - zoomLevel)
        let zoomScale = pow(2.0, zoomExponent)
        
        let mapSizeInPixels = mapView.bounds.size
        let scaledMapWidth =  Double(mapSizeInPixels.width) * zoomScale
        let scaledMapHeight = Double(mapSizeInPixels.height) * zoomScale
        
        let topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
        let topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
        
        //    // find delta between left and right longitudes
        let minLng = pixelSpaceXToLongitude(pixelX: topLeftPixelX)
        let maxLng = pixelSpaceXToLongitude(pixelX: topLeftPixelX + scaledMapWidth)
        let longitudeDelta = maxLng - minLng;
        
        let minLat = pixelSpaceYToLatitude(pixelY: topLeftPixelY)
        let maxLat = pixelSpaceYToLatitude(pixelY: topLeftPixelY + scaledMapHeight)
        let latitudeDelta = -1 * (maxLat - minLat);
        
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        return span
    }
    
    func zoom(toCenterCoordinate centerCoordinate:CLLocationCoordinate2D ,zoomLevel: UInt) {
        let zoomLevel = min(zoomLevel, 20)
        let span = self.coordinateSpan(withMapView: self, centerCoordinate: centerCoordinate, zoomLevel: zoomLevel)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        self.setRegion(region, animated: true)
        
    }
}

class KeyController: ParentController,CLLocationManagerDelegate {
    var locationManager:CLLocationManager! = nil
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLbl: UILabel!
    var latitude = 24.428527
    var longitude = 54.6471921
    var annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let profile = ServiceUser.profile{
            addressLbl.text = profile.address
        }
        
        self.view.layoutIfNeeded()
        let layer = UIView(frame: mapView.frame)
        layer.backgroundColor = .white
        layer.layer.cornerRadius = 3
        //layer.layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.35).cgColor
        layer.layer.shadowOpacity = 1
        layer.layer.shadowRadius = 12
        layer.layer.masksToBounds = false
        mapView.superview!.addSubview(layer)
        mapView.superview!.sendSubviewToBack(layer)
        
        if let coordinate = ServiceUser.location{
            latitude = coordinate.latitude
            longitude = coordinate.longitude
        }else{
            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
        }
        
        addPin()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation :CLLocation = locations.first{
            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")
            locationManager.stopUpdatingLocation()
            
            latitude = userLocation.coordinate.latitude
            longitude = userLocation.coordinate.longitude
            
            addPin()
            ServiceInterface.setAddressLocation(longitude: userLocation.coordinate.longitude, latitude: userLocation.coordinate.latitude) { (success, result) in
            }
        }
    }
    
    func addPin(){
        mapView.removeAnnotations(mapView.annotations)
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(annotation)
        
        let defaultCoord = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.zoom(toCenterCoordinate: defaultCoord, zoomLevel: 15)
    }

    @IBAction func cancelAction(_ sender: Any) {
        if let nav = self.navigationController{
        let viewControllers: [UIViewController] = nav.viewControllers
            for aViewController in viewControllers {
                if aViewController is ProfileController {
                    self.navigationController!.popToViewController(aViewController, animated: true)
                }
            }
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
