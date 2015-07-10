//
//  Brick.swift
//  Dynamics
//
//  Created by caganhawthorne on 7/9/15.
//  Copyright © 2015 Cagan Hawthorne. All rights reserved.
//

import UIKit

class Brick: UIView {

    
    init(color: UIColor, x: CGFloat, y: CGFloat)
    {
        super.init(frame: CGRectMake(x, y, 40, 20))
        self.backgroundColor = color
        self.layer.cornerRadius = 5
        
    }
   
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
