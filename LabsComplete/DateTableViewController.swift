//
//  DateTableViewController.swift
//  LabsComplete
//
//  Created by Dzmitry Mukhliada on 12/23/18.
//  Copyright © 2018 Dzmitry Mukhliada. All rights reserved.
//

import UIKit

class DateTableViewController: UITableViewController {

    var dates = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var strDate = dateFormatter.string(from: dates[indexPath.row])
        strDate = strDate.replacingOccurrences(of: "-", with: ".")
        cell.textLabel!.text = strDate
        
        let components = Calendar.current.dateComponents([.day, .hour], from: Date(), to: dates[indexPath.row])
        
        if dates[indexPath.row] <= Date() {
            if Calendar.current.compare(dates[indexPath.row], to: Date(), toGranularity: .day) == .orderedSame {
                cell.detailTextLabel?.text = "Today"
            } else {
                cell.detailTextLabel?.text = "Passed"
            }
        } else {
            if components.day! == 0 {
                cell.detailTextLabel?.text = String(components.hour!) + " h"
            } else {
                cell.detailTextLabel?.text = String(components.day!) + " d"
            }
        }

        return cell
    }
 
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath)
        
        if  cell == nil || cell?.detailTextLabel != nil {
            return false
        }
        
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dates.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
