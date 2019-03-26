//
//  TodayViewController.swift
//  Labs
//
//  Created by Dzmitry Mukhliada on 12/25/18.
//  Copyright © 2018 Dzmitry Mukhliada. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private let us = UserDefaults(suiteName: "group.gadfly")
    private let json = JSONDecoder()
    private var subjects = [SubjectInfo]()
    private var straightImage: UIImage?
    private var reverseImage: UIImage?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        reloadTable()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        self.preferredContentSize = CGSize(width: tableView.contentSize.width, height: self.tableView.rowHeight)
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        reloadTable()
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let deadlineTime = DispatchTime.now() + 0.02
        if activeDisplayMode == .expanded {
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.preferredContentSize = self.tableView.contentSize
            }
        } else if activeDisplayMode == .compact {
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.preferredContentSize = maxSize
            }
        }
    }
    
    func reloadTable() {
        do {
            let data: Data = (us?.data(forKey: "data"))!
            subjects = try json.decode([SubjectInfo].self, from: data)
            subjects = subjects.filter({$0.labsCount != $0.labsPassed})
        } catch {
            print("error in loading data widget")
        }
        if subjects.isEmpty {
            tableView.isHidden = true
            notificationLabel.isHidden = false
        } else {
            notificationLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
        
    }
    
    func setCellsProgressBarsColor(cell: WidgetTableViewCell) {
        if straightImage == nil {
            GradientView.reverse = false
            let labsGradientView = GradientView(frame: cell.labsProgress.bounds)
            straightImage = labsGradientView.image()
        }
        
        cell.labsProgress.trackImage = straightImage
        cell.labsProgress.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
        
        if reverseImage == nil {
            GradientView.reverse = true
            let datesGradientView = GradientView(frame: cell.labsProgress.bounds)
            reverseImage = datesGradientView.image()
        }
        
        cell.dateProgress.trackImage = reverseImage
        cell.dateProgress.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
    }
    
    @objc func userDefaultsDidChange() {
        reloadTable()
    }
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WidgetTableViewCell
        
        let subject = subjects[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        cell.title!.text = subject.subjectName
        if !subject.labsDates.isEmpty {
            cell.dateProgress.isHidden = false
            
            var outDate = Date()
            var trigger = false
            
            for labsDate in subject.labsDates {
                if labsDate > Date() {
                    outDate = labsDate
                    trigger = true
                    break
                }
            }
            
            if trigger {
                var strDate = dateFormatter.string(from: outDate)
                strDate = strDate.replacingOccurrences(of: "-", with: ".")
                cell.nextDate.text = "Next lab: " + strDate
            } else {
                cell.nextDate.text = "All labs passed!"
            }
            
            //            let datesCount = subjects[indexPath.row].labsDates.count
            let datesCount = subjects[indexPath.row].labsDates.count
            var datesPassedCount = 0
            
            //            for date in subjects[indexPath.row].labsDates {
            for date in subjects[indexPath.row].labsDates {
                if Date() > date {
                    datesPassedCount += 1
                }
            }
            
            cell.dateProgress.setProgress(1 - Float(datesPassedCount) / Float(datesCount), animated: true)
            cell.dateProgress.layer.cornerRadius = 2
            cell.dateProgress.layer.borderWidth = 0.1
            cell.dateProgress.layer.masksToBounds = true
            
        } else {
            cell.nextDate.text = ""
            cell.dateProgress.isHidden = true
        }
        
        cell.labsProgress.setProgress(1 - Float(subject.labsPassed) / Float(subject.labsCount), animated: true)
        cell.labsProgress.layer.cornerRadius = 2
        cell.labsProgress.layer.borderWidth = 0.1
        cell.labsProgress.layer.masksToBounds = true
        
        cell.labs.text = String(subject.labsPassed) + "/" + String(subject.labsCount)
        
        setCellsProgressBarsColor(cell: cell)
        
        return cell
    }
}
