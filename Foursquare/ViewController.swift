//
//  ViewController.swift
//  Foursquare
//
//  Created by Vishal on 19/03/17.
//  Copyright © 2017 Daffolapmac-25. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var resturantCollectionView: UICollectionView!
    let locationManager = CLLocationManager()
    var location: CLLocation!
    var session: Session!
    
    typealias JSONParameters = [String: AnyObject]
    
    var venues: [JSONParameters]!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        resturantCollectionView.dataSource = self
        resturantCollectionView.delegate = self
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        resturantCollectionView.register(nib , forCellWithReuseIdentifier: "CollectionViewCell")
        
        self.session = Session.sharedSession()
        self.session.logger = ConsoleLogger()
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        self.location = manager.location
        
        if location == nil {
            return
        }
        
        var parameters = [Parameter.query:"Restaurant"]
        parameters += self.location.parameters()
        let searchTask = session.venues.search(parameters) {
            (result) -> Void in
            if let response = result.response {
                print(response)
                self.venues = response["venues"] as! [JSONParameters]?
            }
        }
        searchTask.start()
        
    }

}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        return cell
    }
    
}


extension CLLocation {
    func parameters() -> Parameters {
        let ll      = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
        let llAcc   = "\(self.horizontalAccuracy)"
        let alt     = "\(self.altitude)"
        let altAcc  = "\(self.verticalAccuracy)"
        let parameters = [
            Parameter.ll:ll,
            Parameter.llAcc:llAcc,
            Parameter.alt:alt,
            Parameter.altAcc:altAcc
        ]
        return parameters
    }
}
