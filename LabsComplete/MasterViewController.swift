//
//  MasterViewController.swift
//  LabsComplete
//
//  Created by Dzmitry Mukhliada on 12/18/18.
//  Copyright © 2018 Dzmitry Mukhliada. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    // var subjects = [SubjectInfo]()
    var straightImage: UIImage?
    var reverseImage: UIImage?
    
    func loadData() {
//        let tempDirectoryURL = NSURL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
//        let targetURL = tempDirectoryURL.appendingPathComponent("subjects.dat")!
        
        do {
            let us = UserDefaults(suiteName: "group.gadfly")
            let data: Data? = us?.data(forKey: "data") //try Data(contentsOf: targetURL, options: [])
            let json = JSONDecoder()
//            subjects = try! json.decode([SubjectInfo].self, from: data)
            if data != nil {
                Storage.subjectsData = try json.decode([SubjectInfo].self, from: data!)
            }
        }
        catch {
            print("error in loading data from file")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        if UIApplication.shared.statusBarOrientation.isLandscape{
            self.tableView.rowHeight = 50
        } else {
            self.tableView.rowHeight = 130
        }
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "addNew" {
            let controller = (segue.destination as! UINavigationController).topViewController as! NewSubjectViewController
            
            controller.unwindTo = "subjectsSegue"
            controller.oldSubject = nil
        }
        
        if segue.identifier == "showDetail", let indexPath = tableView.indexPathForSelectedRow {
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
            //controller.detailItem = subjects[indexPath.row]
            controller.detailItem = Storage.subjectsData[indexPath.row]
            controller.tableView = tableView
        }
    }
    
    @IBAction func unwindToSubjectsTable(_ unwindSegue: UIStoryboardSegue) {
        tableView.reloadData()
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return subjects.count
        return Storage.subjectsData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> SubjectTableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectTableViewCell", for: indexPath) as? SubjectTableViewCell else {
            fatalError("The dequeued cell is not an instance of SubjectTableViewCell.")
        }
        
//        let subject = subjects[indexPath.row]
        let subject = Storage.subjectsData[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        cell.subjectTitle!.text = subject.subjectName
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
                cell.nextLabDate.text = "Next lab: " + strDate
            } else {
                cell.nextLabDate.text = "All labs passed!"
            }
            
//            let datesCount = subjects[indexPath.row].labsDates.count
            let datesCount = Storage.subjectsData[indexPath.row].labsDates.count
            var datesPassedCount = 0
            
//            for date in subjects[indexPath.row].labsDates {
            for date in Storage.subjectsData[indexPath.row].labsDates {
                if Date() > date {
                    datesPassedCount += 1
                }
            }
            
            cell.dateProgress.setProgress(1 - Float(datesPassedCount) / Float(datesCount), animated: true)
            cell.dateProgress.layer.cornerRadius = 2
            cell.dateProgress.layer.borderWidth = 0.1
            cell.dateProgress.layer.masksToBounds = true

        } else {
            cell.nextLabDate.text = ""
            cell.dateProgress.isHidden = true
        }
        
        cell.labsProgress.setProgress(1 - Float(subject.labsPassed) / Float(subject.labsCount), animated: true)
        cell.labsProgress.layer.cornerRadius = 2
        cell.labsProgress.layer.borderWidth = 0.1
        cell.labsProgress.layer.masksToBounds = true
        
        cell.labsLable.text = String(subject.labsPassed) + "/" + String(subject.labsCount)
        
        setCellsProgressBarsColor(cell: cell)
        
        cell.labsPassCounter.tag = indexPath.row
//        cell.labsPassCounter.maximumValue = Double(subjects[indexPath.row].labsCount)
//        cell.labsPassCounter.value = Double(subjects[indexPath.row].labsPassed)
        cell.labsPassCounter.maximumValue = Double(Storage.subjectsData[indexPath.row].labsCount)
        cell.labsPassCounter.value = Double(Storage.subjectsData[indexPath.row].labsPassed)
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            cell.secondStack.isHidden = true
            cell.thirdStack.isHidden = true
        } else {
            cell.secondStack.isHidden = false
            cell.thirdStack.isHidden = false
        }

        return cell
    }
    
    @IBAction func labPassed(_ sender: Any) {
        let buttonRow = (sender as AnyObject).tag!
        
//        subjects[buttonRow!].labsPassed = Int((sender as! UIStepper).value)
        Storage.subjectsData[buttonRow].labsPassed = Int((sender as! UIStepper).value)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
//            subjects.remove(at: indexPath.row)
            Storage.subjectsData.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            
            if UIApplication.shared.statusBarOrientation.isLandscape{
                self.tableView.rowHeight = 50
                
            } else {
                self.tableView.rowHeight = 130
            }
            
            self.tableView.reloadData()
        }
    }
    
    func setCellsProgressBarsColor(cell: SubjectTableViewCell) {
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
}
