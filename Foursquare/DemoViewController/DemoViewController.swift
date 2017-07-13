//
//  DemoViewController.swift
//  Foursquare
//
//  Created by Vishal on 19/03/17.
//  Copyright © 2017 Daffolapmac-25. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class DemoViewController: ExpandingViewController {
  
    typealias ItemInfo = (imageName: String, title: String)
    fileprivate var cellsIsOpen = [Bool]()
    fileprivate let items: [ItemInfo] = [("item0", "Boston"),("item1", "New York"),("item2", "San Francisco"),("item3", "Washington")]
    
    fileprivate var resturantItem: [Resturant] = [Resturant]()
    
    let locationManager = CLLocationManager()
    var location: CLLocation!
    var session: Session!

    typealias JSONParameters = [String: AnyObject]

    var venues: [JSONParameters]!
      
    @IBOutlet weak var pageLabel: UILabel!
    
}

// MARK: life cicle

extension DemoViewController {
  
  override func viewDidLoad() {
    itemSize = CGSize(width: 256, height: 335)
    super.viewDidLoad()
    
    registerCell()
    fillCellIsOpeenArry()
    addGestureToView(collectionView!)
    configureNavBar()
    configureSessionLocation()
  }
}

// MARK: Helpers 

extension DemoViewController {
  
    fileprivate func registerCell() {
        let nib = UINib(nibName: String(describing: DemoCollectionViewCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: DemoCollectionViewCell.self))
    }
  
    fileprivate func fillCellIsOpeenArry() {
        for _ in resturantItem {
            cellsIsOpen.append(false)
        }
    }
  
    fileprivate func getViewController(id:String) -> ExpandingTableViewController {
        let storyboard = UIStoryboard(storyboard: .Main)
        let toViewController: DetailTableViewController = storyboard.instantiateViewController()
        toViewController.venueId = id
        return toViewController
    }
  
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
    func configureSessionLocation(){
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
    
    
    
    
}

/// MARK: Location 

extension DemoViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        self.location = manager.location
        
        if location == nil {
            return
        }
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        var parameters = [Parameter.query:"Restaurant"]
        parameters += self.location.parameters()
        let searchTask = session.venues.search(parameters) {
            (result) -> Void in
            if let response = result.response {
                print(response)
                self.venues = response["venues"] as! [JSONParameters]?
                self.resturantItem = Parser.parseResturant(dictArray: self.venues as NSArray)
                print(self.resturantItem.count)
                self.collectionView?.reloadData()
                self.fillCellIsOpeenArry()
            }
        }
        searchTask.start()
        
    }
}

/// MARK: Gesture

extension DemoViewController {
  
  fileprivate func addGestureToView(_ toView: UIView) {
    let gesutereUp = Init(UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))) {
      $0.direction = .up
    }
    
    let gesutereDown = Init(UISwipeGestureRecognizer(target: self, action: #selector(DemoViewController.swipeHandler(_:)))) {
      $0.direction = .down
    }
    toView.addGestureRecognizer(gesutereUp)
    toView.addGestureRecognizer(gesutereDown)
  }

  func swipeHandler(_ sender: UISwipeGestureRecognizer) {
    let indexPath = IndexPath(row: currentIndex, section: 0)
    guard let cell  = collectionView?.cellForItem(at: indexPath) as? DemoCollectionViewCell else { return }
    // double swipe Up transition
    if cell.isOpened == true && sender.direction == .up {
        let venuId = resturantItem[indexPath.row].id
        if let blockArray:[String] = UserDefaults.standard.array(forKey: "blockRest") as? [String]{
            if blockArray.contains(venuId!) {
                self.showAlertWithMessage("You blocked this resturant", andTitle: "Sorry")
            }else {
                pushToViewController(getViewController(id: venuId!))
            }
        }else {
            pushToViewController(getViewController(id: venuId!))
        }
        
      
      if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
        rightButton.animationSelected(true)
      }
    }
    
    let open = sender.direction == .up ? true : false
    cell.cellIsOpen(open)
    cellsIsOpen[(indexPath as NSIndexPath).row] = cell.isOpened
  }
}

// MARK: UIScrollViewDelegate 

extension DemoViewController {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    pageLabel.text = "\(currentIndex+1)/\(resturantItem.count)"
  }
}

// MARK: UICollectionViewDataSource

extension DemoViewController {
  
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
    guard let cell = cell as? DemoCollectionViewCell else { return }

    let index = (indexPath as NSIndexPath).row % resturantItem.count
    let info = resturantItem[index]
    //let url = URL(string: info.categoyrIcon!)
    
    
    //cell.backgroundImageView?.kf.setImage(with: url)
    cell.customTitle.text = info.restName
    cell.address.text = info.address! + " " + info.city! + " " + info.country!
    cell.pinCode.text = info.postalCode
    cell.cellIsOpen(cellsIsOpen[index], animated: false)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? DemoCollectionViewCell
          , currentIndex == (indexPath as NSIndexPath).row else { return }

    if cell.isOpened == false {
      cell.cellIsOpen(true)
    } else {
        let venuId = resturantItem[indexPath.row].id
        if let blockArray:[String] = UserDefaults.standard.array(forKey: "blockRest") as? [String]{
            if blockArray.contains(venuId!) {
                self.showAlertWithMessage("You blocked this resturant", andTitle: "Sorry")
            }else {
                pushToViewController(getViewController(id: venuId!))
            }
        }else {
            pushToViewController(getViewController(id: venuId!))
        }
      //pushToViewController(getViewController(id: venuId!))
      
      if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
        rightButton.animationSelected(true)
      }
    }
  }
}

// MARK: UICollectionViewDataSource
extension DemoViewController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return resturantItem.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DemoCollectionViewCell.self), for: indexPath)
  }
}

