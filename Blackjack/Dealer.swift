//
//  Dealer.swift
//  Blackjack
//
//  Created by Luke Van In on 2021/05/31.
//

import Foundation


struct Dealer: Equatable {
    
    private(set) var bank: Bank
    private(set) var hand: Hand
    
    init(bank: Bank = Bank(), hand: Hand = Hand()) {
        self.bank = bank
        self.hand = hand
    }
    
    mutating func addCard(_ card: PlayerCard) {
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
