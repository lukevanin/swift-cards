//
//  PlayerCard.swift
//  Blackjack
//
//  Created by Luke Van In on 2021/05/30.
//

import Foundation

import Deck


struct PlayerCard<Card>: Hashable where Card: Hashable {
    
    enum Face: Hashable {
        case up
        case down
    }
    
    let card: Card
    var face: Face
    
    mutating func reveal() throws {
        guard face == .down else {
            throw BlackjackError.cardAlreadyRevealed
        }
        face = .up
    }
}

extension PlayerCard: CustomStringConvertible {
    var description: String {
        "<\(card) (\(face == .up ? "U" : "D"))>"
    }
}
