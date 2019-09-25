//
//  View+Pins.swift
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

public protocol Pinnable: class {
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    var heightAnchor: NSLayoutDimension { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var firstBaselineAnchor: NSLayoutYAxisAnchor { get }
    var lastBaselineAnchor: NSLayoutYAxisAnchor { get }

    var translatesAutoresizingMaskIntoConstraints: Bool { get set }
}

public extension Pinnable {
    // Stub methods that are missing so UILayoutGuid and NsLayoutGuid will conform
    var firstBaselineAnchor: NSLayoutYAxisAnchor {
        return topAnchor
    }

    var lastBaselineAnchor: NSLayoutYAxisAnchor {
        return bottomAnchor
    }

    var translatesAutoresizingMaskIntoConstraints: Bool {
        get {
            return true
        }
        set {}
    }
}

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
    extension UIView: Pinnable {}
    extension UILayoutGuide: Pinnable {}
#elseif os(OSX)
    import Cocoa
    extension NSView: Pinnable {}
    extension NSLayoutGuide: Pinnable {}
#endif

public extension Pinnable {
    // MARK: Convenience Pinning Methods
    
    /// Pin view boundries to the specified anchors. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - leading: Optional anchor to pin the left of the view to. Must be a `NSLayoutXAxisAnchor`.
    ///   - top: Optional anchor to pin the top of the view to. Must be a `NSLayoutYAxisAnchor`.
    ///   - trailing: Optional anchor to pin the right of the view to. Must be a `NSLayoutXAxisAnchor`.
    ///   - bottom: Optional anchor to pin the bottom of the view to. Must be a `NSLayoutYAxisAnchor`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: Array of activated `NSLayoutConstraint` objects that were created.
    @discardableResult
    func pin(leadingTo leading: NSLayoutAnchor<NSLayoutXAxisAnchor>?, topTo top: NSLayoutAnchor<NSLayoutYAxisAnchor>?, trailingTo trailing: NSLayoutAnchor<NSLayoutXAxisAnchor>?, bottomTo bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>?, padding: CGFloat = 0.0) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        if let leading = leading {
            constraints.append(pin(.leading, to: leading, padding: padding))
        }
        if let top = top {
            constraints.append(pin(.top, to: top, padding: padding))
        }
        if let trailing = trailing {
            constraints.append(pin(.trailing, to: trailing, padding: padding))
        }
        if let bottom = bottom {
            constraints.append(pin(.bottom, to: bottom, padding: padding))
        }

        return constraints
    }

    /// Pin view boundries to the corresponding anchors on the specified views. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - leading: Optional view to pin the left of this view to. Must be a `View` or `LayoutGuide`.
    ///   - top: Optional view to pin the top of this view to. Must be a `View` or `LayoutGuide`.
    ///   - trailing: Optional view to pin the right of this view to. Must be a `View` or `LayoutGuide`.
    ///   - bottom: Optional view to pin the bottom of this view to. Must be a `View` or `LayoutGuide`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: Array of activated `NSLayoutConstraint` objects that were created.
    @discardableResult
    func pin<View: Pinnable>(leadingTo leading: View?, topTo top: View?, trailingTo trailing: View?, bottomTo bottom: View?, padding: CGFloat = 0.0) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        if let leading = leading {
            constraints.append(pin(.leading, to: leading, padding: padding))
        }
        if let top = top {
            constraints.append(pin(.top, to: top, padding: padding))
        }
        if let trailing = trailing {
            constraints.append(pin(.trailing, to: trailing, padding: padding))
        }
        if let bottom = bottom {
            constraints.append(pin(.bottom, to: bottom, padding: padding))
        }

        return constraints
    }

    /// Pin view boundries to the specified view. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - view: View to pin this view to. Must be a `View` or `LayoutGuide`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: Array of activated `NSLayoutConstraint` objects that were created.
    @discardableResult
    func pin<View: Pinnable>(to view: View, padding: CGFloat = 0.0) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        constraints.append(pin(.leading, to: view, padding: padding))
        constraints.append(pin(.top, to: view, padding: padding))
        constraints.append(pin(.trailing, to: view, padding: padding))
        constraints.append(pin(.bottom, to: view, padding: padding))

        return constraints
    }

    /// Pin view horizontal anchors to the specified anchors. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - leading: Optional anchor to pin the leading of the view to. Must be a `NSLayoutXAxisAnchor`.
    ///   - trailing: Optional anchor to pin the trailing of the view to. Must be a `NSLayoutXAxisAnchor`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: Array of activated `NSLayoutConstraint` objects that were created.
    @discardableResult
    func pin(leadingTo leading: NSLayoutAnchor<NSLayoutXAxisAnchor>, trailingTo trailing: NSLayoutAnchor<NSLayoutXAxisAnchor>, padding: CGFloat = 0.0) -> [NSLayoutConstraint] {

        return [pin(.leading, to: leading, padding: padding),
                pin(.trailing, to: trailing, padding: padding)]
    }

    /// Pin view horizontal anchors to the corresponding anchors on the specified views. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - leading: Optional view to pin the leading of this view to. Must be a `View` or `LayoutGuide`.
    ///   - trailing: Optional view to pin the trailing of this view to. Must be a `View` or `LayoutGuide`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: Array of activated `NSLayoutConstraint` objects that were created.
    @discardableResult
    func pin<View:Pinnable>(leadingTo leading: View, trailingTo trailing: View, padding: CGFloat = 0.0) -> [NSLayoutConstraint] {

        return [pin(.leading, to: leading, padding: padding),
                pin(.trailing, to: trailing, padding: padding)]
    }

    /// Pin view horizontal anchors to the specified anchors. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - left: Optional anchor to pin the left of the view to. Must be a `NSLayoutXAxisAnchor`.
    ///   - right: Optional anchor to pin the right of the view to. Must be a `NSLayoutXAxisAnchor`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: Array of activated `NSLayoutConstraint` objects that were created.
    @discardableResult
    func pin(leftTo left: NSLayoutAnchor<NSLayoutXAxisAnchor>, rightTo right: NSLayoutAnchor<NSLayoutXAxisAnchor>, padding: CGFloat = 0.0) -> [NSLayoutConstraint] {

        return [pin(.left, to: left, padding: padding),
                pin(.right, to: right, padding: padding)]
    }

    /// Pin view horizontal anchors to the corresponding anchors on the specified views. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - left: Optional view to pin the left of this view to. Must be a `View` or `LayoutGuide`.
    ///   - right: Optional view to pin the right of this view to. Must be a `View` or `LayoutGuide`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: Array of activated `NSLayoutConstraint` objects that were created.
    @discardableResult
    func pin<View: Pinnable>(leftTo left: View, rightTo right: View, padding: CGFloat = 0.0) -> [NSLayoutConstraint] {

        return [pin(.left, to: left, padding: padding),
                pin(.right, to: right, padding: padding)]
    }

    /// Pin view vertical anchors to the specified anchors. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - top: Optional anchor to pin the top of the view to. Must be a `NSLayoutYAxisAnchor`.
    ///   - bottom: Optional anchor to pin the right of the view to. Must be a `NSLayoutYAxisAnchor`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: Array of activated `NSLayoutConstraint` objects that were created.
    @discardableResult
    func pin(topTo top: NSLayoutAnchor<NSLayoutYAxisAnchor>, bottomTo bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>, padding: CGFloat = 0.0) -> [NSLayoutConstraint] {

        return [pin(.top, to: top, padding: padding),
                pin(.bottom, to: bottom, padding: padding)]
    }

    /// Pin view vertical anchors to the corresponding anchors on the specified views. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - top: Optional view to pin the top of this view to. Must be a `View` or `LayoutGuide`.
    ///   - bottom: Optional view to pin the bottom of this view to. Must be a `View` or `LayoutGuide`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: Array of activated `NSLayoutConstraint` objects that were created.
    @discardableResult
    func pin<View: Pinnable>(topTo top: View, bottomTo bottom: View, padding: CGFloat = 0.0) -> [NSLayoutConstraint] {

        return [pin(.top, to: top, padding: padding),
                pin(.bottom, to: bottom, padding: padding)]
    }

    // MARK: Horizontal Anchors
    
    /// Pin the specified `HorizontalAnchor` of the view equal to another anchor. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - edge: `HorizontalAnchor` of the caller to pin to. One of `leading`, `trailing`, `left`, `right` or `centerX`.
    ///   - anchorAttachment: Anchor to pin the view to. Must be a `NSLayoutXAxisAnchor`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ edge: HorizontalAnchor, to anchorAttachment: NSLayoutAnchor<NSLayoutXAxisAnchor>, padding: CGFloat = 0.0) -> NSLayoutConstraint {

        let constraint = anchor(self, for: edge).constraint(equalTo: anchorAttachment,
                                                            constant: convertPadding(edge, padding))

        return disableTranslatesAutoresizingMaskAndActivate(constraint)
    }

    /// Pin the specified `HorizontalAnchor` of the view less than or equal to another anchor. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - edge: `HorizontalAnchor` of the caller to pin to. One of `leading`, `trailing`, `left`, `right` or `centerX`.
    ///   - anchorAttachment: Anchor to pin the view to. Must be a `NSLayoutXAxisAnchor`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ edge: HorizontalAnchor, lessThanOrEqualTo anchorAttachment: NSLayoutAnchor<NSLayoutXAxisAnchor>, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = anchor(self, for: edge).constraint(lessThanOrEqualTo: anchorAttachment,
                                                            constant: convertPadding(edge, padding))

        return disableTranslatesAutoresizingMaskAndActivate(constraint)
    }

    /// Pin the specified `HorizontalAnchor` of the view greater than equal to another anchor. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - edge: `HorizontalAnchor` of the caller to pin to. One of `leading`, `trailing`, `left`, `right` or `centerX`.
    ///   - anchorAttachment: Anchor to pin the view to. Must be a `NSLayoutXAxisAnchor`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ edge: HorizontalAnchor, greaterThanOrEqualTo anchorAttachment: NSLayoutAnchor<NSLayoutXAxisAnchor>, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = anchor(self, for: edge).constraint(greaterThanOrEqualTo: anchorAttachment,
                                                            constant: convertPadding(edge, padding))

        return disableTranslatesAutoresizingMaskAndActivate(constraint)
    }

    /// Pin the specified `HorizontalAnchor` of the view equal to the same anchor on another view. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - edge: `HorizontalAnchor` of the caller to pin to. One of `leading`, `trailing`, `left`, `right` or `centerX`.
    ///   - view: View to pin the caller to. Pins to the same anchor as `edge`. Must be a `View` or `LayoutGuide`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin<View: Pinnable>(_ edge: HorizontalAnchor, to view: View, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        return pin(edge, to: anchor(view, for: edge), padding: padding)
    }

    /// Pin the specified `HorizontalAnchor` of the view less than or equal to the same anchor on another view. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - edge: `HorizontalAnchor` of the caller to pin to. One of `leading`, `trailing`, `left`, `right` or `centerX`.
    ///   - view: View to pin the caller to. Pins to the same anchor as `edge`. Must be a `View` or `LayoutGuide`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin<View: Pinnable>(_ edge: HorizontalAnchor, lessThanOrEqualTo view: View, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        return pin(edge, lessThanOrEqualTo: anchor(view, for: edge), padding: padding)
    }

    /// Pin the specified `HorizontalAnchor` of the view greater than equal to the same anchor on another view. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - edge: `HorizontalAnchor` of the caller to pin to. One of `leading`, `trailing`, `left`, `right` or `centerX`.
    ///   - view: View to pin the caller to. Pins to the same anchor as `edge`. Must be a `View` or `LayoutGuide`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin<View: Pinnable>(_ edge: HorizontalAnchor, greaterThanOrEqualTo view: View, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        return pin(edge, greaterThanOrEqualTo: anchor(view, for: edge), padding: padding)
    }
    
    // MARK: Vertical Anchors

    /// Pin the specified `VerticalAnchor` of the view equal to another anchor. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - edge: `VerticalAnchor` of the caller to pin to. One of `top`, `bottom`, `centerY`, `firstBaseline` or `lastBaseline`.
    ///   - anchorAttachment: Anchor to pin the view to. Must be a `NSLayoutYAxisAnchor`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ edge: VerticalAnchor, to anchorAttachment: NSLayoutAnchor<NSLayoutYAxisAnchor>, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = anchor(self, for: edge).constraint(equalTo: anchorAttachment,
                                                            constant: convertPadding(edge, padding))

        return disableTranslatesAutoresizingMaskAndActivate(constraint)
    }

    /// Pin the specified `VerticalAnchor` of the view less than or equal to another anchor. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - edge: `VerticalAnchor` of the caller to pin to. One of `top`, `bottom`, `centerY`, `firstBaseline` or `lastBaseline`.
    ///   - anchorAttachment: Anchor to pin the view to. Must be a `NSLayoutYAxisAnchor`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ edge: VerticalAnchor, lessThanOrEqualTo anchorAttachment: NSLayoutAnchor<NSLayoutYAxisAnchor>, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = anchor(self, for: edge).constraint(lessThanOrEqualTo: anchorAttachment,
                                                            constant: convertPadding(edge, padding))

        return disableTranslatesAutoresizingMaskAndActivate(constraint)
    }

    /// Pin the specified `VerticalAnchor` of the view greater than or equal to another anchor. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - edge: `VerticalAnchor` of the caller to pin to. One of `top`, `bottom`, `centerY`, `firstBaseline` or `lastBaseline`.
    ///   - anchorAttachment: Anchor to pin the view to. Must be a `NSLayoutYAxisAnchor`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ edge: VerticalAnchor, greaterThanOrEqualTo anchorAttachment: NSLayoutAnchor<NSLayoutYAxisAnchor>, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = anchor(self, for: edge).constraint(greaterThanOrEqualTo: anchorAttachment,
                                                            constant: convertPadding(edge, padding))

        return disableTranslatesAutoresizingMaskAndActivate(constraint)
    }

    /// Pin the specified `VerticalAnchor` of the view equal to the same anchor on another view. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - edge: `VerticalAnchor` of the caller to pin to. One of `top`, `bottom`, `centerY`, `firstBaseline` or `lastBaseline`.
    ///   - view: View to pin the caller to. Pins to the same anchor as `edge`. Must be a `View` or `LayoutGuide`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin<View: Pinnable>(_ edge: VerticalAnchor, to view: View, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        return pin(edge, to: anchor(view, for: edge), padding: padding)
    }

    /// Pin the specified `VerticalAnchor` of the view less than or equal to the same anchor on another view. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - edge: `VerticalAnchor` of the caller to pin to. One of `top`, `bottom`, `centerY`, `firstBaseline` or `lastBaseline`.
    ///   - view: View to pin the caller to. Pins to the same anchor as `edge`. Must be a `View` or `LayoutGuide`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin<View: Pinnable>(_ edge: VerticalAnchor, lessThanOrEqualTo view: View, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        return pin(edge, lessThanOrEqualTo: anchor(view, for: edge), padding: padding)
    }

    /// Pin the specified `VerticalAnchor` of the view greater than or equal to the same anchor on another view. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - edge: `VerticalAnchor` of the caller to pin to. One of `top`, `bottom`, `centerY`, `firstBaseline` or `lastBaseline`.
    ///   - view: View to pin the caller to. Pins to the same anchor as `edge`. Must be a `View` or `LayoutGuide`.
    ///   - padding: Optional padding to add between the anchors.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin<View: Pinnable>(_ edge: VerticalAnchor, greaterThanOrEqualTo view: View, padding: CGFloat = 0.0) -> NSLayoutConstraint {
        return pin(edge, greaterThanOrEqualTo: anchor(view, for: edge), padding: padding)
    }
    
    // MARK: Dimension Anchors

    /// Pin the specified `DimensionAnchor` of the view to another anchor. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - dimension: `DimensionAnchor` of the caller to pin to. Either `width` or `height`.
    ///   - anchorAttachment: Anchor to pin the view to. Must be a `NSLayoutDimension`.
    ///   - padding: Optional padding to add between the anchors.
    ///   - multiplier: Optional multiplier with a default value of 1.0. When used, the result will be anchorValue * multiplier + constant
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ dimension: DimensionAnchor, to anchorAttachment: NSLayoutAnchor<NSLayoutDimension>, padding: CGFloat = 0.0, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = anchor(self, for: dimension).constraint(equalTo: anchorAttachment as! NSLayoutDimension, multiplier: multiplier, constant: padding)

        return disableTranslatesAutoresizingMaskAndActivate(constraint)
    }

    /// Pin the specified `DimensionAnchor` of the view less than or equal to another anchor. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - dimension: `DimensionAnchor` of the caller to pin to. Either `width` or `height`.
    ///   - anchorAttachment: Anchor to pin the view to. Must be a `NSLayoutDimension`.
    ///   - padding: Optional padding to add between the anchors.
    ///   - multiplier: Optional multiplier with a default value of 1.0. When used, the result will be anchorValue * multiplier + constant
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ dimension: DimensionAnchor, lessThanOrEqualTo anchorAttachment: NSLayoutAnchor<NSLayoutDimension>, padding: CGFloat = 0.0, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = anchor(self, for: dimension).constraint(lessThanOrEqualTo: anchorAttachment as! NSLayoutDimension, multiplier: multiplier, constant: padding)

        return disableTranslatesAutoresizingMaskAndActivate(constraint)
    }

    /// Pin the specified `DimensionAnchor` of the view greater than or equal to another anchor. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - dimension: `DimensionAnchor` of the caller to pin to. Either `width` or `height`.
    ///   - anchorAttachment: Anchor to pin the view to. Must be a `NSLayoutDimension`.
    ///   - padding: Optional padding to add between the anchors.
    ///   - multiplier: Optional multiplier with a default value of 1.0. When used, the result will be anchorValue * multiplier + constant
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ dimension: DimensionAnchor, greaterThanOrEqualTo anchorAttachment: NSLayoutAnchor<NSLayoutDimension>, padding: CGFloat = 0.0, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        let constraint = anchor(self, for: dimension).constraint(greaterThanOrEqualTo: anchorAttachment as! NSLayoutDimension, multiplier: multiplier, constant: padding)

        return disableTranslatesAutoresizingMaskAndActivate(constraint)
    }

    /// Pin the specified `DimensionAnchor` of the view to the same anchor on another view. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - dimension: `DimensionAnchor` of the caller to pin to. Either `width` or `height`.
    ///   - view: View to pin the caller to. Pins to the same anchor as `edge`. Must be a `View` or `LayoutGuide`.
    ///   - padding: Optional padding to add between the anchors.
    ///   - multiplier: Optional multiplier with a default value of 1.0. When used, the result will be anchorValue * multiplier + constant
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin<View: Pinnable>(_ dimension: DimensionAnchor, to view: View, padding: CGFloat = 0.0, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        return pin(dimension, to: anchor(view, for: dimension), padding: padding, multiplier: multiplier)
    }

    /// Pin the specified `DimensionAnchor` of the view less than or equal to the same anchor on another view. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - dimension: `DimensionAnchor` of the caller to pin to. Either `width` or `height`.
    ///   - view: View to pin the caller to. Pins to the same anchor as `edge`. Must be a `View` or `LayoutGuide`.
    ///   - padding: Optional padding to add between the anchors.
    ///   - multiplier: Optional multiplier with a default value of 1.0. When used, the result will be anchorValue * multiplier + constant
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin<View: Pinnable>(_ dimension: DimensionAnchor, lessThanOrEqualTo view: View, padding: CGFloat = 0.0, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        return pin(dimension, lessThanOrEqualTo: anchor(view, for: dimension), padding: padding, multiplier: multiplier)
    }

    /// Pin the specified `DimensionAnchor` of the view greater than or equal to the same anchor on another view. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - dimension: `DimensionAnchor` of the caller to pin to. Either `width` or `height`.
    ///   - view: View to pin the caller to. Pins to the same anchor as `edge`. Must be a `View` or `LayoutGuide`.
    ///   - padding: Optional padding to add between the anchors.
    ///   - multiplier: Optional multiplier with a default value of 1.0. When used, the result will be anchorValue * multiplier + constant
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin<View: Pinnable>(_ dimension: DimensionAnchor, greaterThanOrEqualTo view: View, padding: CGFloat = 0.0, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        return pin(dimension, greaterThanOrEqualTo: anchor(view, for: dimension), padding: padding, multiplier: multiplier)
    }

    /// Pin the specified `DimensionAnchor` of the view equal to a fixed size. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - dimension: `DimensionAnchor` of the caller to pin to. Either `width` or `height`.
    ///   - size: Size to pin the `DimensionAnchor` to.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ dimension: DimensionAnchor, to size: CGFloat) -> NSLayoutConstraint {
        let constraint = anchor(self, for: dimension).constraint(equalToConstant: size)

        return disableTranslatesAutoresizingMaskAndActivate(constraint)
    }

    /// Pin the specified `DimensionAnchor` of the view less than or equal to a fixed size. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - dimension: `DimensionAnchor` of the caller to pin to. Either `width` or `height`.
    ///   - size: Size to pin the `DimensionAnchor` to.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ dimension: DimensionAnchor, lessThanOrEqualTo size: CGFloat) -> NSLayoutConstraint {
        let constraint = anchor(self, for: dimension).constraint(lessThanOrEqualToConstant: size)

        return disableTranslatesAutoresizingMaskAndActivate(constraint)
    }

    /// Pin the specified `DimensionAnchor` of the view greater than or equal to a fixed size. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - dimension: `DimensionAnchor` of the caller to pin to. Either `width` or `height`.
    ///   - size: Size to pin the `DimensionAnchor` to.
    /// - Returns: The activated `NSLayoutConstraint` object that was created.
    @discardableResult
    func pin(_ dimension: DimensionAnchor, greaterThanOrEqualTo size: CGFloat) -> NSLayoutConstraint {
        let constraint = anchor(self, for: dimension).constraint(greaterThanOrEqualToConstant: size)

        return disableTranslatesAutoresizingMaskAndActivate(constraint)
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
            constraints.append(pin(.height, to: height))
        }
        if let width = width {
            constraints.append(pin(.width, to: width))
        }

        return constraints
    }

    /// Pin the height and width of the view to another view. Calling this method sets `translatesAutoresizingMaskIntoConstraints` to `false` on the caller.
    ///
    /// - Parameters:
    ///   - height: Optional view to pin the height of this view to.
    ///   - width: Optional view to pin the hieght of this view to.
    /// - Returns: Array of activated `NSLayoutConstraint` objects that were created.
    @discardableResult
    func pin<View: Pinnable>(height: View?, width: View?) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        if let height = height {
            constraints.append(pin(.height, to: height))
        }
        if let width = width {
            constraints.append(pin(.width, to: width))
        }

        return constraints
    }

    // MARK: Private Helper Methods
    
    private func anchor<View: Pinnable>(_ view: View, for anchor: HorizontalAnchor) -> NSLayoutAnchor<NSLayoutXAxisAnchor> {
        switch anchor {
        case .leading:
            return view.leadingAnchor
        case .trailing:
            return view.trailingAnchor
        case .left:
            return view.leftAnchor
        case .right:
            return view.rightAnchor
        case .centerX:
            return view.centerXAnchor
        }
    }

    private func anchor<View: Pinnable>(_ view: View, for anchor: VerticalAnchor) -> NSLayoutAnchor<NSLayoutYAxisAnchor> {
        switch anchor {
        case .top:
            return view.topAnchor
        case .bottom:
            return view.bottomAnchor
        case .centerY:
            return view.centerYAnchor
        case .firstBaseline:
            return view.firstBaselineAnchor
        case .lastBaseline:
            return view.lastBaselineAnchor
        }
    }

    private func anchor<View: Pinnable>(_ view: View, for anchor: DimensionAnchor) -> NSLayoutDimension {
        switch anchor {
        case .width:
            return view.widthAnchor
        case .height:
            return view.heightAnchor
        }
    }

    private func convertPadding(_ edge: HorizontalAnchor, _ padding: CGFloat = 0) -> CGFloat {
        return edge == .trailing || edge == .right ? -padding : padding
    }

    private func convertPadding(_ edge: VerticalAnchor, _ padding: CGFloat = 0) -> CGFloat {
        return edge == .bottom || edge == .lastBaseline ? -padding : padding
    }

    private func disableTranslatesAutoresizingMaskAndActivate(_ constraint: NSLayoutConstraint) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        constraint.isActive = true

        return constraint
    }
}
