//
//  HomeController.swift
//  Sked
//
//  Created by TJ Barber on 8/31/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    var dataSource = [Reminder]()
    
    @IBOutlet weak var shrugLabel: UILabel!
    @IBOutlet weak var emptyMessageLabel: UILabel!
    @IBOutlet weak var emptyMessageActionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(3.0, for: .default)
        self.tableView.dataSource = self
        self.tableView.delegate   = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: - UITableViewDataSource

extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReminderCell.identifier, for: indexPath) as! ReminderCell
        let reminder = self.dataSource[indexPath.row]
        cell.configure(reminder)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let reminder = self.dataSource[indexPath.row]
            ReminderStore.sharedInstance.delete(reminder) { [unowned self] error in
                if let error = error {
                    AlertHelper.showAlert(withTitle: "Error", withMessage: error.localizedDescription, presentingViewController: self)
                    return
                }
                
                self.dataSource.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                if self.dataSource.isEmpty {
                    self.tableView.isHidden = true
                    self.animateEmptyView()
                }
            }
        case .insert, .none: break;
        }
    }
}

// MARK: - UITableViewDelegate

extension HomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96.0
    }
    
    
}

// MARK: - Animation Methods

extension HomeController {
    func animateEmptyView() {
        self.shrugLabel.alpha = 0.0
        self.emptyMessageLabel.alpha = 0.0
        self.emptyMessageActionLabel.alpha = 0.0
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.shrugLabel.alpha = 1.0
            self.emptyMessageLabel.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, delay: 1.0, options: .curveEaseInOut, animations: {
            self.emptyMessageActionLabel.alpha = 1.0
        }, completion: nil)
    }
}

// MARK: - Core Data Methods

extension HomeController {
    func loadDataSource() {
        ReminderStore.sharedInstance.all { [unowned self] reminders, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            
            self.dataSource = reminders
            self.tableView.reloadData()
            
            if self.dataSource.isEmpty {
                self.animateEmptyView()
            } else {
                self.tableView.isHidden = false
            }
        }
    }
}
