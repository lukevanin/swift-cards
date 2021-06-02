//
//  Player.swift
//  Blackjack
//
//  Created by Luke Van In on 2021/05/31.
//

import Foundation


struct Player: Equatable {
    
    private(set) var bank: Bank
    private(set) var hands: [Hand<Card>]

    init(bank: Bank = Bank()) {
        self.bank = bank
        self.hands = []
    }

    init(bank: Bank = Bank(), hand: Hand<Card>) {
        self.bank = bank
        self.hands = [hand]
    }

    init(bank: Bank = Bank(), hands: [Hand<Card>]) {
        precondition(hands.count > 0)
        self.bank = bank
        self.hands = hands
    }
    
    mutating func deposit(amount: Chip) {
        bank.deposit(amount: amount)
    }

    mutating func placeBet(amount: Chip) throws {
        guard hands.count == 0 else {
            throw BlackjackError.alreadyPlaying
        }
        try bank.withdraw(amount: amount)
        hands.append(Hand(bet: amount))
    }
    
    mutating func addCard(_ card: BlackjackCard, toHand hand: Int) throws {
        guard hand >= 0 && hand < hands.count else {
            throw BlackjackError.invalidHand
        }
        hands[hand].addCard(card)
    }
    
    mutating func splitHand(_ hand: Int) throws {
        guard hand >= 0 && hand < hands.count else {
            throw BlackjackError.invalidHand
        }
        let pair = hands[hand]
        guard pair.cards.count == 2 else {
            throw BlackjackError.cannotSplitNonPair
        }
        guard pair.cards[0].card.rank.denomination == pair.cards[1].card.rank.denomination else {
            throw BlackjackError.cannotSplitDifferentDenominations
        }
        let amount = pair.bet
        try bank.withdraw(amount: amount)
        let split = [
            Hand(bet: amount, card: pair.cards[0]),
            Hand(bet: amount, card: pair.cards[1]),
        ]
        let prefix = hands.prefix(upTo: hand)
        let suffix = hands.suffix(from: hand + 1)
        hands = prefix + split + suffix
    }
    
    mutating func doubleDown(hand: Int) throws {
        guard hand >= 0 && hand < hands.count else {
            throw BlackjackError.invalidHand
        }
        let amount = hands[hand].bet
        try bank.withdraw(amount: amount)
        hands[hand].increaseBet(amount)
    }
    
    mutating func returnCards() -> [Card] {
        var allCards = [Card]()
        for i in 0 ..< hands.count {
            let cards = hands[i].returnCards()
            allCards.append(contentsOf: cards)
        }
        return Array(allCards)
    }
}

extension Player: CustomStringConvertible {
    var description: String {
        """
        PLAYER:
        Bank: \(bank)
        Splits: \(hands.count - 1)
        Hands: [\(hands.map { String(describing: $0) }.joined(separator: "; "))]
        """
    }
}
