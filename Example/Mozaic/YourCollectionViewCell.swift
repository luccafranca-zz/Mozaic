//
//  YourCollectionViewCell.swift
//  Mozaic_Example
//
//  Created by Lucca França on 14/09/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class YourCollectionViewCell: UICollectionViewCell {
    
//    var gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.myInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.myInit()
    }
    
    func myInit() {
        self.backgroundColor = UIColor.darkGray
    }
    
}
