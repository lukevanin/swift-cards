//
//  Hand.swift
//  Blackjack
//
//  Created by Luke Van In on 2021/05/30.
//

import Foundation


enum HandError: Error {
    case invalidCardIndex
}


struct Hand<Card>: Equatable where Card: Hashable {
    
    private(set) var bet: Chip
    private(set) var cards: [PlayerCard<Card>] = []
    
    init(bet: Chip = 0) {
        self.bet = bet
    }
    
    init(bet: Chip = 0, card: PlayerCard<Card>) {
        self.bet = bet
        self.cards = [card]
    }
    
    init(bet: Chip = 0, cards: [PlayerCard<Card>]) {
        self.bet = bet
        self.cards = cards
    }
    
    mutating func increaseBet(_ amount: Chip) {
        bet += amount
    }
    
    mutating func addCard(_ card: PlayerCard<Card>) {
        cards.append(card)
    }

    func addingCard(_ card: PlayerCard<Card>) -> Hand {
        Hand(bet: bet, cards: cards + [card])
    }

    mutating func revealCard(at index: Int) throws {
        guard index >= 0 && index < cards.count else {
            throw HandError.invalidCardIndex
        }
        try cards[index].reveal()
    }
    
    mutating func returnCards() -> [Card] {
        let output = cards.map { $0.card }
        cards.removeAll()
        return output
    }
}

extension Hand: CustomStringConvertible {
    var description: String {
        "<HAND: Bet: \(bet) Cards: [\(cards.map { String(describing: $0) }.joined(separator: ", "))]>"
    }
}
