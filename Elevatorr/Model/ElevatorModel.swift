//
//  ElevatorModel.swift
//  Elevatorr
//
//  Created by Onur Fidan on 27.07.2023.
//

import Foundation
import UIKit

class ElevatorModel {
    
    static let elevator = ElevatorModel()
    
    var elevatorType = ""
    var buildingname = ""
    var elevatorStatus = ""
    var elevatorImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init() {}
}
