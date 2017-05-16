//
//  UIView+Pins.swift
//  Pins
//
//  Created by John Duff on 2017-05-12.
//  Copyright © 2017 John Duff. All rights reserved.
//

/// Horizontal representation that should be used to pin the anchor.
///
/// - leading: The leading edge of the object's alignment rectangle.
/// - trailing: The trailing edge of the object's alignment rectangle.
/// - left: The left side of the object's alignment rectangle.
/// - right: The right side of the object's alignment rectangle.
/// - centerX: The center along the x-axis of the object's alignment rectangle.
public enum HorizontalAnchor {
    case leading, trailing, left, right, centerX
}


/// Vertical representation that should be used to pin the anchor.
///
/// - top: The top of the object's alignment rectangle.
/// - bottom: The bottom of the object's alignment rectangle.
/// - centerY: The center along the y-axis of the object's alignment rectangle.
/// - firstBaseline: The object's baseline. For objects with more than one line of text, this is the baseline for the topmost line of text.
/// - lastBaseline: The object's baseline. For objects with more than one line of text, this is the baseline for the bottommost line of text.
public enum VerticalAnchor {
    case top, bottom, centerY, firstBaseline, lastBaseline
}

/// Dimension representation that should be used to pin the anchor.
///
/// - width: The width of the object's alignment rectangle
/// - height: The height of the object's alignment rectangle
public enum DimensionAnchor {
    case width, height
}

// MARK: - Extentions to add `pin` methods to `UIView` objects.
public extension UIView {

    /// Pin view boundries to the specified anchors. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - left: Optional anchor to pin the left of the view to. Must be a `NSLayoutXAxisAnchor`.
    ///   - top: Optional anchor to pin the top of the view to. Must be a `NSLayoutYAxisAnchor`.
    ///   - right: Optional anchor to pin the right of the view to. Must be a `NSLayoutXAxisAnchor`.
    ///   - bottom: Optional anchor to pin the bottom of the view to. Must be a `NSLayoutYAxisAnchor`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: Array of activated `NSLayoutConstraint` objects that were created.
    @discardableResult
    func pin(leftTo left: NSLayoutAnchor<NSLayoutXAxisAnchor>?, topTo top: NSLayoutAnchor<NSLayoutYAxisAnchor>?, rightTo right: NSLayoutAnchor<NSLayoutXAxisAnchor>?, bottomTo bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>?, padding: CGFloat = 0.0) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        if let left = left {
            constraints.append(pin(.left, to: left, padding: padding))
        }
        if let top = top {
            constraints.append(pin(.top, to: top, padding: padding))
        }
        if let right = right {
            constraints.append(pin(.right, to: right, padding: padding))
        }
        if let bottom = bottom {
            constraints.append(pin(.bottom, to: bottom, padding: padding))
        }

        return constraints
    }

    /// Pin the specified `HorizontalAnchor` of the view to another anchor. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - edge: `HorizontalAnchor` of the caller to pin to. One of `leading`, `trailing`, `left`, `right` or `centerX`.
    ///   - anchorAttachment: Anchor to pin the view to. Must be a `NSLayoutXAxisAnchor`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ edge: HorizontalAnchor, to anchorAttachment: NSLayoutAnchor<NSLayoutXAxisAnchor>, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = anchor(for: edge).constraint(equalTo: anchorAttachment, constant: padding)
        constraint.isActive = true

        translatesAutoresizingMaskIntoConstraints = false
        return constraint
    }

    /// Pin the specified `VerticalAnchor` of the view to another view anchor. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - edge: `VerticalAnchor` of the caller to pin to. One of `top`, `bottom`, `centerY`, `firstBaseline` or `lastBaseline`.
    ///   - anchorAttachment: Anchor to pin the view to. Must be a `NSLayoutYAxisAnchor`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ edge: VerticalAnchor, to anchorAttachment: NSLayoutAnchor<NSLayoutYAxisAnchor>, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = anchor(for: edge).constraint(equalTo: anchorAttachment, constant: padding)
        constraint.isActive = true

        translatesAutoresizingMaskIntoConstraints = false
        return constraint
    }

    /// Pin the specified `DimensionAnchor` of the view to another view anchor. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - dimension: `DimensionAnchor` of the caller to pin to. Either `width` or `height`.
    ///   - anchorAttachment: Anchor to pin the view to. Must be a `NSLayoutDimension`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ dimension: DimensionAnchor, to anchorAttachment: NSLayoutAnchor<NSLayoutDimension>, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = anchor(for: dimension).constraint(equalTo: anchorAttachment, constant: padding)
        constraint.isActive = true

        translatesAutoresizingMaskIntoConstraints = false
        return constraint
    }

    /// Pin the specified `DimensionAnchor` of the view to a fixed size. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - dimension: `DimensionAnchor` of the caller to pin to. Either `width` or `height`.
    ///   - size: Size to pin the `DimensionAnchor` to.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ dimension: DimensionAnchor, size: CGFloat) -> NSLayoutConstraint {
        let constraint = anchor(for: dimension).constraint(equalToConstant: size)
        constraint.isActive = true

        translatesAutoresizingMaskIntoConstraints = false
        return constraint
    }

    /// Pin the height and width of the view to a fixed size. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - height: Optional height to pin the view to.
    ///   - width: Optional width to pin the view to.
    /// - Returns: Array of activated `NSLayoutConstraint` objects that were created.
    @discardableResult
    func pin(height: CGFloat?, width: CGFloat?) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        if let height = height {
            constraints.append(pin(.height, size: height))
        }
        if let width = width {
            constraints.append(pin(.width, size: width))
        }

        return constraints
    }

    // MARK: Private helper methods.
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
}
