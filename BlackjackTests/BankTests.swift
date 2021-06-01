//
//  BankTests.swift
//  BlackjackTests
//
//  Created by Luke Van In on 2021/05/31.
//

import XCTest
@testable import Blackjack

final class BankTests: XCTestCase {

    // MARK: Deposit
    
    func testDepositShouldIncreaseBalance() {
        let subject = Bank()
        let expected1 = Bank(balance: 7)
        let expected2 = Bank(balance: 13)
        let result1 = subject.depositing(amount: 7)
        let result2 = result1.depositing(amount: 6)
        XCTAssertEqual(result1, expected1)
        XCTAssertEqual(result2, expected2)
    }
    
    // MARK: Withdraw
    
    func testWithdrawShouldDecreaseBalance() throws {
        let subject = Bank(balance: 13)
        let expected1 = Bank(balance: 6)
        let expected2 = Bank(balance: 0)
        let result1 = try subject.withdrawing(amount: 7)
        let result2 = try subject.withdrawing(amount: 6)
        XCTAssertEqual(result1, expected1)
        XCTAssertEqual(result2, expected2)
    }
    
    func testWithdrawShouldFailWithInsufficientFunds() {
        let subject = Bank(balance: 6)
        XCTAssertThrowsError(try subject.withdrawing(amount: 7))
    }

}
