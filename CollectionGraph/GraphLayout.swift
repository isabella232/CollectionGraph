//
//  GraphLayout.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/29/16.
//  Copyright © 2016 Collective Idea. All rights reserved.
//

import UIKit

public class GraphLayout: UICollectionViewLayout, RangeFinder {

    internal weak var collectionGraphCellDelegate: CollectionGraphCellDelegate?
    internal weak var collectionGraphBarDelegate: CollectionGraphBarDelegate?

    internal var graphData: [[GraphDatum]]?

    internal var displayBars = false
    internal var displayLineConnectors = false

    internal var ySideBarView: UICollectionReusableView?

    internal var ySteps: Int = 6
    internal var xSteps: Int = 3

    internal var graphContentWidth: CGFloat? // width of graph in points

    internal var cellSize: CGSize = CGSize(width: 3.0, height: 3.0)
    
    private var yIncrements: CGFloat {
        get {
            if let graphData = graphData {
                return yDataRange(graphData: graphData, numberOfSteps: ySteps).max / CGFloat(ySteps)
            }
            return 0
        }
    }

    private let labelsZIndex = Int.max
    private let sideBarZIndex = Int.max - 1

    internal var staticAttributes: [UICollectionViewLayoutAttributes]?
    
    // MARK: - Layout Setup
    
    public override func prepare() {
        super.prepare()
        
        createStaticAttributes()
    }

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {

        return true
    }

    func createStaticAttributes() {
        
        var tempAttributes = [UICollectionViewLayoutAttributes]()
        
        tempAttributes += self.layoutAttributesForCell()
        
        tempAttributes += self.layoutAttributesForXLabels()
        
        if self.displayLineConnectors {
            tempAttributes += self.layoutAttributesForLineConnector()
        }
        
        if self.displayBars {
            tempAttributes += self.layoutAttributesForBar()
        }
        
        self.staticAttributes = tempAttributes
    }

    internal func temporaryAttributes() -> [UICollectionViewLayoutAttributes] {
        var tempAttributes = [UICollectionViewLayoutAttributes]()
        
        tempAttributes += self.layoutAttributesForYDividerLines()

        tempAttributes += self.layoutAttributesForYLabels()

        if ySideBarView != nil {
            tempAttributes += self.layoutAttributesForSideBar()
        }
        
        return tempAttributes
    }
    
    public override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        
        guard let collectionView = self.collectionView else {
            return context
        }
        
        if collectionView.bounds.size != newBounds.size {
            
            return context
        }
        
        invalidateIntermediateIndices(with: context)
        
        return context
    }
    
    private func invalidateIntermediateIndices(with context: UICollectionViewLayoutInvalidationContext) {
        
        guard let collectionView = self.collectionView else {
            return
        }
        
        let dividerLineIndices = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: ReuseIDs.yDividerView.rawValue)
        context.invalidateSupplementaryElements(ofKind: ReuseIDs.yDividerView.rawValue, at: dividerLineIndices)
        
        let yLabelIndices = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: ReuseIDs.yLabelView.rawValue)
        context.invalidateSupplementaryElements(ofKind: ReuseIDs.yLabelView.rawValue, at: yLabelIndices)
        
        let ySideBarIndices = [IndexPath(item: 0, section: 0)]
        context.invalidateDecorationElements(ofKind: ReuseIDs.sideBarView.rawValue, at: ySideBarIndices)
    }

    private func layoutAttributesForCell() -> [UICollectionViewLayoutAttributes] {

        var tempAttributes = [UICollectionViewLayoutAttributes]()

        if let collectionView = collectionView {

            for sectionNumber in 0 ..< collectionView.numberOfSections {

                for itemNumber in 0 ..< collectionView.numberOfItems(inSection: sectionNumber) {

                    let indexPath = IndexPath(item: itemNumber, section: sectionNumber)

                    if let attributes = layoutAttributesForItem(at: indexPath) {
                        tempAttributes += [attributes]
                    }
                }
            }
        }
        return tempAttributes
    }

    private func layoutAttributesForYDividerLines() -> [UICollectionViewLayoutAttributes] {

        var tempAttributes = [UICollectionViewLayoutAttributes]()

        if let collectionView = collectionView {

            if collectionView.numberOfSections > 0 {
                for number in 0 ..< ySteps {

                    let indexPath = IndexPath(item: number, section: 0)

                    let supplementaryAttribute = layoutAttributesForSupplementaryView(ofKind: ReuseIDs.yDividerView.rawValue, at: indexPath)

                    if let supplementaryAttribute = supplementaryAttribute {
                        tempAttributes += [supplementaryAttribute]
                    }
                }
            }
        }
        return tempAttributes
    }

    private func layoutAttributesForYLabels() -> [UICollectionViewLayoutAttributes] {

        var tempAttributes = [UICollectionViewLayoutAttributes]()

        for number in 0 ..< ySteps {

            let indexPath = IndexPath(item: number, section: 0)

            let supplementaryAttribute = layoutAttributesForSupplementaryView(ofKind: ReuseIDs.yLabelView.rawValue, at: indexPath)

            if let supplementaryAttribute = supplementaryAttribute {
                tempAttributes += [supplementaryAttribute]
            }
        }
        return tempAttributes
    }

    private func layoutAttributesForXLabels() -> [UICollectionViewLayoutAttributes] {

        var tempAttributes = [UICollectionViewLayoutAttributes]()

        for number in 0 ..< xSteps {

            let indexPath = IndexPath(item: number, section: 0)

            let supplementaryAttribute = layoutAttributesForSupplementaryView(ofKind: ReuseIDs.xLabelView.rawValue, at: indexPath)

            if let supplementaryAttribute = supplementaryAttribute {
                tempAttributes += [supplementaryAttribute]
            }
        }
        return tempAttributes
    }

    private func layoutAttributesForLineConnector() -> [UICollectionViewLayoutAttributes] {

        var tempAttributes = [UICollectionViewLayoutAttributes]()

        if let collectionView = collectionView {

            for sectionNumber in 0..<collectionView.numberOfSections {
                for itemNumber in 0 ..< collectionView.numberOfItems(inSection: sectionNumber) {

                    let indexPath = IndexPath(item: itemNumber, section: sectionNumber)

                    let supplementaryAttributes = layoutAttributesForSupplementaryView(ofKind: ReuseIDs.lineConnectorView.rawValue, at: indexPath)

                    if let supplementaryAttributes = supplementaryAttributes {
                        tempAttributes += [supplementaryAttributes]
                    }
                }
            }
        }
        return tempAttributes
    }

    private func layoutAttributesForSideBar() -> [UICollectionViewLayoutAttributes] {

        var tempAttributes = [UICollectionViewLayoutAttributes]()

        if let _ = collectionView {
            let indexPath = IndexPath(item: 0, section: 0)
            let attribute = layoutAttributesForDecorationView(ofKind: ReuseIDs.sideBarView.rawValue, at: indexPath)

            if let attribute = attribute {
                tempAttributes += [attribute]
            }
        }

        return tempAttributes
    }

    private func layoutAttributesForBar() -> [UICollectionViewLayoutAttributes] {

        var tempAttributes = [UICollectionViewLayoutAttributes]()

        if let collectionView = collectionView {

            for sectionNumber in 0..<collectionView.numberOfSections {
                for itemNumber in 0 ..< collectionView.numberOfItems(inSection: sectionNumber) {

                    let indexPath = IndexPath(item: itemNumber, section: sectionNumber)

                    let supplementaryAttributes = layoutAttributesForSupplementaryView(ofKind: ReuseIDs.barView.rawValue, at: indexPath)

                    if let supplementaryAttributes = supplementaryAttributes {
                        tempAttributes += [supplementaryAttributes]
                    }
                }
            }
        }
        return tempAttributes
    }

    // MARK: - Set Attributes

    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        if let graphData = graphData, let collectionGraphCellDelegate = collectionGraphCellDelegate {
            cellSize = collectionGraphCellDelegate.collectionGraph(sizeForGraphCellWithData: graphData[indexPath.section][indexPath.item], atIndexPath: indexPath)
        }

        let frame = CGRect(x: xGraphPosition(indexPath: indexPath) - cellSize.width / 2,
                           y: yGraphPosition(indexPath: indexPath) - cellSize.height / 2,
                           width: cellSize.width,
                           height: cellSize.height)

        attributes.frame = frame
        attributes.zIndex = sideBarZIndex - 1 - indexPath.item

        return attributes
    }

    public override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: ReuseIDs.sideBarView.rawValue, with: indexPath)

        if elementKind == ReuseIDs.sideBarView.rawValue {
            if let collectionView = collectionView {

                let width = collectionView.contentInset.left
                let height = collectionView.frame.height
                let verticleInsets = collectionView.contentInset.bottom + collectionView.contentInset.top

                attributes.zIndex = sideBarZIndex

                attributes.frame = CGRect(x: collectionView.contentOffset.x, y: -verticleInsets, width: width, height: height)
            }
        }
        return attributes
    }

    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        if elementKind == ReuseIDs.yDividerView.rawValue {

            return setAttributesForYDivider(fromIndex: indexPath)

        } else if elementKind == ReuseIDs.lineConnectorView.rawValue {

            return setAttributesForLineConnector(fromIndex: indexPath)

        } else if elementKind == ReuseIDs.yLabelView.rawValue {

            return setAttributesForYLabel(fromIndex: indexPath)

        } else if elementKind == ReuseIDs.xLabelView.rawValue {

            return setAttributesForXLabel(fromIndex: indexPath)

        } else if elementKind == ReuseIDs.barView.rawValue {

            return setAttributesForBar(fromIndex: indexPath)

        }
        return nil
    }

    // attribute creation

    private func setAttributesForYDivider(fromIndex indexPath: IndexPath) -> YDividerLayoutAttributes {

        let attributes = YDividerLayoutAttributes(forSupplementaryViewOfKind: ReuseIDs.yDividerView.rawValue, with: indexPath)

        if let collectionView = collectionView {

            let height = (collectionView.bounds.height - (collectionView.contentInset.top + collectionView.contentInset.bottom + cellSize.height)) / CGFloat(ySteps)
            let width = collectionView.bounds.width

            let frame = CGRect(x: collectionView.contentOffset.x,
                               y: height * CGFloat(indexPath.row) + cellSize.height / 2,
                               width: width,
                               height: height)

            attributes.frame = frame
            attributes.inset = collectionView.contentInset.left

            attributes.zIndex = -1
        }
        return attributes
    }

    private func setAttributesForLineConnector(fromIndex indexPath: IndexPath) -> LineConnectorAttributes? {

        let attributes = LineConnectorAttributes(forSupplementaryViewOfKind: ReuseIDs.lineConnectorView.rawValue, with: indexPath)

        if let graphData = graphData {

            if indexPath.item < graphData[indexPath.section].count - 1 {

                let xOffset = xGraphPosition(indexPath: indexPath)
                let yOffset = yGraphPosition(indexPath: indexPath) - cellSize.height / 2

                let nextIndex = IndexPath(item: indexPath.item + 1, section: indexPath.section)

                let xOffset2 = xGraphPosition(indexPath: nextIndex)
                let yOffset2 = yGraphPosition(indexPath: nextIndex) - cellSize.height / 2

                let p1 = CGPoint(x: xOffset,
                                 y: yOffset)

                let p2 = CGPoint(x: xOffset2,
                                 y: yOffset2)

                // create a Rect between the two points
                if let collectionView = collectionView {

                    let height = collectionView.bounds.height - (collectionView.contentInset.top + collectionView.contentInset.bottom + cellSize.height)

                    let rect = CGRect(x: min(p1.x, p2.x),
                                      y: cellSize.height / 2,
                                      width: fabs(p1.x - p2.x),
                                      height: height)

                    attributes.frame = rect
                }

                attributes.points = (first: p1, second: p2)

                attributes.zIndex = indexPath.section

                return attributes
            }
        }
        return nil
    }

    private func setAttributesForYLabel(fromIndex indexPath: IndexPath) -> XLabelViewAttributes {

        let attributes = XLabelViewAttributes(forSupplementaryViewOfKind: ReuseIDs.yLabelView.rawValue, with: indexPath)

        if let collectionView = collectionView {

            let height = (collectionView.bounds.height - (collectionView.contentInset.top + collectionView.contentInset.bottom + cellSize.height)) / CGFloat(ySteps)
            let width = collectionView.contentInset.left

            let frame = CGRect(x: collectionView.contentOffset.x,
                               y: (height * CGFloat(indexPath.row)) - (height / 2) + cellSize.height / 2,
                               width: width,
                               height: height)

            attributes.frame = frame

            attributes.zIndex = labelsZIndex

        }
        return attributes
    }

    private func setAttributesForXLabel(fromIndex indexPath: IndexPath) -> XLabelViewAttributes {

        let attributes = XLabelViewAttributes(forSupplementaryViewOfKind: ReuseIDs.xLabelView.rawValue, with: indexPath)

        if let collectionView = collectionView {

            let height = collectionView.contentInset.bottom

            let collectionWidth = graphContentWidth ?? collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right + cellSize.width)

            let width = xSteps == 1 ? collectionWidth : collectionWidth / CGFloat(xSteps - 1)

            let xPosition = (width * CGFloat(indexPath.item) - width / 2) + cellSize.width / 2

            let yPosition = collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom

            let frame = CGRect(x: xPosition,
                               y: yPosition,
                               width: width,
                               height: height)

            attributes.frame = frame

            attributes.zIndex = labelsZIndex
        }
        return attributes
    }

     private func setAttributesForBar(fromIndex indexPath: IndexPath) -> UICollectionViewLayoutAttributes {

        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: ReuseIDs.barView.rawValue, with: indexPath)

        var width: CGFloat = cellSize.width

        if let graphData = graphData, let collectionGraphBarDelegate = collectionGraphBarDelegate {
            width = collectionGraphBarDelegate.collectionGraph(widthForBarViewWithData: graphData[indexPath.section][indexPath.item], atIndexPath: indexPath)
        }

        var heightOfCollectionView: CGFloat = 0

        if let collectionView = collectionView {
            heightOfCollectionView = collectionView.bounds.height - (collectionView.contentInset.top + collectionView.contentInset.bottom + cellSize.height)
        }

        let barHeight = heightOfCollectionView - yGraphPosition(indexPath: indexPath) + cellSize.height / 2
        let yPosition = heightOfCollectionView - (heightOfCollectionView - yGraphPosition(indexPath: indexPath))

        attributes.frame = CGRect(x: xGraphPosition(indexPath: indexPath) - width / 2,
                                  y: yPosition,
                                  width: width,
                                  height: barHeight)

        attributes.zIndex = indexPath.item

        return attributes
    }

    // MARK: - Layout

    public override var collectionViewContentSize: CGSize {
        if let collectionView = collectionView {

            let initialSize = collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)

            var width = initialSize

            if let graphContentWidth = graphContentWidth {
                width = graphContentWidth + cellSize.width
            }

            let height = collectionView.bounds.height - (collectionView.contentInset.top + collectionView.contentInset.bottom + cellSize.height)

            let contentSize = CGSize(width: width, height: height)

            return contentSize
        }

        return CGSize.zero
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributes = [UICollectionViewLayoutAttributes]()
        
        attributes += temporaryAttributes()
        
        for staticAttributes in staticAttributes! {
            if staticAttributes.frame.intersects(rect) {
                attributes += [staticAttributes]
            }
        }
        
        return attributes
    }

    // MARK: - Helpers

    private func xGraphPosition(indexPath: IndexPath) -> CGFloat {
        if let graphData = graphData, let collectionView = collectionView {

            let width = graphContentWidth ?? collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right + cellSize.width)

            let xRange = xDataRange(graphData: graphData)

            let xDeltaRange = xRange.max - xRange.min

            var xValPercent = (graphData[indexPath.section][indexPath.item].point.x - xRange.min) / xDeltaRange

            if xValPercent.isNaN {
                xValPercent = 0
            }

            let xPos = width * xValPercent + cellSize.width / 2

            return xPos
        }
       return 0
    }

    private func yGraphPosition(indexPath: IndexPath) -> CGFloat {
        if let collectionView = collectionView, let graphData = graphData {
            let delta = collectionView.bounds.height - (collectionView.contentInset.top + collectionView.contentInset.bottom + cellSize.height)

            let yRange = yDataRange(graphData: graphData, numberOfSteps: ySteps)

            let position = delta - (delta * (graphData[indexPath.section][indexPath.item].point.y / yRange.max)) + cellSize.height / 2

            return position.isNaN ? 0 : position
        }
        return 0
    }

}
