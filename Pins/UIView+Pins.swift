//
//  UIView+Pins.swift
//  Pins
//
//  Created by John Duff on 2017-05-12.
//  Copyright © 2017 John Duff. All rights reserved.
//

public enum HorizontalAnchor {
    case leading, trailing, left, right, centerX
}

public enum VerticalAnchor {
    case top, bottom, centerY, firstBaseline, lastBaseline
}

public enum DimensionAnchor {
    case width, height
}

public extension UIView {
    private func anchor(for anchor: HorizontalAnchor) -> NSLayoutAnchor<NSLayoutXAxisAnchor> {
        switch anchor {
        case .leading:
            return leadingAnchor
        case .trailing:
            return trailingAnchor
        case .left:
            return leftAnchor
        case .right:
            return rightAnchor
        case .centerX:
            return centerXAnchor
        }
    }

    private func anchor(for anchor: VerticalAnchor) -> NSLayoutAnchor<NSLayoutYAxisAnchor> {
        switch anchor {
        case .top:
            return topAnchor
        case .bottom:
            return bottomAnchor
        case .centerY:
            return centerYAnchor
        case .firstBaseline:
            return firstBaselineAnchor
        case .lastBaseline:
            return lastBaselineAnchor
        }
    }

    private func anchor(for anchor: DimensionAnchor) -> NSLayoutDimension {
        switch anchor {
        case .width:
            return widthAnchor
        case .height:
            return heightAnchor
        }
    }


    @discardableResult
    func pin(leftTo left: NSLayoutAnchor<NSLayoutXAxisAnchor>?, topTo top: NSLayoutAnchor<NSLayoutYAxisAnchor>?, rightTo right: NSLayoutAnchor<NSLayoutXAxisAnchor>?, bottomTo bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>?, padding: CGFloat = 0.0) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        if left != nil {
            constraints.append(leftAnchor.constraint(equalTo: left!, constant: padding))
        }
        if top != nil {
            constraints.append(topAnchor.constraint(equalTo: top!, constant: padding))
        }
        if right != nil {
            constraints.append(rightAnchor.constraint(equalTo: right!, constant: padding))
        }
        if bottom != nil {
            constraints.append(bottomAnchor.constraint(equalTo: bottom!, constant: padding))
        }

        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult
    func pin(_ edge: HorizontalAnchor, to anchorAttachment: NSLayoutAnchor<NSLayoutXAxisAnchor>, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = anchor(for: edge).constraint(equalTo: anchorAttachment, constant: padding)
        constraint.isActive = true

        return constraint
    }

    @discardableResult
    func pin(_ edge: VerticalAnchor, to anchorAttachment: NSLayoutAnchor<NSLayoutYAxisAnchor>, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = anchor(for: edge).constraint(equalTo: anchorAttachment, constant: padding)
        constraint.isActive = true

        return constraint
    }

    @discardableResult
    func pin(_ dimension: DimensionAnchor, to anchorAttachment: NSLayoutAnchor<NSLayoutDimension>, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = anchor(for: dimension).constraint(equalTo: anchorAttachment, constant: padding)
        constraint.isActive = true

        return constraint
    }

    @discardableResult
    func pin(_ dimension: DimensionAnchor, size: CGFloat) -> NSLayoutConstraint {
        let constraint = anchor(for: dimension).constraint(equalToConstant: size)
        constraint.isActive = true

        return constraint
    }

    @discardableResult
    func pin(height: CGFloat?, width: CGFloat?) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        if height != nil {
            constraints.append(heightAnchor.constraint(equalToConstant: height!))
        }
        if width != nil {
            constraints.append(widthAnchor.constraint(equalToConstant: width!))
        }

        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}
