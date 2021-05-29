//
//  BlackjackGame.swift
//  Cards
//
//  Created by Luke Van In on 2021/05/27.
//

///
/// https://bicyclecards.com/how-to-play/blackjack/
///
/// ## The Pack
///
/// The standard 52-card pack is used, but in most casinos several decks of cards are shuffled together. The
/// six-deck game (312 cards) is the most popular. In addition, the dealer uses a blank plastic card, which is
/// never dealt, but is placed toward the bottom of the pack to indicate when it will be time for the cards to be
/// reshuffled.
///
/// ## OBJECT OF THE GAME
///
/// Each participant attempts to beat the dealer by getting a count as close to 21 as possible, without going
/// over 21
///
/// ## CARD VALUES/SCORING
///
/// It is up to each individual player if an ace is worth 1 or 11. Face cards are 10 and any other card is its pip
/// value.
///
/// ## BETTING
///
/// Before the deal begins, each player places a bet, in chips, in front of them in the designated area.
/// Minimum and maximum limits are established on the betting, and the general limits are from $2 to $500.
///
/// ## THE SHUFFLE AND CUT
///
/// The dealer thoroughly shuffles portions of the pack until all the cards have been mixed and combined. The
/// dealer designates one of the players to cut, and the plastic insert card is placed so that the last 60 to 75
/// cards or so will not be used. (Not dealing to the bottom of all the cards makes it more difficult for
/// professional card counters to operate effectively.)
///
/// ## THE DEAL
///
/// When all the players have placed their bets, the dealer gives one card face up to each player in rotation
/// clockwise, and then one card face up to themselves. Another round of cards is then dealt face up to each
/// player, but the dealer takes the second card face down. Thus, each player except the dealer receives two
/// cards face up, and the dealer receives one card face up and one card face down. (In some games, played
/// with only one deck, the players' cards are dealt face down and they get to hold them. Today, however,
/// virtually all Blackjack games feature the players' cards dealt face up on the condition that no player may
/// touch any cards.)
///
/// ## NATURALS
///
/// If a player's first two cards are an ace and a "ten-card" (a picture card or 10), giving a count of 21 in two
/// cards, this is a natural or "blackjack." If any player has a natural and the dealer does not, the dealer
/// immediately pays that player one and a half times the amount of their bet. If the dealer has a natural, they
/// immediately collect the bets of all players who do not have naturals, (but no additional amount). If the
/// dealer and another player both have naturals, the bet of that player is a stand-off (a tie), and the player
/// takes back his chips.
///
/// If the dealer's face-up card is a ten-card or an ace, they look at their face-down card to see if the two cards
/// make a natural. If the face-up card is not a ten-card or an ace, they do not look at the face-down card until
/// it is the dealer's turn to play.
///
/// ## THE PLAY
///
/// The player to the left goes first and must decide whether to "stand" (not ask for another card) or "hit" (ask
/// for another card in an attempt to get closer to a count of 21, or even hit 21 exactly). Thus, a player may
/// stand on the two cards originally dealt to them, or they may ask the dealer for additional cards, one at a
/// time, until deciding to stand on the total (if it is 21 or under), or goes "bust" (if it is over 21). In the latter
/// case, the player loses and the dealer collects the bet wagered. The dealer then turns to the next player to
/// their left and serves them in the same manner.
///
/// The combination of an ace with a card other than a ten-card is known as a "soft hand," because the player
/// can count the ace as a 1 or 11, and either draw cards or not. For example with a "soft 17" (an ace and a
/// 6), the total is 7 or 17. While a count of 17 is a good hand, the player may wish to draw for a higher total. If
/// the draw creates a bust hand by counting the ace as an 11, the player simply counts the ace as a 1 and
/// continues playing by standing or "hitting" (asking the dealer for additional cards, one at a time).
///
/// ## THE DEALER'S PLAY
///
/// When the dealer has served every player, the dealers face-down card is turned up. If the total is 17 or
/// more, it must stand. If the total is 16 or under, they must take a card. The dealer must continue to take
/// cards until the total is 17 or more, at which point the dealer must stand. If the dealer has an ace, and
/// ounting it as 11 would bring the total to 17 or more (but not over 21), the dealer must count the ace as 11
/// and stand. The dealer's decisions, then, are automatic on all plays, whereas the player always has the
/// option of taking one or more cards.
///
/// ## SIGNALING INTENTIONS
///
/// When a player's turn comes, they can say "Hit" or can signal for a card by scratching the table with a
/// finger or two in a motion toward themselves, or they can wave their hand in the same motion that would
/// say to someone "Come here!" When the player decides to stand, they can say "Stand" or "No more," or
/// can signal this intention by moving their hand sideways, palm down and just above the table.
///
/// ## SPLITTING PAIRS
///
/// If a player's first two cards are of the same denomination, such as two jacks or two sixes, they may choose
/// to treat them as two separate hands when their turn comes around. The amount of the original bet then
/// goes on one of the cards, and an equal amount must be placed as a bet on the other card. The player first
/// plays the hand to their left by standing or hitting one or more times; only then is the hand to the right
/// played. The two hands are thus treated separately, and the dealer settles with each on its own merits. With
/// a pair of aces, the player is given one card for each ace and may not draw again. Also, if a ten-card is
/// dealt to one of these aces, the payoff is equal to the bet (not one and one-half to one, as with a blackjack
/// at any other time).
///
/// ## DOUBLING DOWN
///
/// Another option open to the player is doubling their bet when the original two cards dealt total 9, 10, or 11.
/// When the player's turn comes, they place a bet equal to the original bet, and the dealer gives the player
/// just one card, which is placed face down and is not turned up until the bets are settled at the end of the
/// hand. With two fives, the player may split a pair, double down, or just play the hand in the regular way.
/// Note that the dealer does not have the option of splitting or doubling down.
///
/// ## INSURANCE
///
/// When the dealer's face-up card is an ace, any of the players may make a side bet of up to half the original
/// bet that the dealer's face-down card is a ten-card, and thus a blackjack for the house. Once all such side
/// bets are placed, the dealer looks at the hole card. If it is a ten-card, it is turned up, and those players who
/// have made the insurance bet win and are paid double the amount of their half-bet - a 2 to 1 payoff. When
/// a blackjack occurs for the dealer, of course, the hand is over, and the players' main bets are collected -
/// unless a player also has blackjack, in which case it is a stand-off. Insurance is invariably not a good
/// proposition for the player, unless they are quite sure that there are an unusually high number of ten-cards
/// still left undealt.
///
/// ## SETTLEMENT
///
/// A bet once paid and collected is never returned. Thus, one key advantage to the dealer is that the player
/// goes first. If the player goes bust, they have already lost their wager, even if the dealer goes bust as well.
/// If the dealer goes over 21, the dealer pays each player who has stood the amount of that player's bet. If
/// the dealer stands at 21 or less, the dealer pays the bet of any player having a higher total (not exceeding
/// 21) and collects the bet of any player having a lower total. If there is a stand-off (a player having the
/// same total as the dealer), no chips are paid out or collected.
///
/// ## RESHUFFLING
///
/// When each player's bet is settled, the dealer gathers in that player's cards and places them face up at the
/// side against a clear plastic L-shaped shield. The dealer continues to deal from the shoe until coming to the
/// plastic insert card, which indicates that it is time to reshuffle. Once that round of play is over, the dealer
/// shuffles all the cards, prepares them for the cut, places the cards in the shoe, and the game continues.
///
/// ## BASIC STRATEGY
///
/// Winning tactics in Blackjack require that the player play each hand in the optimum way, and such strategy
/// always takes into account what the dealer's upcard is. When the dealer's upcard is a good one, a 7, 8, 9,
/// 10-card, or ace for example, the player should not stop drawing until a total of 17 or more is reached.
/// When the dealer's upcard is a poor one, 4, 5, or 6, the player should stop drawing as soon as he gets a
/// total of 12 or higher. The strategy here is never to take a card if there is any chance of going bust. The
/// desire with this poor holding is to let the dealer hit and hopefully go over 21. Finally, when the dealer's up
/// card is a fair one, 2 or 3, the player should stop with a total of 13 or higher.
///
/// With a soft hand, the general strategy is to keep hitting until a total of at least 18 is reached. Thus, with an
/// ace and a six (7 or 17), the player would not stop at 17, but would hit.
///
/// The basic strategy for doubling down is as follows: With a total of 11, the player should always double
/// down. With a total of 10, he should double down unless the dealer shows a ten-card or an ace. With a total
/// of 9, the player should double down only if the dealer's card is fair or poor (2 through 6).
///
/// For splitting, the player should always split a pair of aces or 8s; identical ten-cards should not be split, and
/// neither should a pair of 5s, since two 5s are a total of 10, which can be used more effectively in doubling
/// down. A pair of 4s should not be split either, as a total of 8 is a good number to draw to. Generally, 2s, 3s,
/// or 7s can be split unless the dealer has an 8, 9, ten-card, or ace. Finally, 6s should not be split unless the
/// dealer's card is poor (2 through 6).
///

import Foundation

import Deck


typealias Card = StandardDeck.Card


typealias Denomination = UInt


typealias Score = UInt


public enum BlackjackError: Error {
    case invalidHand
    case invalidCard
    case cardAlreadyRevealed
    case cannotSplitNonPair
    case cannotSplitDifferentDenominations
    case splitLimitReached
}


struct PlayerCard: Hashable {
    
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


struct Hand: Equatable {
    
    private(set) var cards: [PlayerCard] = []
    
    init() {
    }
    
    init(card: PlayerCard) {
        self.cards = [card]
    }
    
    init(cards: [PlayerCard]) {
        self.cards = cards
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


struct Player: Equatable {
    
    let splitLimit: Int
    private(set) var splits: Int
    private(set) var hands: [Hand]
    
    init(splitLimit: Int = 0, splits: Int = 0, hands: [Hand] = [Hand()]) {
        precondition(hands.count > 0)
        self.hands = hands
        self.splitLimit = splitLimit
        self.splits = splits
    }
    
    mutating func addCardToHand(_ card: PlayerCard, at hand: Int) throws {
        guard hand >= 0 && hand < hands.count else {
            throw BlackjackError.invalidHand
        }
        hands[hand].addCard(card)
    }
    
    mutating func splitHand(_ hand: Int) throws {
        guard hand >= 0 && hand < hands.count else {
            throw BlackjackError.invalidHand
        }
        guard splits < splitLimit else {
            throw BlackjackError.splitLimitReached
        }
        splits += 1
        let newHand = try hands[hand].split()
        hands.insert(newHand, at: hand + 1)
    }
}

extension Player: CustomStringConvertible {
    var description: String {
        """
        PLAYER:
        Splits: \(splits) out of \(splitLimit)
        Hands: [\(hands.map { String(describing: $0) }.joined(separator: "; "))]
        """
    }
}


struct Dealer: Equatable {
    
    private(set) var hand: Hand
    
    init() {
        self.hand = Hand()
    }
    
    init(hand: Hand) {
        self.hand = hand
    }
    
    mutating func addCard(_ card: PlayerCard) {
        hand.addCard(card)
    }
    
    mutating func revealCard(at index: Int) throws {
        try hand.revealCard(at: index)
    }
}

extension Dealer: CustomStringConvertible {
    var description: String {
        "<DEALER: \(hand)>"
    }
}


extension Card.Rank {
    
    private static let denominations: [Card.Rank : Denomination] = [
        .ace: 1,
        .two: 2,
        .three: 3,
        .four: 4,
        .five: 5,
        .six: 6,
        .seven: 7,
        .eight: 8,
        .nine: 9,
        .ten: 10,
        .jack: 10,
        .queen: 10,
        .king: 10,
    ]

    var denomination: Denomination {
        Self.denominations[self]!
    }
}



struct Blackjack: Equatable {
    
    var shoe: Shoe<Card>
    var dealer: Dealer
    var player: Player
    
    init(
        shoe: Shoe<Card> = Shoe(cards: Card.all),
        dealer: Dealer = Dealer(),
        player: Player = Player()
    ) {
        self.shoe = shoe
        self.dealer = dealer
        self.player = player
    }

    func playerScore(forHand hand: Int) -> Score {
        return 0
    }
    
    func dealerScore() -> Score {
        return 0
    }
    
    mutating func dealCard() throws -> Card {
        return try shoe.deal()
    }
    
    mutating func giveCardToPlayer(_ card: PlayerCard, hand: Int) throws {
        try player.addCardToHand(card, at: hand)
    }
    
    mutating func splitPlayerHand(_ hand: Int) throws {
        try player.splitHand(hand)
    }
    
    mutating func giveCardToDealer(_ card: PlayerCard) {
        dealer.addCard(card)
    }
    
    mutating func revealDealerCard(at index: Int) throws {
        try dealer.revealCard(at: index)
    }
}

extension Blackjack: CustomStringConvertible {
    
    var description: String {
        """
        BLACKJACK:
        \(shoe)
        \(dealer)
        \(player)
        """
    }
}
