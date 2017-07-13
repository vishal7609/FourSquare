//
//  DetailTableViewController.swift
//  Foursquare
//
//  Created by Vishal on 21/03/17.
//  Copyright © 2017 Daffolapmac-25. All rights reserved.
//

import UIKit

class DetailTableViewController: ExpandingTableViewController {
    
    @IBOutlet weak var closeHandler: UIBarButtonItem!
    
    fileprivate var scrollOffsetY: CGFloat = 0
    
    var venueId: String?
    var session: Session!
    
    var restDeatil:ResturantDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableViewCell")
        self.tableView.register(UINib(nibName: "SectionTableViewCell", bundle: nil), forCellReuseIdentifier: "SectionTableViewCell")
        self.tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        configureNavBar()
        self.session = Session.sharedSession()
        self.session.logger = ConsoleLogger()
        
        
        let image1 = UIImage.Asset.BackgroundImage.image
        tableView.backgroundView = UIImageView(image: image1)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getVenuDetail()
    }
    
    func getVenuDetail(){
        let task = self.session.venues.get(self.venueId!) {
            (result) -> Void in
            if let response = result.response {
                print(response)
                self.restDeatil = Parser.parserResturantDetail(response: response as NSDictionary)
                let userReview = self.getLocalReview()
                if userReview.count > 0 {
                    self.restDeatil?.reviews.insert(contentsOf: userReview, at: 0)
                }
                self.tableView.reloadData()
            } else {
                // Show error.
            }
            self.tableView.reloadData()
        }
        task.start()
    }
    
    func getLocalReview() -> [Reviews] {
        var localReviews = [Reviews]()
        DatabaseServiceManager.fetchReview(self.venueId!, success: { (reviews) in
            print(reviews.count)
            localReviews = reviews
        }) { (error) in
            print(error!)
        }
        
        return localReviews
    }
    
    
    
    
   
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if restDeatil != nil {
            return 2 + (restDeatil?.reviews.count)!
        }else{
            return 2
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        }
        if indexPath.row == 1 {
            return 75
        }
        return  80
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell:DetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
            cell.delegate = self
            if restDeatil != nil {
                cell.setCell(rest: restDeatil!)
            }
            return cell
        }
        else if indexPath.row == 1 {
            let cell:SectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell", for: indexPath) as! SectionTableViewCell
            if restDeatil != nil {
                cell.lblSummary.text = restDeatil?.description
            }

            return cell
        }else{
            let cell:ReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
            if restDeatil != nil {
                let review = restDeatil?.reviews[indexPath.row - 2]
                cell.lblName.text = review?.name
                cell.lblReview.text = review?.review
            }
            return cell
        }
    }
}

extension DetailTableViewController {
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        //navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
}


extension DetailTableViewController {
    
    @IBAction func closeAction(_ sender: Any) {
        let viewControllers: [DemoViewController?] = navigationController?.viewControllers.map { $0 as? DemoViewController } ?? []
        
        for viewController in viewControllers {
            if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(false)
            }
        }
        popTransitionAnimation()
    }
    
    @IBAction func BlockHandler(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Sure, You want to block this resturant ?", preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Sure", style: .destructive) { action -> Void in
            //Code for launching the camera goes here
            var blockRest:[String] = [String]()
            if let blockArray:[String] = UserDefaults.standard.array(forKey: "blockRest") as? [String] {
                blockRest.append(contentsOf: blockArray)
            }
            blockRest.append(self.venueId!)
            
            UserDefaults.standard.set(blockRest, forKey: "blockRest")
            
        }
        actionSheetController.addAction(takePictureAction)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
}

extension DetailTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollOffsetY = scrollView.contentOffset.y
    }
}

extension DetailTableViewController: ReviewDelegate {
    
    func moveToReview() {
        let ReviewViewController =
            self.storyboard?.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
        ReviewViewController.id = self.venueId
        self.navigationController?.pushViewController(ReviewViewController, animated: true)
    }
    
}
