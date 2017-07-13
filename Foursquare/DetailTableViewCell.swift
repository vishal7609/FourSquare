//
//  DetailTableViewCell.swift
//  Foursquare
//
//  Created by Vishal on 21/03/17.
//  Copyright © 2017 Daffolapmac-25. All rights reserved.
//

import UIKit

protocol ReviewDelegate {
    func moveToReview()
}

class DetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var btnReview: UIButton!
    
    var delegate: ReviewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    @IBAction func writeReview(_ sender: Any) {
        
        self.delegate?.moveToReview()
    }
    
    func setCell(rest:ResturantDetail){
        lblName.text = rest.name
        lblAddress.text = "\(rest.address!) \(rest.city!)"
        if rest.isOpen != nil {
            if rest.isOpen! {
                lblHour.text = "Open \(rest.status!)"
            }else{
                lblHour.text = "Closed \(rest.status!)"
            }
        }else{
            lblHour.text = "Sorry, Time is not available"
        }
        
    }
    
}
