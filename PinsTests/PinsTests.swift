//
//  PinsTests.swift
//  PinsTests
//
//  Created by John Duff on 2017-05-12.
//  Copyright © 2017 John Duff. All rights reserved.
//

import XCTest
@testable import Pins

class PinsTests: XCTestCase {
    let mainViewWidth = 100
    let mainViewHeight = 100

    var mainView: UIView!

    var nestedView: UIView!
    
    override func setUp() {
        super.setUp()

        mainView = UIView(frame: CGRect(x: 0, y: 0, width: mainViewWidth, height: mainViewHeight))

        setupViews()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPinToBounds() {
        evaluateConstraints() {
            nestedView.pin(leftTo: mainView.leftAnchor, topTo: mainView.topAnchor, rightTo: mainView.rightAnchor, bottomTo: mainView.bottomAnchor)
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
            nestedView.pin(leftTo: mainView.leftAnchor, topTo: mainView.topAnchor, rightTo: mainView.rightAnchor, bottomTo: mainView.bottomAnchor, padding: 10)
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
            nestedView.pin(leftTo: mainView.leftAnchor, topTo: nil, rightTo: mainView.rightAnchor, bottomTo: nil)
        }

        XCTAssertEqual(mainView.constraints.count, 2)

        for constraint in mainView.constraints {
            XCTAssertTrue(constraint.isActive)
            XCTAssertEqual(constraint.constant, 0)
            XCTAssertEqual(constraint.relation, .equal)
        }

        XCTAssertEqual(nestedView.frame, CGRect(x: 0, y: 0, width: CGFloat(mainViewWidth), height: 0))
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
        XCTAssertEqual(widthConstraint?.firstAttribute, .width)
        XCTAssertEqual(widthConstraint?.secondAttribute, .notAnAttribute)

        let heightConstraint = nestedView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .height
        }

        XCTAssertEqual(heightConstraint?.constant, 20.0)
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
        nestedView = UIView()
        mainView.addSubview(nestedView)
    }

    private func evaluateConstraints() {
        evaluateConstraints(for: mainView)
    }

    private func evaluateConstraints(block: () ->()) {
        block()

        evaluateConstraints()
    }

    private func evaluateConstraints(for view: UIView) {
        for subview in view.subviews {
            evaluateConstraints(for: subview)
        }

        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}
