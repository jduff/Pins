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
        }

        XCTAssertEqual(nestedView.frame.width, CGFloat(mainViewWidth))
        XCTAssertEqual(nestedView.frame.height, CGFloat(mainViewHeight))
        XCTAssertEqual(nestedView.frame.origin.x, 0.0)
        XCTAssertEqual(nestedView.frame.origin.y, 0.0)
    }

    func testPinToBoundsWithPadding() {
        evaluateConstraints() {
            nestedView.pin(leftTo: mainView.leftAnchor, topTo: mainView.topAnchor, rightTo: mainView.rightAnchor, bottomTo: mainView.bottomAnchor, padding: 10)
        }

        XCTAssertEqual(mainView.constraints.count, 4)

        for constraint in mainView.constraints {
            XCTAssertTrue(constraint.isActive)
            XCTAssertEqual(constraint.constant, 10)
        }

        XCTAssertEqual(nestedView.frame.width, CGFloat(mainViewWidth))
        XCTAssertEqual(nestedView.frame.height, CGFloat(mainViewHeight))
        XCTAssertEqual(nestedView.frame.origin.x, 10.0)
        XCTAssertEqual(nestedView.frame.origin.y, 10.0)
    }

    func testPinToBoundsWithOptionals() {
        evaluateConstraints() {
            nestedView.pin(leftTo: mainView.leftAnchor, topTo: nil, rightTo: mainView.rightAnchor, bottomTo: nil)
        }

        XCTAssertEqual(mainView.constraints.count, 2)

        for constraint in mainView.constraints {
            XCTAssertTrue(constraint.isActive)
            XCTAssertEqual(constraint.constant, 0)
        }

        XCTAssertEqual(nestedView.frame.width, CGFloat(mainViewWidth))
        XCTAssertEqual(nestedView.frame.height, 0.0)
        XCTAssertEqual(nestedView.frame.origin.x, 0.0)
        XCTAssertEqual(nestedView.frame.origin.y, 0.0)
    }

    func testPinSize() {
        evaluateConstraints {
            nestedView.pin(height: 20, width: 10)
        }

        XCTAssertEqual(nestedView.constraints.count, 2)
        XCTAssertEqual(mainView.constraints.count, 0)

        for constraint in nestedView.constraints {
            XCTAssertTrue(constraint.isActive)
        }

        let widthConstraint = nestedView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .width
        }

        XCTAssertEqual(widthConstraint?.constant, 10.0)


        let heightConstraint = nestedView.constraints.first { (constraint) -> Bool in
            constraint.firstAttribute == .height
        }

        XCTAssertEqual(heightConstraint?.constant, 20.0)
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
    }

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
