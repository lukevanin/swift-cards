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
    
    func depositing(amount: Chip) -> Bank {
        Bank(
            balance: balance + amount
        )
    }
    
    func withdrawing(amount: Chip) throws -> Bank {
        guard balance >= amount else {
            throw BankError.insufficientFunds
        }
        return Bank(
            balance: balance - amount
        )
    }
}
