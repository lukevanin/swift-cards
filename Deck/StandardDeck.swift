//
//  StandardDeck.swift
//  Deck
//
//  Created by Luke Van In on 2021/05/25.
//

import Foundation


public typealias StandardDeck = FiftyTwoCardFrenchSuiteDeck


///
/// "The most common type of playing card is that found in the French-suited, standard 52-card pack"
/// https://en.wikipedia.org/wiki/Playing_card
///
///  There are four suites in a deck of playing cards. The suites are (in alphabetical order):
/// - Clubs ♣️
/// - Diamonds ♦️
/// - Hearts ♥️
/// - Spades ♠️
///
/// Each suite is one of two colors, being either red or black.
///
/// There are thirteen cards in each suite. The cards are:
/// - King
/// - Queen
/// - Jack
/// - Ten
/// - Nine
/// - Eight
/// - Seven
/// - Six
/// - Five
/// - Four
/// - Three
/// - Two
/// - Ace
///
/// The deck has a total of fifty two cards, where there is one card for each combination of rank and suite.
///
/// Cards usually have some semantic value depending on the rules of the game being played. Cards might
/// be compared by their relative face value (e.g. King vs Seven), suite (e.g. Hearts vs Diamonds), or
/// color (e.g. Red vs Black).
///
public struct FiftyTwoCardFrenchSuiteDeck: AbstractDeck {

    public struct Suite: AbstractSuite {

        /// Playing card color. Cards are normally either red (for hearts and diamonds), or black (clubs and spades).

        public struct Color: AbstractColor {
            public static let red = Color(name: "red", color: "🟥")
            public static let black = Color(name: "black", color: "⬛️")
            
            public static var all = Set<Color>([.red, .black])
            
            public var description: String {
                return "\(name)"
            }
            
            public let name: String
            public let color: Character
        }

        public static let clubs = Suite(name: "clubs", symbol: "♣️", color: .black)
        public static let diamonds = Suite(name: "diamonds", symbol: "♦️", color: .red)
        public static let hearts = Suite(name: "hearts", symbol: "♥️", color: .red)
        public static let spades = Suite(name: "spades", symbol: "♠️", color: .black)

        public static let all = Set<Suite>([.clubs, .diamonds, .hearts, .spades])

        public var description: String {
            return "\(name)"
        }

        public let name: String
        public let symbol: Character
        public let color: Color
    }
    
    public struct Rank: AbstractRank {
        
        public static let king = Rank(name: "king", symbol: "K")
        public static let queen = Rank(name: "queen", symbol: "Q")
        public static let jack = Rank(name: "jack", symbol: "J")
        public static let ten = Rank(name: "ten", symbol: "T")
        public static let nine = Rank(name: "nine", symbol: "9")
        public static let eight = Rank(name: "eight", symbol: "8")
        public static let seven = Rank(name: "seven", symbol: "7")
        public static let six = Rank(name: "six", symbol: "6")
        public static let five = Rank(name: "five", symbol: "5")
        public static let four = Rank(name: "four", symbol: "4")
        public static let three = Rank(name: "three", symbol: "3")
        public static let two = Rank(name: "two", symbol: "2")
        public static let ace = Rank(name: "ace", symbol: "A")
        
        public static let all = Set<Rank>([.king, .queen, .jack, .ten, .nine, .eight, .seven, .six, .five, .four, .three, .two, .ace])
        
        public var description: String {
            return "\(name) \(symbol)"
        }

        public let name: String
        public let symbol: Character
    }

    public struct Card: AbstractCard {
        
        public static let all: Set<Card> = {
            Set(
                Suite.all
                    .map { suite in
                        Rank.all.map { rank in
                            Card(rank: rank, suite: suite)
                        }
                    }
                    .joined()
            )
        }()

        public var description: String {
            return "\(rank.name) of \(suite.name)"
        }

        public let rank: Rank
        public var suite: Suite
        
        public init(rank: Rank, suite: Suite) {
            self.rank = rank
            self.suite = suite
        }
    }
}
