//
//  Deck.swift
//  Deck
//
//  Created by Luke Van In on 2021/05/25.
//

import Foundation


///
/// Defines the color for a suite in a deck.
///
/// E.g. A deck of playing cards usually has cards in two colors: red and black.
///
public protocol AbstractColor: Hashable, CustomStringConvertible {
    static var all: Set<Self> { get }
}


///
/// A suite is a named group of cards in a deck, usually indicated by a symbol and a color.
///
/// e.g. A deck of playing cards commonly has four suites, with one pair of suites being red, and the other pair
/// black.
///
public protocol AbstractSuite: Hashable, CustomStringConvertible {
    associatedtype Color: AbstractColor
    
    static var all: Set<Self> { get }
    
    var color: Color { get }
}


///
/// A rank indicates relative ordering or scoring for cards in a deck. The actual order or score is defined by the
/// rules of the game.
///
/// E.g. A deck of playing cards usually has thirteen ranks, in each of the four suites.
///
public protocol AbstractRank: Hashable, CustomStringConvertible {
    static var all: Set<Self> { get }
}


///
/// A card has a suite which is the symbol and color shown on the card (e.g. Hearts), and a rank which is the
/// relative value of the card (e.g. Jack).
///
/// e.g. A deck of playing cards will normally consist of 52 unique cards, with one card for each of the possible
/// combinations of suite and rank.
///
public protocol AbstractCard: Hashable, CustomStringConvertible {
    associatedtype Suite: AbstractSuite
    associatedtype Rank: AbstractRank
    
    static var all: Set<Self> { get }
    
    var suite: Suite { get }
    var rank: Rank { get }
}


///
/// A deck defines the properties of related cards, including:
/// - Colors
/// - Suites
/// - Ranks
///
/// For example, a deck of playing cards might be defined with:
/// - Colors: red and black
/// - Suites: Clubs, Diamonds, Hearts, Spades
/// - Ranks: Ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen, King
///
/// A deck only defines which cards and suites are available -  does not define a specific ordering for cards,
/// nor does it provide an API for managing a collection of cards. To get an ordered collection of cards, use an
/// array of `Card.all`. Collections of cards can also be managed by in a `Pack`.
///
/// Note that the relative order or score of suites or ranks is defined by the rules of the game in which the
/// deck is used and, as such, are _not_ defined by the deck.
///
public protocol AbstractDeck {
    associatedtype Suite: AbstractSuite
    associatedtype Rank: AbstractRank
    associatedtype Card: AbstractCard
}
