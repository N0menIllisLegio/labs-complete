//
//  DetailViewController.swift
//  LabsComplete
//
//  Created by Dzmitry Mukhliada on 12/18/18.
//  Copyright © 2018 Dzmitry Mukhliada. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var dateTable: UITableView!
    @IBOutlet weak var labsInfo: UITextView!
    @IBOutlet weak var labsProgress: UIProgressView!
    @IBOutlet weak var labsStepper: UIStepper!
    @IBOutlet weak var totalLabsLabel: UILabel!
    @IBOutlet weak var labsPassedLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var tableView: UITableView?
    var detailItem: SubjectInfo?
    var tableController = DateTableViewController()

    func costmeticChanges(cornerRadius: CGFloat, borderWidth: CGFloat) {
        dateTable.layer.masksToBounds = true
        dateTable.layer.cornerRadius = cornerRadius
        dateTable.layer.borderWidth = borderWidth
        
        labsPassedLabel.layer.masksToBounds = true
        labsPassedLabel.layer.cornerRadius = cornerRadius
        labsPassedLabel.layer.borderWidth = borderWidth
        
        totalLabsLabel.layer.masksToBounds = true
        totalLabsLabel.layer.cornerRadius = cornerRadius
        totalLabsLabel.layer.borderWidth = borderWidth
        
        labsStepper.layer.masksToBounds = true
        labsStepper.layer.cornerRadius = 5
        
        labsInfo.layer.masksToBounds = true
        labsInfo.layer.cornerRadius = cornerRadius
        labsInfo.layer.borderWidth = borderWidth
        // labsInfo.layer.opacity = 0.5 !!!! -- OPACITY
        
        labsProgress.layer.masksToBounds = true
        labsProgress.layer.cornerRadius = cornerRadius
        labsProgress.layer.borderWidth = borderWidth
    }
    
    func configureView() {
        if let detail = detailItem {
            navigationItem.title = detail.subjectName
            labsPassedLabel.text = "  Labs Passed: " + String(detail.labsPassed)
            totalLabsLabel.text = "  Total Labs: " + String(detail.labsCount)
            labsStepper.value = Double(detail.labsPassed)
            labsStepper.maximumValue = Double(detail.labsCount)
            
            labsProgress.setProgress(1 - Float(detail.labsPassed) / Float(detail.labsCount), animated: true)
            GradientView.reverse = false
            let labsGradientView = GradientView(frame: labsProgress.bounds)
            labsProgress.trackImage = labsGradientView.image()
            labsProgress.transform = CGAffineTransform(scaleX: -1.0, y: -1.0)
            
            labsInfo.text = detail.info
            
            if detail.labsDates.isEmpty {
                dateTable.isHidden = true
            } else {
                dateTable.isHidden = false
                dateTable.dataSource = tableController
                dateTable.delegate = tableController

                tableController.dates = detail.labsDates
                dateTable.reloadData()
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        costmeticChanges(cornerRadius: 2, borderWidth: 0.1)
        
        if UIApplication.shared.statusBarOrientation.isLandscape{
            self.backButton?.isEnabled = false
        } else {
            self.backButton?.isEnabled = true
        }
        
        if detailItem == nil {
            editButton.isEnabled = false
            labsStepper.isEnabled = false
            mainStack.isHidden = true
        } else {
            mainStack.isHidden = false
            configureView()
        }
    }
    
    @IBAction func passLab(_ sender: Any) {
        detailItem!.labsPassed = Int(labsStepper.value)
        labsPassedLabel.text = "  Labs Passed: " + String(detailItem!.labsPassed)
        labsProgress.setProgress(1 - Float(detailItem!.labsPassed) / Float(detailItem!.labsCount), animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSubject" {
            let controller = (segue.destination as! UINavigationController).topViewController as! NewSubjectViewController
            
            controller.oldSubject = detailItem
            controller.unwindTo = "detailsSegue"
            controller.navigationItem.title = detailItem?.subjectName
        }
    }
    
    @IBAction func unwindToDetails(_ unwindSegue: UIStoryboardSegue) {
        configureView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            
            if UIApplication.shared.statusBarOrientation.isLandscape{
                self.tableView?.rowHeight = 50
                self.backButton?.isEnabled = false
                self.tableView?.reloadData()
            } else {
                self.tableView?.rowHeight = 130
                self.backButton?.isEnabled = true
            }
        }
    }
}
