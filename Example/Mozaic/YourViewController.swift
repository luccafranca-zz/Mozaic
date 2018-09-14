//
//  ViewController.swift
//  Mozaic
//
//  Created by luccafgf on 09/14/2018.
//  Copyright (c) 2018 luccafgf. All rights reserved.
//

import UIKit
import Mozaic

class YourViewController: UIViewController {

    @IBOutlet weak var yourCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.yourCollectionView.delegate = self
        self.yourCollectionView.dataSource = self
        let mozaicLayout = Mozaic()
        self.yourCollectionView.collectionViewLayout = mozaicLayout
        mozaicLayout.delegate = self
    }
    
}

extension YourViewController: MozaicDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
        
    func setStyleOfEachColumn() -> [[MozaicCellType]] {
        return [[.Medium, .Small, .Medium], [.Large, .Small, .Small]]
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.yourCollectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! YourCollectionViewCell
        
        return cell
    }
    
}

