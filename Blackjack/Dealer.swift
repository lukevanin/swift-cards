//
//  Dealer.swift
//  Blackjack
//
//  Created by Luke Van In on 2021/05/31.
//

import Foundation


struct Dealer<Card>: Equatable where Card: Hashable {
    
    private(set) var bank: Bank
    private(set) var hand: Hand<Card>
    
    init(bank: Bank = Bank(), hand: Hand<Card> = Hand()) {
        self.bank = bank
        self.hand = hand
    }
    
    mutating func withdraw(amount: Chip) throws {
        try bank.withdraw(amount: amount)
    }

    mutating func deposit(amount: Chip) {
        bank.deposit(amount: amount)
    }

    func addingCard(_ card: PlayerCard<Card>) -> Dealer {
        Dealer(bank: bank, hand: hand.addingCard(card))
    }
    
    mutating func addCard(_ card: PlayerCard<Card>) {
        hand.addCard(card)
    }
    
    mutating func revealCard(at index: Int) throws {
        try hand.revealCard(at: index)
    }
    
    mutating func returnCards() -> [Card] {
        hand.returnCards()
    }
}

extension Dealer: CustomStringConvertible {
    var description: String {
        """
        DEALER:
        Bank: \(bank)
        Hand: \(hand)
        """
    }
}
