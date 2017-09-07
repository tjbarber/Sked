//
//  LocationSearchController.swift
//  Sked
//
//  Created by TJ Barber on 9/6/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationSearchController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    let locationManager  = LocationService.sharedInstance
    var dataSource       = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            if locationManager.currentLocation == nil {
                waitForLocationLock()
            } else {
                getMapResults()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func closeLocationSearch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Helper Methods

extension LocationSearchController {
    func waitForLocationLock() {
        let locationTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            if self.locationManager.currentLocation != nil {
                DispatchQueue.main.async {
                    self.getMapResults()
                }
                timer.invalidate()
            }
        }
        locationTimer.fire()
    }
}

// MARK: - Table View Data Source

extension LocationSearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as! LocationCell
        let mapEntry = self.dataSource[indexPath.row]
        cell.configure(mapEntry)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
}

// MARK: - Search Results Updating

extension LocationSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        getMapResults()
    }
}

// MARK: - MapKit

extension LocationSearchController {
    func getMapResults() {
        if let currentLocation = self.locationManager.currentLocation {
            let request = MKLocalSearchRequest()
            
            if let query = self.searchController.searchBar.text {
                request.naturalLanguageQuery = query
                
                if query.isEmpty {
                    request.naturalLanguageQuery = "coffee"
                }
            }
            
            request.region = MKCoordinateRegionMake(currentLocation, MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            let search = MKLocalSearch(request: request)
            search.start { [unowned self] response, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let response = response {
                    var placemarks = [MKMapItem]()
                    for placemark in response.mapItems {
                        placemarks.append(placemark)
                    }
                    
                    DispatchQueue.main.async {
                        self.dataSource = placemarks
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
