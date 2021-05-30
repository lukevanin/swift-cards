//
//  Hand.swift
//  Blackjack
//
//  Created by Luke Van In on 2021/05/30.
//

import Foundation


struct Hand: Equatable {
    
    private let aceScores: [Int : [Score]] = [
        0: [0],
        1: [1, 11],
        2: [2, 11 + 1],
        3: [3, 11 + 2],
        4: [4, 11 + 3],
    ]
    
    private(set) var cards: [PlayerCard] = []
    
    init() {
    }
    
    init(card: PlayerCard) {
        self.cards = [card]
    }
    
    init(cards: [PlayerCard]) {
        self.cards = cards
    }
    
    func score() throws -> Score {
        // Remove aces into separate set
        // Add all other cards
        // Calculate permutations of scores for number of aces
        try cards.forEach { card in
            if card.face != .up {
                throw BlackjackError.cardNotRevealed
            }
        }
        let numberOfAces = cards.reduce(0) { result, card in
            result + (card.card.rank == .ace ? 1 : 0)
        }
        let subtotal = cards.reduce(0) { result, card in
            result + (card.card.rank != .ace ? card.card.rank.denomination : 0)
        }
        let aceScores = self.aceScores[numberOfAces]!
        let scores = aceScores.map { score in
            subtotal + score
        }
        precondition(scores.count > 0)
        guard let score = scores.filter({ $0 <= 21 }).max() else {
            return scores.min()!
        }
        return score
    }
    
    mutating func addCard(_ card: PlayerCard) {
        cards.append(card)
    }
    
    mutating func revealCard(at index: Int) throws {
        guard index >= 0 && index < cards.count else {
            throw BlackjackError.invalidCard
        }
        try cards[index].reveal()
    }
    
    mutating func split() throws -> Hand {
        guard cards.count == 2 else {
            throw BlackjackError.cannotSplitNonPair
        }
        guard cards[0].card.rank.denomination == cards[1].card.rank.denomination else {
            throw BlackjackError.cannotSplitDifferentDenominations
        }
        let newHandCard = cards.removeLast()
        return Hand(card: newHandCard)
    }
}

extension Hand: CustomStringConvertible {
    var description: String {
        "<HAND: [\(cards.map { String(describing: $0) }.joined(separator: ", "))]>"
    }
}
