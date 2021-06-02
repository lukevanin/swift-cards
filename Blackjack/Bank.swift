//
//  Bank.swift
//  Blackjack
//
//  Created by Luke Van In on 2021/05/31.
//

import Foundation


typealias Chip = UInt


enum BankError: Error {
    case insufficientFunds
}


struct Bank: Equatable {
    
    private(set) var balance: Chip
    
    init(balance: Chip = 0) {
        self.balance = balance
    }
    
    mutating func deposit(amount: Chip) {
        balance += amount
    }
    
    mutating func withdraw(amount: Chip) throws {
        guard balance >= amount else {
            throw BankError.insufficientFunds
        }
        balance -= amount
    }
}
