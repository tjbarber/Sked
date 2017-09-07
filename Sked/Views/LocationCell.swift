//
//  LocationCell.swift
//  Sked
//
//  Created by TJ Barber on 9/7/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit
import MapKit

class LocationCell: UITableViewCell {

    static let identifier = "locationCell"
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ mapItem: MKMapItem) {
        self.locationNameLabel.text = nil
        self.locationAddressLabel.text = nil
        
        self.locationNameLabel.text = mapItem.name
        
        if let street = mapItem.placemark.thoroughfare,
            let city = mapItem.placemark.locality,
            let state = mapItem.placemark.administrativeArea {
            self.locationAddressLabel.text = "\(street), \(city), \(state)"
        }
    }
}
