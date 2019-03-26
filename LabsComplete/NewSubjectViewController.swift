//
//  NewSubjectViewController.swift
//  LabsComplete
//
//  Created by Dzmitry Mukhliada on 12/18/18.
//  Copyright © 2018 Dzmitry Mukhliada. All rights reserved.
//

import UIKit
import QuartzCore

class NewSubjectViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var subjectTitle: UITextField!
    @IBOutlet weak var labStepper: UIStepper!
    @IBOutlet weak var labLable: UILabel!
    @IBOutlet weak var dateManager: UISwitch!
    @IBOutlet weak var saveDateButton: UIButton!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var dateTable: UITableView!
    @IBOutlet weak var dateManagerLable: UILabel!
    @IBOutlet weak var subjectTitleLabel: UILabel!
    @IBOutlet weak var labInfo: UITextView!
    
    var oldSubject: SubjectInfo?
    var unwindTo: String = ""
    let dateTableController = DateTableViewController()
    var dateExistsAlert = UIAlertController(title: "Warning", message: "This date already exists!\nYou cannot add to same dates.", preferredStyle: .alert)
    
    func costmeticChanges(cornerRadius: CGFloat, borderWidth: CGFloat) {
        date.layer.masksToBounds = true
        date.layer.backgroundColor = UIColor.groupTableViewBackground.cgColor
        date.layer.cornerRadius = cornerRadius
        date.layer.borderWidth = borderWidth
        
        saveDateButton.layer.masksToBounds = true
        saveDateButton.layer.cornerRadius = cornerRadius
        saveDateButton.layer.borderWidth = borderWidth
        
        dateManagerLable.layer.masksToBounds = true
        dateManagerLable.layer.cornerRadius = cornerRadius
        dateManagerLable.layer.borderWidth = borderWidth
        
        dateTable.layer.masksToBounds = true
        dateTable.layer.cornerRadius = cornerRadius
        dateTable.layer.borderWidth = borderWidth
        
        labLable.layer.masksToBounds = true
        labLable.layer.cornerRadius = cornerRadius
        labLable.layer.borderWidth = borderWidth
        
        
        subjectTitleLabel.layer.masksToBounds = true
        subjectTitleLabel.layer.cornerRadius = cornerRadius
        subjectTitleLabel.layer.borderWidth = borderWidth
        
        labStepper.layer.masksToBounds = true
        labStepper.layer.cornerRadius = cornerRadius
        
        labInfo.layer.masksToBounds = true
        labInfo.layer.cornerRadius = cornerRadius
        labInfo.layer.borderWidth = borderWidth
    }
    
    func setValues(){
        subjectTitle.text = oldSubject?.subjectName
        labStepper.value = Double(oldSubject!.labsCount)
        labLable.text = "  Labs count: " + String(oldSubject!.labsCount)
        labInfo.text = oldSubject?.info
        dateTableController.dates = oldSubject?.labsDates ?? [Date]()
        dateTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        costmeticChanges(cornerRadius: 2, borderWidth: 0.1)
        dateTable.dataSource = dateTableController
        dateTable.delegate = dateTableController
        
        dateExistsAlert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
        
        if oldSubject != nil {
            setValues()
        }
        
        if subjectTitle.text == "" {
            saveButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let subject = SubjectInfo(subjectName: subjectTitle.text!, labsCount: Int(labStepper.value))
        subject.info = labInfo.text
        subject.labsDates = dateTableController.dates.sorted()
        
        if oldSubject == nil {
            let destVC = segue.destination as! MasterViewController
            
//            destVC.subjects.insert(subject, at: 0)
            Storage.subjectsData.insert(subject, at: 0)
            destVC.tableView.reloadData()
            destVC.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.middle)
            
            if UIApplication.shared.statusBarOrientation.isLandscape, let split = destVC.splitViewController {
                let controllers = split.viewControllers
                destVC.detailViewController = ((controllers[controllers.count - 1] as! UINavigationController).topViewController as! DetailViewController)
//                destVC.detailViewController?.detailItem = destVC.subjects[0]
                destVC.detailViewController?.detailItem = Storage.subjectsData[0]
                destVC.detailViewController?.configureView()
            }
        } else {
            oldSubject?.Update(newSubject: subject)
        }
    }
    
    @IBAction func saveDate(_ sender: Any) {
        var savingDate: Date? = date.date
        for savedDate in dateTableController.dates {
            if Calendar.current.compare(savingDate!, to: savedDate, toGranularity: .day) == .orderedSame {
                savingDate = nil
                break
            }
        }
        
        if savingDate != nil {
            dateTableController.dates.append(savingDate!)
            dateTable.reloadData()
        } else {
            self.present(dateExistsAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onOffDateSaver(_ sender: Any) {
        let enabled = dateManager.isOn
        saveDateButton.isEnabled = enabled
        date.isEnabled = enabled
    }
    
    @IBAction func labsCounterAction(_ sender: Any) {
        let label = "  Labs count: "
        let count = Int(labStepper.value)
        labLable.text = label + String(count)
    }
    
    private func updateSaveButtonState() {
        subjectTitle.text = subjectTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let text = subjectTitle.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    @IBAction func titleEditingBegins(_ sender: Any) {
        saveButton.isEnabled = false
    }
    
    @IBAction func titleEditingEnds(_ sender: Any) {
        updateSaveButtonState()
        navigationItem.title = subjectTitle.text
    }
    
    @IBAction func primaryAction(_ sender: Any) {
        subjectTitle.endEditing(true)
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        self.performSegue(withIdentifier: unwindTo, sender: sender)
    }
}
