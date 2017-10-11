//
//  YAxisLayoutAttributesModel.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 10/11/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import Foundation

class YAxisLayoutAttributesModel {
    
    let decorator: GraphLayoutDecorator
    
    var cache = [IndexPath: UICollectionViewLayoutAttributes]()
    
    init(collectionView: GraphCollectionView) {
        
        self.decorator = GraphLayoutDecorator(collectionView: collectionView)
    }
    
}

extension YAxisLayoutAttributesModel: LayoutAttributesModel {
    
    func indexPathsOfItems(in rect: CGRect) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        //we
        let numberOfItems = decorator.numberOfYSteps() + 1
        
        for number in 0..<numberOfItems {
            let indexPath = IndexPath(item: number, section: 0)
            indexPaths += [indexPath]
        }
        
        return indexPaths
    }
    
    func attributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let numberOfSteps = decorator.numberOfYSteps()
        
        let fullHeight = decorator.contentSize().height
        
        // TODO: change this to a delegate method like the others
        let cellSize = decorator.sizeOfCell(at: IndexPath(item: 0, section: 0))
        
        let fullHeightForAttributes = fullHeight - decorator.paddingForXAttributes - cellSize.height
        
        let heightForAttributes = fullHeightForAttributes / CGFloat(numberOfSteps)
        
        let frame = CGRect(x: 0, y: heightForAttributes * CGFloat(indexPath.item) + cellSize.height / 2 - heightForAttributes / 2, width: decorator.paddingForYAttributes, height: heightForAttributes)
        
        let attribute = XAxisLayoutAttributes(forSupplementaryViewOfKind: .graphLayoutElementKindYAxisView, with: indexPath)
        attribute.frame = frame
        
        return attribute
    }
    
}