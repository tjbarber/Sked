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
    
    var reminder: Reminder?
    let searchController = UISearchController(searchResultsController: nil)
    let locationManager  = LocationService.sharedInstance
    var dataSource       = [MKMapItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
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
    
    deinit {
        // This is here because of a bug in UISearchController where if this isn't added we get the following warning in the console:
        // Attempting to load the view of a view controller while it is deallocating is not allowed and may result in undefined behavior (<UISearchController: 0x154d39700>)
        self.searchController.view.removeFromSuperview()
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

// MARK: - Table View Delegate

extension LocationSearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapItem = self.dataSource[indexPath.row]
        // This is not the Navigation Controller we see, this is the main one
        let presentingNavigationController = self.presentingViewController as! UINavigationController
        
        // This is the AddReminderController
        let addReminderController = presentingNavigationController.topViewController as! AddReminderController
        addReminderController.selectedLocation = mapItem
        
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Search Bar Updating

extension LocationSearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
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
                    var mapItems = [MKMapItem]()
                    for mapItem in response.mapItems {
                        mapItems.append(mapItem)
                    }
                    
                    DispatchQueue.main.async {
                        self.dataSource = mapItems
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
