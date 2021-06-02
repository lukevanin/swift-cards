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
        var subject = Bank()
        let expected1 = Bank(balance: 7)
        let expected2 = Bank(balance: 13)
        subject.deposit(amount: 7)
        XCTAssertEqual(subject, expected1)
        subject.deposit(amount: 6)
        XCTAssertEqual(subject, expected2)
    }
    
    // MARK: Withdraw
    
    func testWithdrawShouldDecreaseBalance() throws {
        var subject = Bank(balance: 13)
        let expected1 = Bank(balance: 6)
        let expected2 = Bank(balance: 0)
        try subject.withdraw(amount: 7)
        XCTAssertEqual(subject, expected1)
        try subject.withdraw(amount: 6)
        XCTAssertEqual(subject, expected2)
    }
    
    func testWithdrawShouldFailWithInsufficientFunds() {
        var subject = Bank(balance: 6)
        XCTAssertThrowsError(try subject.withdraw(amount: 7))
    }

}
