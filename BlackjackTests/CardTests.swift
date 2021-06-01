//
//  CardTests.swift
//  BlackjackTests
//
//  Created by Luke Van In on 2021/05/31.
//

import XCTest
@testable import Blackjack


final class CardTests: XCTestCase {

    func testDenominations() {
        let denominations: [[Card.Rank]] = [
            [.ace],
            [.two],
            [.three],
            [.four],
            [.five],
            [.six],
            [.seven],
            [.eight],
            [.nine],
            [.ten, .jack, .queen, .king],
        ]
        for ranks in denominations {
            for i in 0 ..< ranks.count {
                for j in 0 ..< ranks.count {
                    if i != j {
                        let a = ranks[i].denomination
                        let b = ranks[j].denomination
                        XCTAssertEqual(a, b)
                    }
                }
            }
        }
    }
}
