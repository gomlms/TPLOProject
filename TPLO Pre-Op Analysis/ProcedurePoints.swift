//
//  ProcedurePoints.swift
//  TPLO Pre-Op Analysis
//
//  Created by Max Sidebotham on 1/24/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit

class ProcedurePoints: NSObject {
    var x : Double = 0
    var y : Double = 0
    
    //MARK: Initialization
    init?(x:Double, y:Double){
        self.x = x
        self.y = y
    }
    
}
