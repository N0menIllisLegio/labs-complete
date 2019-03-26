//
//  SubjectInfo.swift
//  LabsComplete
//
//  Created by Dzmitry Mukhliada on 12/18/18.
//  Copyright © 2018 Dzmitry Mukhliada. All rights reserved.
//

import UIKit

class SubjectInfo: NSObject, Codable {
    public var subjectName: String
    public var labsCount: Int
    public var labsPassed: Int = 0
    public var info: String = ""
    public var labsDates = [Date]()
    
    init(subjectName: String, labsCount: Int){
        self.subjectName = subjectName
        self.labsCount = labsCount
    }
    
    public func Update(newSubject: SubjectInfo) {
        self.subjectName = newSubject.subjectName
        self.labsCount = newSubject.labsCount
        self.info = newSubject.info
        self.labsDates = newSubject.labsDates
        self.labsDates.sort()
        if  labsPassed > labsCount {
            labsPassed = labsCount
        }
    }
}
