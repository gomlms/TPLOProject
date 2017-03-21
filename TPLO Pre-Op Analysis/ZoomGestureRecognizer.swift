//
//  ZoomViewRecognizer.swift
//  TPLO Pre-Op Analysis
//
//  Created by Erik Melone on 3/21/17.
//  Copyright © 2017 Preda Studios. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class ZoomGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .began
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .changed
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .ended
    }
}
