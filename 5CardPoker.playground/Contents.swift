import UIKit


enum Suit {
    case spades, clubs, hearts, diamonds
}

enum PlayingCardValue: Int {
    case one = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
}

struct Card {
    var suit: Suit
    var value: PlayingCardValue
}

struct Hand {
    let cards: [Card]
    var handType: [HandType]? // Bonus points for changing from a string to a custom enum of all the winningHands
    
    init?(cards: [Card]) {
        guard cards.count == 5 else { return nil }
        self.cards = cards
    }
}

enum HandType {
    case HighCard
    case OnePair
    case TwoPairs
    case ThreeOfAKind
    case Straight
    case Flush
    case FullHouse
    case FourOfAKind
    case StraightFlush
    case RoyalFlush
}


/// determineWinner will take in an array of "Poker" hands and determine which hand is better (according to texas holdem rules).
/// Traditionally in Texas Holdem you are only given 2 cards and then 5 other cards are placed flipped up in front of everyone.
/// In our version each player is given 5 cards with no cards placed on the table.
/// Based on just the 5 cards given in a hand. You are to determine what type of winning hands a player has and which is best.
/// For example a player may have a 2 of a kind and a 3 of a kind in a single hand. 3 of a kind is better than 2 of a kind and should be used to determine if their hand is better than any of the other players hands.
///
/// - Returns: Hand - Which is the hand that won. It is expected that the handType property("2 of a kind", "3 of a kind", "4 of a kind", etc) will have a value when returning the winning hand.
///

func determineWinner(hands: [Hand]) -> Hand? {
    // make sure there are more than two players
    guard hands.count >= 2 else { return nil }
    var values: [Int] = []
    for hand in hands {
        var handValues: [HandType]
        var handSuits: Suit
        
        
        
    }
    

    return nil
}



func pokerWinner(hands: [[String]]) -> String {
    
    // Define arrays to store the values and suits of each hand
    let values = hands.map { $0.map { card in
        let value = String(card.prefix(1))
        switch value {
            case "A": return 14
            case "K": return 13
            case "Q": return 12
            case "J": return 11
            default: return Int(value)!
        }
    }}
    let suits = hands.map { $0.map { String($0.suffix(1)) } }
    
    // Check for a tie
    if values.allSatisfy({ $0 == values[0] }) {
        return "Tie"
    }
    
    // Define the hand rankings and corresponding messages
    let handRankings: [(values: Set<Int>, ranking: String)] = [
        (Set([10, 11, 12, 13, 14]), "straight flush"),
        (Set(values.flatMap { $0 }.filter { val in values.flatMap { $0 }.filter { $0 == val }.count == 4 }), "four of a kind"),
        (Set(values.flatMap { $0 }.filter { val in values.flatMap { $0 }.filter { $0 == val }.count == 3 })
         .intersection(Set(values.flatMap { $0 }.filter { val in values.flatMap { $0 }.filter { $0 == val }.count == 2 })), "full house"),
    ]
    
    // Check for hand rankings
    for (index, handValues) in values.enumerated() {
        for (values, ranking) in handRankings {
            if values.isSubset(of: Set(handValues)) {
                return "Hand \(index + 1) wins with a \(ranking)"
            }
        }
    }
    
    // Return the highest card in the highest ranked hand
    let highestRankedHandIndex = values.enumerated().max(by: { (a, b) -> Bool in
        if a.element.max() == b.element.max() {
            for i in (0...4).reversed() {
                if a.element[i] != b.element[i] {
                    return a.element[i] < b.element[i]
                }
            }
            return false
        } else {
            return a.element.max()! < b.element.max()!
        }
    })!.offset
    return "Hand \(highestRankedHandIndex + 1) wins with a high card"
}

let hands = [
    ["2H", "3D", "5S", "9C", "KD"],
    ["2C", "3H", "4S", "8C", "AH"],
    ["2S", "3C", "4H", "5D", "6D"],
    ["2H", "2D", "4C", "4D", "4S"]
]

let hands1 = [
    ["2H", "2D", "5S", "5C", "5D"],
    ["2C", "4H", "4S", "8C", "AH"],
    ["2S", "3C", "4H", "5D", "8D"],
    ["2H", "3D", "4C", "5D", "6S"]
]

let hands2 = [
    ["10D", "11D", "12D", "13D", "14D"],
    ["2C", "4H", "4S", "8C", "AH"],
    ["2S", "3C", "4H", "5D", "6D"],
    ["10H", "11H", "12H", "13H", "14H"]
]

let winner1 = pokerWinner(hands: hands)
print(winner1)
let winner2 = pokerWinner(hands: hands1)
print(winner2)
let winner3 = pokerWinner(hands: hands2)
print(winner3)
