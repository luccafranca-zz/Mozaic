//
//  Created by Lucca França Gomes Ferreira on 15/08/18.
//  Copyright © 2018 Lucca França Gomes Ferreira. All rights reserved.
//

import UIKit

struct MozaicCellSize {
    var smallSize: CGSize
    var mediumSize: CGSize
    var largeSize: CGSize
}

public enum MozaicCellType {
    case Small
    case Medium
    case Large
}

open class Mozaic: UICollectionViewLayout {
    
    open var delegate: MozaicDelegate!
    
    fileprivate var arrayOfTypes: [[MozaicCellType]] {
        return delegate.setStyleOfEachColumn()
    }
    
    fileprivate var numberOfColumns: Int {
        return arrayOfTypes.count
    }
    
    fileprivate var actualColumn: Int = 0
    fileprivate var scaleFactor: CGFloat {
        return delegate.setCellHeightProportion()
    }
    
    fileprivate var cellPaddingHorizontal: CGFloat {
        return delegate.setHorizontalSpaceBetweenCells()
    }
    
    fileprivate var cellPaddingVertical: CGFloat {
        return delegate.setVerticalSpaceBetweenCells()
    }
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    fileprivate var sizes: MozaicCellSize?
    
    override open var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    fileprivate var interactionCount: [Int]?
    
    fileprivate var yOffset: [CGFloat]?
    
    override open func prepare() {
        
        // Set variable 'sizes' with the respect sizes for the device
        self.setSizes()
        
        let columnWidth = self.contentWidth / CGFloat(numberOfColumns)
        
        self.cache.removeAll()
        
        // Instantiate 'interactionPreviousCell', 'iteractionNextCell' and 'isLastSmall' arrays for every column
        self.interactionCount = [Int](repeating: -1, count: self.numberOfColumns)
        var interactionPreviousCell = [MozaicCellType](repeating: .Small, count: self.numberOfColumns)
        var interactionNextCell = [MozaicCellType](repeating: .Small, count: self.numberOfColumns)
        
        //
        var isLastSmall = [Bool](repeating: false, count: self.numberOfColumns)
        
        for i in 0..<self.arrayOfTypes.count {
            interactionPreviousCell[i] = self.arrayOfTypes[i].last!
            interactionNextCell[i] = self.arrayOfTypes[i][1]
        }
        
        // Instantiate 'yOffset' array for every column
        self.yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            
            // Get the actual cell index interaction based on its column
            self.interactionCount![self.actualColumn] = self.setActualCell(forCount: self.interactionCount![self.actualColumn])
            
            self.setState(prev: &interactionPreviousCell, next: &interactionNextCell)
            
            // Get actual cell type
            let actualCellType: MozaicCellType = self.arrayOfTypes[self.actualColumn][self.interactionCount![self.actualColumn]]
            
            var xOffset: CGFloat
            var frame: CGRect
            
            // Defines the cell of this interaction
            let indexPath = IndexPath(item: item, section: 0)
            
            // Check the cell type (The business logic is defined by the cell type)
            if actualCellType == .Small {
                
                // Check if this small cell is the second on this row and column
                if isLastSmall[self.actualColumn] {
                    
                    xOffset = CGFloat(self.actualColumn) * columnWidth + (self.sizes?.smallSize.width)!
                    
                    frame = CGRect(origin: CGPoint(x: xOffset, y: yOffset![self.actualColumn]), size: (self.sizes?.smallSize)!)
                    
                    // Increment yOffset of this column before change the row
                    yOffset![self.actualColumn] += (self.sizes?.smallSize.height)!
                    
                    isLastSmall[self.actualColumn] =  false
                    
                    self.jumpColumn()
                    
                } else {
                    
                    xOffset = CGFloat(self.actualColumn) * columnWidth
                    
                    frame = CGRect(origin: CGPoint(x: xOffset, y: yOffset![self.actualColumn]), size: (self.sizes?.smallSize)!)
                    
                    // Set isLastSmall true when the next cell of the same column is Small too
                    if interactionNextCell[self.actualColumn] == .Small {
                        isLastSmall[self.actualColumn] = true
                    } else {
                        
                        // Increment yOffset of this column, since a Big or Medium cell can't be plotted in this row
                        yOffset![self.actualColumn] += (self.sizes?.smallSize.height)!
                        self.jumpColumn()
                    }
                }
                
            } else {
                
                xOffset = CGFloat(self.actualColumn) * columnWidth
                
                if actualCellType == .Medium {
                    frame = CGRect(origin: CGPoint(x: xOffset, y: yOffset![self.actualColumn]), size: (self.sizes?.mediumSize)!)
                    yOffset![self.actualColumn] += (self.sizes?.mediumSize.height)!
                } else {
                    frame = CGRect(origin: CGPoint(x: xOffset, y: yOffset![self.actualColumn]), size: (self.sizes?.largeSize)!)
                    yOffset![self.actualColumn] += (self.sizes?.largeSize.height)!
                }
                
                self.jumpColumn()
                
            }
            
            // Assign the cell its attributes
            contentHeight = (yOffset?.max()!)!
            let insetFrame = frame.insetBy(dx: cellPaddingHorizontal, dy: cellPaddingVertical)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
        }
        
    }
    
    
    
    // Function that defines the next cell index
    func setActualCell(forCount count: Int) -> Int{
        if count < self.arrayOfTypes[self.actualColumn].count - 1 {
            return count + 1
        } else {
            return 0
        }
    }
    
    
    
    // Function that changes state of variables for each iteration
    func setState(prev: inout [MozaicCellType], next: inout [MozaicCellType]) {
        
        var prevCount = self.interactionCount![self.actualColumn] - 1
        
        var nextCount = self.interactionCount![self.actualColumn] + 1
        
        if nextCount >= self.arrayOfTypes[self.actualColumn].count {
            nextCount = 0
        }
        
        if prevCount < 0 {
            prevCount = self.arrayOfTypes[self.actualColumn].count - 1
        }
        
        prev[self.actualColumn] = self.arrayOfTypes[self.actualColumn][prevCount]
        next[self.actualColumn] = self.arrayOfTypes[self.actualColumn][nextCount]
    }
    
    
    
    // Function that defines which will be the next column
    func jumpColumn() {
        let minorOffset = self.yOffset?.min()
        self.actualColumn = (self.yOffset?.index(of: minorOffset!))!
    }
    
    
    
    // Function that returns the sizes of each MozaicCellType
    func setSizes() {
        let large = CGSize(width: contentWidth / CGFloat(numberOfColumns), height: (contentWidth / CGFloat(numberOfColumns)) * scaleFactor)
        let medium = CGSize(width: (large.width), height: large.height / 2)
        let small = CGSize(width: large.width / 2, height: large.height / 2)
        
        self.sizes = MozaicCellSize(smallSize: small, mediumSize: medium, largeSize: large)
    }
    
    
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
}


// Protocol to encapsulate some functions
public protocol MozaicDelegate {
    
    func setCellHeightProportion() -> CGFloat
    
    func setHorizontalSpaceBetweenCells() -> CGFloat
    
    func setVerticalSpaceBetweenCells() -> CGFloat
    
    func setStyleOfEachColumn() -> [[MozaicCellType]]
    
}

// Extension to return the default values to the optional methods.
public extension MozaicDelegate {
    
    func setCellHeightProportion() -> CGFloat {
        return 1.0
    }
    
    
    
    func setHorizontalSpaceBetweenCells() -> CGFloat {
        return 15.0
    }
    
    
    
    func setVerticalSpaceBetweenCells() -> CGFloat {
        return 15.0
    }
    
}

