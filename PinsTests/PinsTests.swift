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

        for constraint in mainView.constraints {
            XCTAssertTrue(constraint.isActive)
            XCTAssertEqual(constraint.constant, 10)
            XCTAssertEqual(constraint.relation, .equal)
        }

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 10, width: CGFloat(mainViewWidth), height: CGFloat(mainViewHeight)))
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

        for constraint in mainView.constraints {
            XCTAssertTrue(constraint.isActive)
            XCTAssertEqual(constraint.constant, 10)
            XCTAssertEqual(constraint.relation, .equal)
        }

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 10, width: CGFloat(mainViewWidth), height: CGFloat(mainViewHeight)))
    }


    func testPinBoundsToSpecificView() {
        evaluateConstraints() {
            nestedView.pin(leadingToView: mainView, topToView: mainView, trailingToView: mainView, bottomToView: mainView)
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
            nestedView.pin(leadingToView: mainView, topToView: mainView, trailingToView: mainView, bottomToView: mainView, padding: 10)
        }

        XCTAssertEqual(mainView.constraints.count, 4)

        for constraint in mainView.constraints {
            XCTAssertTrue(constraint.isActive)
            XCTAssertEqual(constraint.constant, 10)
            XCTAssertEqual(constraint.relation, .equal)
        }

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 10, width: CGFloat(mainViewWidth), height: CGFloat(mainViewHeight)))
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
        }

        XCTAssertEqual(widthConstraint?.constant, 10.0)
        XCTAssertEqual(widthConstraint?.relation, .equal)
        XCTAssertEqual(widthConstraint?.firstAttribute, .width)
        XCTAssertEqual(widthConstraint?.secondAttribute, .notAnAttribute)

        let heightConstraint = nestedView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .height
        }

        XCTAssertEqual(heightConstraint?.constant, 20.0)
        XCTAssertEqual(heightConstraint?.relation, .equal)
        XCTAssertEqual(heightConstraint?.firstAttribute, .height)
        XCTAssertEqual(heightConstraint?.secondAttribute, .notAnAttribute)
    }

    func testPinSizeOptionalWidth() {
        evaluateConstraints {
            nestedView.pin(height: 20, width: nil)
        }

        XCTAssertEqual(nestedView.constraints.count, 1)
        XCTAssertEqual(mainView.constraints.count, 0)

        let constraint = nestedView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.constant, 20.0)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .height)
        XCTAssertEqual(constraint.secondAttribute, .notAnAttribute)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 20))
    }

    func testPinSizeOptionalHeight() {
        evaluateConstraints {
            nestedView.pin(height: nil, width: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 1)
        XCTAssertEqual(mainView.constraints.count, 0)

        let constraint = nestedView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.constant, 10.0)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .notAnAttribute)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 10, height: 0))
    }

    func testPinSizeToView() {
        evaluateConstraints {
            nestedView.pin(height: mainView, width: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 2)

        for constraint in mainView.constraints {
            XCTAssertTrue(constraint.isActive)
            XCTAssertEqual(constraint.relation, .equal)
        }

        let widthConstraint = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .width
        }

        XCTAssertEqual(widthConstraint?.firstItem as? PView, nestedView)
        XCTAssertEqual(widthConstraint?.firstAttribute, .width)
        XCTAssertEqual(widthConstraint?.secondAttribute, .width)

        let heightConstraint = mainView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .height
        }

        XCTAssertEqual(heightConstraint?.firstItem as? PView, nestedView)
        XCTAssertEqual(heightConstraint?.firstAttribute, .height)
        XCTAssertEqual(heightConstraint?.secondAttribute, .height)
    }

    func testPinSizeToViewOptionalHeight() {
        evaluateConstraints {
            nestedView.pin(height: nil, width: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.firstItem as? PView, nestedView)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: CGFloat(mainViewWidth), height: 0))
    }

    func testPinSizeToViewOptionalWidth() {
        evaluateConstraints {
            nestedView.pin(height: mainView, width: nil)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.firstItem as? PView, nestedView)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .height)
        XCTAssertEqual(constraint.secondAttribute, .height)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: CGFloat(mainViewHeight)))
    }

    func testPinHorizontalAnchorLessThan() {
        evaluateConstraints {
            nestedView.pin(.left, lessThanOrEqualTo: mainView.leftAnchor)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .left)
        XCTAssertEqual(constraint.secondAttribute, .left)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinHorizontalAnchorLessThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.left, lessThanOrEqualTo: mainView.leftAnchor, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .left)
        XCTAssertEqual(constraint.secondAttribute, .left)

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 0, width: 0, height: 0))
    }

    func testPinHorizontalAnchorGreaterThan() {
        evaluateConstraints {
            nestedView.pin(.left, greaterThanOrEqualTo: mainView.leftAnchor)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .left)
        XCTAssertEqual(constraint.secondAttribute, .left)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinHorizontalAnchorGreaterThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.left, greaterThanOrEqualTo: mainView.leftAnchor, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .left)
        XCTAssertEqual(constraint.secondAttribute, .left)

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 0, width: 0, height: 0))
    }


    func testPinHorizontalAnchorToViewLessThan() {
        evaluateConstraints {
            nestedView.pin(.left, lessThanOrEqualTo: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .left)
        XCTAssertEqual(constraint.secondAttribute, .left)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinHorizontalAnchorToViewLessThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.left, lessThanOrEqualTo: mainView, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .left)
        XCTAssertEqual(constraint.secondAttribute, .left)

        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 0, width: 0, height: 0))
    }

    func testPinHorizontalAnchorToViewGreaterThan() {
        evaluateConstraints {
            nestedView.pin(.left, greaterThanOrEqualTo: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .left)
        XCTAssertEqual(constraint.secondAttribute, .left)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinHorizontalAnchorToViewGreaterThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.left, greaterThanOrEqualTo: mainView, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .left)
        XCTAssertEqual(constraint.secondAttribute, .left)
        
        XCTAssertEqual(nestedView.frame, CGRect(x: 10, y: 0, width: 0, height: 0))
    }

    func testPinVerticalAnchorLessThan() {
        evaluateConstraints {
            nestedView.pin(.top, lessThanOrEqualTo: mainView.topAnchor)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .top)
        XCTAssertEqual(constraint.secondAttribute, .top)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinVerticalAnchorLessThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.top, lessThanOrEqualTo: mainView.topAnchor, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .top)
        XCTAssertEqual(constraint.secondAttribute, .top)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 10, width: 0, height: 0))
    }

    func testPinVerticalAnchorGreaterThan() {
        evaluateConstraints {
            nestedView.pin(.top, greaterThanOrEqualTo: mainView.topAnchor)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .top)
        XCTAssertEqual(constraint.secondAttribute, .top)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinVerticalAnchorGreaterThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.top, greaterThanOrEqualTo: mainView.topAnchor, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .top)
        XCTAssertEqual(constraint.secondAttribute, .top)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 10, width: 0, height: 0))
    }

    func testPinVerticalAnchorToViewLessThan() {
        evaluateConstraints {
            nestedView.pin(.top, lessThanOrEqualTo: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .top)
        XCTAssertEqual(constraint.secondAttribute, .top)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinVerticalAnchorToViewLessThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.top, lessThanOrEqualTo: mainView, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .top)
        XCTAssertEqual(constraint.secondAttribute, .top)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 10, width: 0, height: 0))
    }

    func testPinVerticalAnchorToViewGreaterThan() {
        evaluateConstraints {
            nestedView.pin(.top, greaterThanOrEqualTo: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .top)
        XCTAssertEqual(constraint.secondAttribute, .top)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinVerticalAnchorToViewGreaterThanWithPadding() {
        evaluateConstraints {
            nestedView.pin(.top, greaterThanOrEqualTo: mainView, padding: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .top)
        XCTAssertEqual(constraint.secondAttribute, .top)
        
        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 10, width: 0, height: 0))
    }

    func testPinDimensionAnchorLessThan() {
        evaluateConstraints {
            nestedView.pin(.width, lessThanOrEqualTo: mainView.widthAnchor)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinDimensionAnchorToViewLessThan() {
        evaluateConstraints {
            nestedView.pin(.width, lessThanOrEqualTo: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinDimensionAnchorLessThanConstant() {
        evaluateConstraints {
            nestedView.pin(.width, lessThanOrEqualTo: 50)
        }

        XCTAssertEqual(nestedView.constraints.count, 1)
        XCTAssertEqual(mainView.constraints.count, 0)

        let constraint = nestedView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .notAnAttribute)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testPinDimensionAnchorGreaterThan() {
        evaluateConstraints {
            nestedView.pin(.width, greaterThanOrEqualTo: mainView.widthAnchor)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: CGFloat(mainViewWidth), height: 0))
    }

    func testPinDimensionAnchorToViewGreaterThan() {
        evaluateConstraints {
            nestedView.pin(.width, greaterThanOrEqualTo: mainView)
        }

        XCTAssertEqual(nestedView.constraints.count, 0)
        XCTAssertEqual(mainView.constraints.count, 1)

        let constraint = mainView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: CGFloat(mainViewWidth), height: 0))
    }

    func testPinDimensionAnchorGreaterThanConstant() {
        evaluateConstraints {
            nestedView.pin(.width, greaterThanOrEqualTo: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 1)
        XCTAssertEqual(mainView.constraints.count, 0)

        let constraint = nestedView.constraints.first!

        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .notAnAttribute)

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
