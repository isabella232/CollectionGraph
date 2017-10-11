//
//  XLabelReusableView.swift
//  CollectionGraph
//
//  Created by Ben Lambert on 9/5/17.
//  Copyright © 2017 collectiveidea. All rights reserved.
//

import UIKit

internal class XAxisLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var value: CGFloat = 0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone)
        if let copy = copy as? XAxisLayoutAttributes {
            copy.value = value
        }
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? XAxisLayoutAttributes {
            if attributes.value == value {
                return super.isEqual(object)
            }
        }
        return false
    }
    
}

open class XAxisReusableView: UICollectionReusableView {

    public var value: CGFloat = 0.0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? XAxisLayoutAttributes {
            value = attributes.value
        }
    }

}

open class XLabelReusableView: XAxisReusableView {
    
    public let label: UILabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addConstraintsToLabel()
    }
    
    func addConstraintsToLabel() {
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        label.text = "\(value)"
        label.sizeToFit()
    }
    
}