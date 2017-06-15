//
//  PinsTests.swift
//  PinsTests
//
//  Created by John Duff on 2017-05-12.
//  Copyright © 2017 John Duff. All rights reserved.
//

import XCTest
@testable import Pins

// Invert coordinates in the test view on OSX so that we can use the same tests
class CustomView: PView {
    #if os(OSX)
    override var isFlipped:Bool {
        get {
            return true
        }
    }
    #endif
}

class PinsTests: XCTestCase {
    let mainViewWidth = 100
    let mainViewHeight = 100

    var mainView: CustomView!

    var nestedView: CustomView!
    
    override func setUp() {
        super.setUp()

        mainView = CustomView(frame: CGRect(x: 0, y: 0, width: mainViewWidth, height: mainViewHeight))

        setupViews()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPinToBounds() {
        evaluateConstraints() {
            nestedView.pin(leadingTo: mainView.leadingAnchor, topTo: mainView.topAnchor, trailingTo: mainView.trailingAnchor, bottomTo: mainView.bottomAnchor)
        }

        XCTAssertEqual(mainView.constraints.count, 4)

        for constraint in mainView.constraints {
            XCTAssertTrue(constraint.isActive)
            XCTAssertEqual(constraint.constant, 0)
            XCTAssertEqual(constraint.relation, .equal)
        }

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: CGFloat(mainViewWidth), height: CGFloat(mainViewHeight)))
    }

    func testPinToBoundsWithPadding() {
        evaluateConstraints() {
            nestedView.pin(leadingTo: mainView.leadingAnchor, topTo: mainView.topAnchor, trailingTo: mainView.trailingAnchor, bottomTo: mainView.bottomAnchor, padding: 10)
        }

        XCTAssertEqual(mainView.constraints.count, 4)

        let leading = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .leading
        }!

        AssertConstraint(leading, relation: .equal, firstAttribute: .leading, secondAttribute: .leading, constant: 10)

        let top = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .top
        }!

        AssertConstraint(top, relation: .equal, firstAttribute: .top, secondAttribute: .top, constant: 10)

        let trailing = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .trailing
        }!

        AssertConstraint(trailing, relation: .equal, firstAttribute: .trailing, secondAttribute: .trailing, constant: -10)

        let bottom = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .bottom
        }!

        AssertConstraint(bottom, relation: .equal, firstAttribute: .bottom, secondAttribute: .bottom, constant: -10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 10, width: CGFloat(mainViewWidth-20), height: CGFloat(mainViewHeight-20)))
    }

    func testPinToBoundsWithOptionals() {
        evaluateConstraints() {
            nestedView.pin(leadingTo: mainView.leadingAnchor, topTo: nil, trailingTo: mainView.trailingAnchor, bottomTo: nil)
        }

        XCTAssertEqual(mainView.constraints.count, 2)

        for constraint in mainView.constraints {
            XCTAssertTrue(constraint.isActive)
            XCTAssertEqual(constraint.constant, 0)
            XCTAssertEqual(constraint.relation, .equal)
        }

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: CGFloat(mainViewWidth), height: 0))
    }

    func testPinBoundsToView() {
        evaluateConstraints() {
            nestedView.pin(to: mainView)
        }

        XCTAssertEqual(mainView.constraints.count, 4)

        for constraint in mainView.constraints {
            XCTAssertTrue(constraint.isActive)
            XCTAssertEqual(constraint.constant, 0)
            XCTAssertEqual(constraint.relation, .equal)
        }

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: CGFloat(mainViewWidth), height: CGFloat(mainViewHeight)))
    }

    func testPinBoundsToViewWithPadding() {
        evaluateConstraints() {
            nestedView.pin(to: mainView, padding: 10)
        }

        XCTAssertEqual(mainView.constraints.count, 4)

        let leading = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .leading
        }!

        AssertConstraint(leading, relation: .equal, firstAttribute: .leading, secondAttribute: .leading, constant: 10)

        let top = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .top
        }!

        AssertConstraint(top, relation: .equal, firstAttribute: .top, secondAttribute: .top, constant: 10)

        let trailing = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .trailing
        }!

        AssertConstraint(trailing, relation: .equal, firstAttribute: .trailing, secondAttribute: .trailing, constant: -10)

        let bottom = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .bottom
        }!

        AssertConstraint(bottom, relation: .equal, firstAttribute: .bottom, secondAttribute: .bottom, constant: -10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 10, width: CGFloat(mainViewWidth-20), height: CGFloat(mainViewHeight-20)))
    }


    func testPinBoundsToSpecificView() {
        evaluateConstraints() {
            nestedView.pin(leadingTo: mainView, topTo: mainView, trailingTo: mainView, bottomTo: mainView)
        }

        XCTAssertEqual(mainView.constraints.count, 4)

        for constraint in mainView.constraints {
            XCTAssertTrue(constraint.isActive)
            XCTAssertEqual(constraint.constant, 0)
            XCTAssertEqual(constraint.relation, .equal)
        }

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: CGFloat(mainViewWidth), height: CGFloat(mainViewHeight)))
    }

    func testPinBoundsToSpecificViewWithPadding() {
        evaluateConstraints() {
            nestedView.pin(leadingTo: mainView, topTo: mainView, trailingTo: mainView, bottomTo: mainView, padding: 10)
        }

        XCTAssertEqual(mainView.constraints.count, 4)

        let leading = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .leading
        }!

        AssertConstraint(leading, relation: .equal, firstAttribute: .leading, secondAttribute: .leading, constant: 10)

        let top = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .top
        }!

        AssertConstraint(top, relation: .equal, firstAttribute: .top, secondAttribute: .top, constant: 10)

        let trailing = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .trailing
        }!

        AssertConstraint(trailing, relation: .equal, firstAttribute: .trailing, secondAttribute: .trailing, constant: -10)

        let bottom = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .bottom
        }!

        AssertConstraint(bottom, relation: .equal, firstAttribute: .bottom, secondAttribute: .bottom, constant: -10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 10, width: CGFloat(mainViewWidth-20), height: CGFloat(mainViewHeight-20)))
    }

    func testPinHorizontalBoundsToSpecificViewWithPadding() {
        evaluateConstraints() {
            nestedView.pin(leadingTo: mainView, trailingTo: mainView, padding: 10)
        }

        XCTAssertEqual(mainView.constraints.count, 2)

        let leading = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .leading
        }!

        AssertConstraint(leading, relation: .equal, firstAttribute: .leading, secondAttribute: .leading, constant: 10)

        let trailing = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .trailing
        }!

        AssertConstraint(trailing, relation: .equal, firstAttribute: .trailing, secondAttribute: .trailing, constant: -10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 0, width: CGFloat(mainViewWidth-20), height: 0))
    }

    func testPinHorizontalBoundsToAnchorWithPadding() {
        evaluateConstraints() {
            nestedView.pin(leadingTo: mainView.leadingAnchor, trailingTo: mainView.trailingAnchor, padding: 10)
        }

        XCTAssertEqual(mainView.constraints.count, 2)

        let leading = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .leading
        }!

        AssertConstraint(leading, relation: .equal, firstAttribute: .leading, secondAttribute: .leading, constant: 10)

        let trailing = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .trailing
        }!

        AssertConstraint(trailing, relation: .equal, firstAttribute: .trailing, secondAttribute: .trailing, constant: -10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 0, width: CGFloat(mainViewWidth-20), height: 0))
    }

    func testPinLeftRightBoundsToSpecificViewWithPadding() {
        evaluateConstraints() {
            nestedView.pin(leftTo: mainView, rightTo: mainView, padding: 10)
        }

        XCTAssertEqual(mainView.constraints.count, 2)

        let left = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .left
        }!

        AssertConstraint(left, relation: .equal, firstAttribute: .left, secondAttribute: .left, constant: 10)

        let right = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .right
        }!

        AssertConstraint(right, relation: .equal, firstAttribute: .right, secondAttribute: .right, constant: -10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 0, width: CGFloat(mainViewWidth-20), height: 0))
    }

    func testPinLeftRightBoundsToAnchorWithPadding() {
        evaluateConstraints() {
            nestedView.pin(leftTo: mainView.leftAnchor, rightTo: mainView.rightAnchor, padding: 10)
        }

        XCTAssertEqual(mainView.constraints.count, 2)

        let left = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .left
        }!

        AssertConstraint(left, relation: .equal, firstAttribute: .left, secondAttribute: .left, constant: 10)

        let right = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .right
        }!

        AssertConstraint(right, relation: .equal, firstAttribute: .right, secondAttribute: .right, constant: -10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 0, width: CGFloat(mainViewWidth-20), height: 0))
    }

    func testPinTopBottomBoundsToSpecificViewWithPadding() {
        evaluateConstraints() {
            nestedView.pin(topTo: mainView, bottomTo: mainView, padding: 10)
        }

        XCTAssertEqual(mainView.constraints.count, 2)

        let top = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .top
        }!

        AssertConstraint(top, relation: .equal, firstAttribute: .top, secondAttribute: .top, constant: 10)

        let bottom = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .bottom
        }!

        AssertConstraint(bottom, relation: .equal, firstAttribute: .bottom, secondAttribute: .bottom, constant: -10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 10, width: 0, height: CGFloat(mainViewHeight-20)))
    }

    func testPinTopBottomBoundsToAnchorWithPadding() {
        evaluateConstraints() {
            nestedView.pin(topTo: mainView.topAnchor, bottomTo: mainView.bottomAnchor, padding: 10)
        }

        XCTAssertEqual(mainView.constraints.count, 2)

        let top = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .top
        }!

        AssertConstraint(top, relation: .equal, firstAttribute: .top, secondAttribute: .top, constant: 10)

        let bottom = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .bottom
        }!

        AssertConstraint(bottom, relation: .equal, firstAttribute: .bottom, secondAttribute: .bottom, constant: -10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 10, width: 0, height: CGFloat(mainViewHeight-20)))
    }

    func testPinSize() {
        evaluateConstraints {
            nestedView.pin(height: 20, width: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 2)
        XCTAssertEqual(mainView.constraints.count, 0)

        for constraint in nestedView.constraints {
            XCTAssertTrue(constraint.isActive)
            XCTAssertEqual(constraint.relation, .equal)
        }

        let widthConstraint = nestedView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .width
        }!

        AssertConstraint(widthConstraint, relation: .equal, firstAttribute: .width, secondAttribute: .notAnAttribute, constant: 10)

        let heightConstraint = nestedView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .height
        }!

        AssertConstraint(heightConstraint, relation: .equal, firstAttribute: .height, secondAttribute: .notAnAttribute, constant: 20)
    }

    func testPinSizeOptionalWidth() {
        evaluateConstraints {
            nestedView.pin(height: 20, width: nil)
        }

        XCTAssertEqual(nestedView.constraints.count, 1)
        XCTAssertEqual(mainView.constraints.count, 0)

        let constraint = nestedView.constraints.first!

        AssertConstraint(constraint, relation: .equal, firstAttribute: .height, secondAttribute: .notAnAttribute, constant: 20)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 20))
    }

    func testPinSizeOptionalHeight() {
        evaluateConstraints {
            nestedView.pin(height: nil, width: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 1)
        XCTAssertEqual(mainView.constraints.count, 0)

        let constraint = nestedView.constraints.first!

        AssertConstraint(constraint, relation: .equal, firstAttribute: .width, secondAttribute: .notAnAttribute, constant: 10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 10, height: 0))
    }

    func testPinSizeToView() {
        evaluateConstraints {
            nestedView.pin(height: mainView, width: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 2)

        let widthConstraint = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .width
        }!

        XCTAssertEqual(widthConstraint.firstItem as? PView, nestedView)
        AssertConstraint(widthConstraint, relation: .equal, firstAttribute: .width, secondAttribute: .width)

        let heightConstraint = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .height
        }!

        XCTAssertEqual(heightConstraint.firstItem as? PView, nestedView)
        AssertConstraint(heightConstraint, relation: .equal, firstAttribute: .height, secondAttribute: .height)
    }

    func testPinSizeToViewOptionalHeight() {
        evaluateConstraints {
            nestedView.pin(height: nil, width: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertEqual(constraint.firstItem as? PView, nestedView)
        AssertConstraint(constraint, relation: .equal, firstAttribute: .width, secondAttribute: .width)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: CGFloat(mainViewWidth), height: 0))
    }

    func testPinSizeToViewOptionalWidth() {
        evaluateConstraints {
            nestedView.pin(height: mainView, width: nil)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertEqual(constraint.firstItem as? PView, nestedView)
        AssertConstraint(constraint, relation: .equal, firstAttribute: .height, secondAttribute: .height)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: CGFloat(mainViewHeight)))
    }

    func testPinHorizontalAnchorLessThan() {
        evaluateConstraints {
            nestedView.pin(.left, lessThanOrEqualTo: mainView.leftAnchor)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .lessThanOrEqual, firstAttribute: .left, secondAttribute: .left, constant: 0)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinHorizontalAnchorLessThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.left, lessThanOrEqualTo: mainView.leftAnchor, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .lessThanOrEqual, firstAttribute: .left, secondAttribute: .left, constant: 10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 0, width: 0, height: 0))
    }

    func testPinHorizontalAnchorGreaterThan() {
        evaluateConstraints {
            nestedView.pin(.left, greaterThanOrEqualTo: mainView.leftAnchor)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .greaterThanOrEqual, firstAttribute: .left, secondAttribute: .left, constant: 0)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinHorizontalAnchorGreaterThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.left, greaterThanOrEqualTo: mainView.leftAnchor, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .greaterThanOrEqual, firstAttribute: .left, secondAttribute: .left, constant: 10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 0, width: 0, height: 0))
    }


    func testPinHorizontalAnchorToViewLessThan() {
        evaluateConstraints {
            nestedView.pin(.left, lessThanOrEqualTo: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .lessThanOrEqual, firstAttribute: .left, secondAttribute: .left, constant: 0)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinHorizontalAnchorToViewLessThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.left, lessThanOrEqualTo: mainView, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .lessThanOrEqual, firstAttribute: .left, secondAttribute: .left, constant: 10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 0, width: 0, height: 0))
    }

    func testPinHorizontalAnchorToViewGreaterThan() {
        evaluateConstraints {
            nestedView.pin(.left, greaterThanOrEqualTo: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .greaterThanOrEqual, firstAttribute: .left, secondAttribute: .left, constant: 0)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinHorizontalAnchorToViewGreaterThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.left, greaterThanOrEqualTo: mainView, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .greaterThanOrEqual, firstAttribute: .left, secondAttribute: .left, constant: 10)
        
        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 0, width: 0, height: 0))
    }

    func testPinVerticalAnchorLessThan() {
        evaluateConstraints {
            nestedView.pin(.top, lessThanOrEqualTo: mainView.topAnchor)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .lessThanOrEqual, firstAttribute: .top, secondAttribute: .top, constant: 0)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinVerticalAnchorLessThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.top, lessThanOrEqualTo: mainView.topAnchor, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .lessThanOrEqual, firstAttribute: .top, secondAttribute: .top, constant: 10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 10, width: 0, height: 0))
    }

    func testPinVerticalAnchorGreaterThan() {
        evaluateConstraints {
            nestedView.pin(.top, greaterThanOrEqualTo: mainView.topAnchor)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .greaterThanOrEqual, firstAttribute: .top, secondAttribute: .top, constant: 0)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinVerticalAnchorGreaterThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.top, greaterThanOrEqualTo: mainView.topAnchor, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .greaterThanOrEqual, firstAttribute: .top, secondAttribute: .top, constant: 10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 10, width: 0, height: 0))
    }

    func testPinVerticalAnchorToViewLessThan() {
        evaluateConstraints {
            nestedView.pin(.top, lessThanOrEqualTo: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .lessThanOrEqual, firstAttribute: .top, secondAttribute: .top, constant: 0)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinVerticalAnchorToViewLessThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.top, lessThanOrEqualTo: mainView, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .lessThanOrEqual, firstAttribute: .top, secondAttribute: .top, constant: 10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 10, width: 0, height: 0))
    }

    func testPinVerticalAnchorToViewGreaterThan() {
        evaluateConstraints {
            nestedView.pin(.top, greaterThanOrEqualTo: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .greaterThanOrEqual, firstAttribute: .top, secondAttribute: .top, constant: 0)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinVerticalAnchorToViewGreaterThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.top, greaterThanOrEqualTo: mainView, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .greaterThanOrEqual, firstAttribute: .top, secondAttribute: .top, constant: 10)
        
        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 10, width: 0, height: 0))
    }

    func testPinDimensionAnchorLessThan() {
        evaluateConstraints {
            nestedView.pin(.width, lessThanOrEqualTo: mainView.widthAnchor)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .lessThanOrEqual, firstAttribute: .width, secondAttribute: .width)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinDimensionAnchorToViewLessThan() {
        evaluateConstraints {
            nestedView.pin(.width, lessThanOrEqualTo: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .lessThanOrEqual, firstAttribute: .width, secondAttribute: .width)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinDimensionAnchorLessThanConstant() {
        evaluateConstraints {
            nestedView.pin(.width, lessThanOrEqualTo: 50)
        }

        XCTAssertEqual(nestedView.constraints.count, 1)
        XCTAssertEqual(mainView.constraints.count, 0)

        let constraint = nestedView.constraints.first!

        AssertConstraint(constraint, relation: .lessThanOrEqual, firstAttribute: .width, secondAttribute: .notAnAttribute, constant: 50)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinDimensionAnchorGreaterThan() {
        evaluateConstraints {
            nestedView.pin(.width, greaterThanOrEqualTo: mainView.widthAnchor)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .greaterThanOrEqual, firstAttribute: .width, secondAttribute: .width)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: CGFloat(mainViewWidth), height: 0))
    }

    func testPinDimensionAnchorToViewGreaterThan() {
        evaluateConstraints {
            nestedView.pin(.width, greaterThanOrEqualTo: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        AssertConstraint(constraint, relation: .greaterThanOrEqual, firstAttribute: .width, secondAttribute: .width)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: CGFloat(mainViewWidth), height: 0))
    }

    func testPinDimensionAnchorGreaterThanConstant() {
        evaluateConstraints {
            nestedView.pin(.width, greaterThanOrEqualTo: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 1)
        XCTAssertEqual(mainView.constraints.count, 0)

        let constraint = nestedView.constraints.first!

        AssertConstraint(constraint, relation: .greaterThanOrEqual, firstAttribute: .width, secondAttribute: .notAnAttribute, constant: 10)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 10, height: 0))
    }

    // MARK: Private helper methods
    private func setupViews() {
        nestedView = CustomView()
        mainView.addSubview(nestedView)
    }

    private func evaluateConstraints() {
        evaluateConstraints(for: mainView)
    }

    private func AssertConstraint(_ constraint: NSLayoutConstraint, relation: NSLayoutRelation, firstAttribute: NSLayoutAttribute? = nil, secondAttribute: NSLayoutAttribute? = nil, constant: CGFloat? = nil) {
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, relation)
        if let firstAttribute = firstAttribute {
            XCTAssertEqual(constraint.firstAttribute, firstAttribute)
        }
        if let secondAttribute = secondAttribute {
            XCTAssertEqual(constraint.secondAttribute, secondAttribute)
        }
        if let constant = constant {
            XCTAssertEqual(constraint.constant, constant)
        }
    }

    private func evaluateConstraints(block: () ->()) {
        block()

        evaluateConstraints()
    }

    private func evaluateConstraints(for view: PView) {
        for subview in view.subviews {
            evaluateConstraints(for: subview)
        }

    #if os(iOS) || os(tvOS) || os(watchOS)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    #elseif os(OSX)
        view.needsLayout = true
        view.layoutSubtreeIfNeeded()
    #endif
    }
}
