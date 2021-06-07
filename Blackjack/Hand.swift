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


enum Outcome: Equatable {
    case undetermined
    case push
    case forfeit
    case win
    case lose
}


struct Hand<Card>: Equatable where Card: Hashable {

    private(set) var outcome: Outcome
    private(set) var bet: Chip
    private(set) var insurance: Chip
    private(set) var isSplit: Bool
    private(set) var cards: [PlayerCard<Card>] = []
    
    init(bet: Chip = 0, insurance: Chip = 0, outcome: Outcome = .undetermined, split: Bool = false) {
        self.bet = bet
        self.insurance = insurance
        self.outcome = outcome
        self.isSplit = split
    }
    
    init(bet: Chip = 0, insurance: Chip = 0, outcome: Outcome = .undetermined, split: Bool = false, card: PlayerCard<Card>) {
        self.bet = bet
        self.insurance = insurance
        self.outcome = outcome
        self.isSplit = split
        self.cards = [card]
    }
    
    init(bet: Chip = 0, insurance: Chip = 0, outcome: Outcome = .undetermined, split: Bool = false, cards: [PlayerCard<Card>]) {
        self.bet = bet
        self.insurance = insurance
        self.outcome = outcome
        self.isSplit = split
        self.cards = cards
    }
    
    mutating func finish(outcome: Outcome) throws {
        guard self.outcome == .undetermined else {
            throw BlackjackError.handAlreadyFinished
        }
        self.outcome = outcome
    }
    
    mutating func forfeitBet() -> Chip {
        #warning("TODO: Disallow if hand is finished")
        let amount = bet
        bet = 0
        return amount
    }
    
    mutating func increaseBet(_ amount: Chip) {
        #warning("TODO: Disallow if hand is finished")
        bet += amount
    }
    
    mutating func forfeitInsurance() -> Chip {
        #warning("TODO: Disallow if hand is finished")
        let amount = insurance
        insurance = 0
        return amount
    }

    mutating func addInsurance(amount: Chip) throws {
        #warning("TODO: Disallow if hand is finished")
        insurance += amount
    }
    
    mutating func returnInsurance() -> Chip {
        #warning("TODO: Disallow if hand is finished")
        let amount = insurance
        insurance = 0
        return amount
    }
    
    mutating func addCard(_ card: PlayerCard<Card>) {
        #warning("TODO: Disallow if hand is finished")
        cards.append(card)
    }

    mutating func revealCard(at index: Int) throws {
        #warning("TODO: Disallow if hand is finished")
        guard index >= 0 && index < cards.count else {
            throw HandError.invalidCardIndex
        }
        try cards[index].reveal()
    }
    
    mutating func returnCards() -> [Card] {
        #warning("TODO: Disallow if hand is finished")
        let output = cards.map { $0.card }
        cards.removeAll()
        return output
    }
}

extension Hand: CustomStringConvertible {
    var description: String {
        """
        HAND:
        Bet: \(bet)
        Insurance: \(insurance)
        Outcome: \(outcome)
        Cards: [\(cards.map { String(describing: $0) }.joined(separator: ", "))]
        """
    }
}
