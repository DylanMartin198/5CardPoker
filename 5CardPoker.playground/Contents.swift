import UIKit


enum Suit: CaseIterable {
    case spades, clubs, hearts, diamonds
}

enum PlayingCardValue: Int, CaseIterable {
    case one = 1, two = 2, three = 3, four = 4, five = 5, six = 6, seven = 7, eight = 8, nine = 9, ten = 10, jack = 11, queen = 12, king = 13, ace = 14
}

struct Card {
    var suit: Suit
    var value: PlayingCardValue
}

struct Hand {
    let cards: [Card]
    var handType: HandType?

    init?(cards: [Card]) {
        guard cards.count == 5 else { return nil }
        self.cards = cards
        self.handType = determineHandType(cards)
    }
}

enum HandType: String {
    case HighCard = "HighCard"
    case OnePair = "OnePair"
    case TwoPairs = "TwoPairs"
    case ThreeOfAKind = "ThreeOfAKind"
    case Straight = "Straight"
    case Flush = "Flush"
    case FullHouse = "FullHouse"
    case FourOfAKind = "FourOfAKind"
    case StraightFlush = "StraightFlush"
    case RoyalFlush = "RoyalFlush"
}

func determineWinner(_ hands: [Hand]) -> Hand? {
    // make sure there are more than two players
    guard hands.count >= 2 else { return nil }
    var winningHand: Hand?
    for hand in hands {
        guard let handType = hand.handType else {
            continue // skip hands that don't have a valid hand type
        }
        if let currentWinningHand = winningHand,
           currentWinningHand.handType!.rawValue == handType.rawValue {
            // if both hands have the same type, compare the highest card
            let currentWinningCard = currentWinningHand.cards.max { $0.value.rawValue < $1.value.rawValue }!
            let newWinningCard = hand.cards.max { $0.value.rawValue < $1.value.rawValue }!
            if newWinningCard.value.rawValue > currentWinningCard.value.rawValue {
                winningHand = hand
            }
        } else if winningHand == nil ||
                  handType.rawValue > winningHand!.handType!.rawValue {
            // if the new hand has a higher type than the current winning hand
            // or there is no current winning hand, we update the winning hand
            winningHand = hand
        }
    }
    return winningHand
}

func determineHandType(_ cards: [Card]) -> HandType {
    let values = cards.map { $0.value.rawValue }.sorted()
    let suits = cards.map { $0.suit }
    let isFlush = Set(suits).count == 1
    let isStraight = values.last! - values.first! == 4 && Set(values).count == 5
    let groupedValues = Dictionary(grouping: values, by: { $0 })
    let pairs = groupedValues.filter { $0.value.count == 2 }
    let triples = groupedValues.filter { $0.value.count == 3 }
    let quads = groupedValues.filter { $0.value.count == 4 }
    
    if isFlush && isStraight && values.last == PlayingCardValue.ace.rawValue {
        return .RoyalFlush
    }
    if isFlush && isStraight {
        return .StraightFlush
    }
    if quads.first != nil {
        return .FourOfAKind
    }
    if let triples = triples.first, let pairs = pairs.first {
        return .FullHouse
    }
    if isFlush {
        return .Flush
    }
    if isStraight {
        return .Straight
    }
    if triples.first != nil {
        return .ThreeOfAKind
    }
    if pairs.count == 2 {
        return .TwoPairs
    }
    if pairs.count == 1 {
        return .OnePair
    }
    return .HighCard
}


let hand1 = Hand(cards: [
    Card(suit: .hearts, value: .ace),
    Card(suit: .hearts, value: .king),
    Card(suit: .hearts, value: .queen),
    Card(suit: .hearts, value: .jack),
    Card(suit: .hearts, value: .ten)
])
let hand2 = Hand(cards: [
    Card(suit: .spades, value: .two),
    Card(suit: .spades, value: .four),
    Card(suit: .spades, value: .six),
    Card(suit: .spades, value: .eight),
    Card(suit: .spades, value: .ten)
])
let hand3 = Hand(cards: [
    Card(suit: .spades, value: .three),
    Card(suit: .spades, value: .three),
    Card(suit: .spades, value: .three),
    Card(suit: .spades, value: .four),
    Card(suit: .spades, value: .four)
])

let optionalHands: [Hand?] = [hand1, hand2, hand3]
let hands = optionalHands.compactMap { $0 }
let winner = determineWinner(hands)


/// determineWinner will take in an array of "Poker" hands and determine which hand is better (according to texas holdem rules).
/// Traditionally in Texas Holdem you are only given 2 cards and then 5 other cards are placed flipped up in front of everyone.
/// In our version each player is given 5 cards with no cards placed on the table.
/// Based on just the 5 cards given in a hand. You are to determine what type of winning hands a player has and which is best.
/// For example a player may have a 2 of a kind and a 3 of a kind in a single hand. 3 of a kind is better than 2 of a kind and should be used to determine if their hand is better than any of the other players hands.
///
/// - Returns: Hand - Which is the hand that won. It is expected that the handType property("2 of a kind", "3 of a kind", "4 of a kind", etc) will have a value when returning the winning hand.
///
