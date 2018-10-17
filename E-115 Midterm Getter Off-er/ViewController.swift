//
//  ViewController.swift
//  E-115 Midterm Getter Off-er
//
//  Created by Jayden Pereira on 10/12/18.
//  Copyright © 2018 Jayden Pereira. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    //CALCULATOR BLOCK
    var numberOnScreen: Double = 0;
    var numberStore: Double = 0;
    var doingMath = false
    var calculation = 0;
    
    @IBOutlet weak var calculatorOutput: UILabel!
    
    @IBAction func numberPad(_ sender: UIButton) {
        if doingMath == true {
            calculatorOutput.text = String(sender.tag - 1)
            numberOnScreen = Double(calculatorOutput.text!)!
            doingMath = false
        }
        else {
            calculatorOutput.text = calculatorOutput.text! + String(sender.tag - 1)
            numberOnScreen = Double(calculatorOutput.text!)!
        }
    }
    
    @IBAction func buttonOperands(_ sender: UIButton) {
        if calculatorOutput.text != "" && sender.tag != 11 && sender.tag != 16 {
            
            numberStore = Double(calculatorOutput.text!)!
            
            //Divide
            if sender.tag == 12 {
                calculatorOutput.text = "/";
            }
            //Multiply
            else if sender.tag == 13 {
                calculatorOutput.text = "*";
            }
            //Minus
            else if sender.tag == 14 {
                calculatorOutput.text = "-";
            }
            //Plus
            else if sender.tag == 15 {
                calculatorOutput.text = "+";
            }
            
            calculation = sender.tag
            doingMath = true;
        }
        
        else if sender.tag == 16 {
            //Divide
            if calculation == 12 {
                calculatorOutput.text = String(numberStore / numberOnScreen)
            }
            //Multiply
            else if calculation == 13 {
                calculatorOutput.text = String(numberStore * numberOnScreen)
            }
            //Minus
            else if calculation == 14 {
                calculatorOutput.text = String(numberStore - numberOnScreen)
            }
            //Plus
            else if calculation == 15 {
                calculatorOutput.text = String(numberStore + numberOnScreen)
                
            }
        }
            
        //Adding clear functionality
        else if sender.tag == 11 {
            calculatorOutput.text = "";
            numberStore = 0;
            numberOnScreen = 0;
            calculation = 0;
        }
    }
    
    //MAP BLOCK
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    //Setup Core Location Delegate
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    //Centering view on user location
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    //Check to see if services are running
    func locationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            locationAuthorization()
        }
    }
    
    //Check if user has location authorization
    func locationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        
        //Ask for location
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        //When authorization is granted
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        
        //Not in use
        case .denied:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedAlways:
            break
        }
    }
    
    //Call funtions and output to screen
    override func viewDidLoad() {
        super.viewDidLoad()
        locationServices()
        self.calculatorOutput.layer.cornerRadius = 10
    }
}

//Extension of ViewController class to add CLLocation Manager Delegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    private func locationManager(_ manager: CLLocationManager, didChangeAuthorization visit: CLVisit) {
        locationAuthorization()
    }
}
