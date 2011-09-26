//
//  PokerTests.m
//  PokerTests
//
//  Created by Brandon Smith on 9/20/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "PokerTests.h"
#import "PokerGame.h"

@implementation PokerTests {
    NSMutableArray *cards_;
    Deck *deck_;
    PokerHand *hand_;
    PokerTable *table_;
}

- (void)setUp {
    [super setUp];
    // Generate each of the available cards
    cards_ = [NSMutableArray arrayWithCapacity:52];
    for (CardSuit suit = kCardSuitClubs; suit < kCardSuitCount; suit++) {
        for (CardRank rank = kCardRankTwo; rank < kCardRankCount; rank++) {
            Card *card = [[Card alloc] initWithSuit:suit andRank:rank];
            STAssertNotNil(card, @"Failed to initialize card", nil);
            [cards_ addObject:card];
        }
    }
    // Create a deck with the cards
    deck_ = [[Deck alloc] initWithCards:cards_];
    STAssertNotNil(deck_, @"Failed to initialize card", nil);
    
    // Create a hand with the first 5 cards
    NSMutableArray *hand_cards = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        [hand_cards addObject:[cards_ objectAtIndex:i]];
    }
    hand_ = [[PokerHand alloc] initWithCards:hand_cards];
    STAssertNotNil(hand_, @"Failed to initialize hand", nil);
    
    // Create a table
    NSArray *names = [NSArray arrayWithObjects:@"Brandon", @"Travis", @"Taylor", @"Rory", @"Shawn", nil];
    NSMutableArray *players = [NSMutableArray array];
    for (NSString *name in names) {
        [players addObject:[[PokerPlayer alloc] initWithName:name]];
    }
    table_ = [[PokerTable alloc] initWithPlayers:players];
    STAssertNotNil(table_, @"Failed to initialize table", nil);
}

- (void)tearDown {    
    [super tearDown];
}

- (void)testCardDescription {
    // Test Ace of spades
    Card *card = [[Card alloc] initWithSuit:kCardSuitSpades andRank:kCardRankAce];
    STAssertTrue([card.description isEqualToString:@"As"] , @"Incorrect card description.  Got: %@", card.description);
    // Test Two of clubs
    card = [[Card alloc] initWithSuit:kCardSuitClubs andRank:kCardRankTwo];
    STAssertTrue([card.description isEqualToString:@"2c"] , @"Incorrect card description", nil);
    // Test 10 of hearts
    card = [[Card alloc] initWithSuit:kCardSuitHearts andRank:kCardRankTen];
    STAssertTrue([card.description isEqualToString:@"Th"] , @"Incorrect card description", nil);

}

- (void)testShuffle {
    // Shuffle and check size
    [deck_ shuffle];
}

- (void)testDraw {
    NSMutableArray *drawnCards = [NSMutableArray array];
    
    // Draw the entire deck
    Card *drawnCard;
    while (deck_.cards.count > 0) {
        drawnCard = [deck_ draw];
        STAssertTrue([cards_ containsObject:drawnCard] , @"Unexpected card drawn", nil);
        [drawnCards addObject:drawnCard];
    }
    
    // Try to draw a card from an empty deck
    drawnCard = [deck_ draw];
    STAssertNil(drawnCard, @"Card drawn from empty deck", nil);
    
    // Add cards back into deck
    deck_.cards = [drawnCards mutableCopy];
}

- (void)testHand {
    NSString *expectedDescription = @"2c 3c 4c 5c 6c ";
    STAssertTrue([[hand_ description] isEqualToString:expectedDescription], @"Incorrect hand description %@", [hand_ description]);
    
    NSString *expectedRankName = @"Straight Flush";
    STAssertTrue([hand_.rankName isEqualToString:expectedRankName], @"Incorrect rank name %@", hand_.rankName);
    
    Card *c1 = [[Card alloc] initWithSuit:kCardSuitClubs andRank:kCardRankAce];
    Card *c2 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankAce];
    Card *c3 = [[Card alloc] initWithSuit:kCardSuitClubs andRank:kCardRankQueen];
    Card *c4 = [[Card alloc] initWithSuit:kCardSuitHearts andRank:kCardRankQueen];
    Card *c5 = [[Card alloc] initWithSuit:kCardSuitSpades andRank:kCardRankQueen];
    NSArray *cards = [NSArray arrayWithObjects:c1,c2,c3,c4,c5,nil];
    PokerHand *hand = [[PokerHand alloc] initWithCards:cards];
    expectedRankName = @"Full House";
    STAssertTrue([hand.rankName isEqualToString:expectedRankName], @"Incorrect rank name %@", hand.rankName);
    
    c1 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankAce];
    c2 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankJack];
    c3 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankSeven];
    c4 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankSix];
    c5 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankQueen];
    cards = [NSArray arrayWithObjects:c1,c2,c3,c4,c5,nil];
    hand = [[PokerHand alloc] initWithCards:cards];
    expectedRankName = @"Flush";
    STAssertTrue([hand.rankName isEqualToString:expectedRankName], @"Incorrect rank name %@", hand.rankName);
    
    c1 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankAce];
    c2 = [[Card alloc] initWithSuit:kCardSuitClubs andRank:kCardRankSix];
    c3 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankSix];
    c4 = [[Card alloc] initWithSuit:kCardSuitHearts andRank:kCardRankSix];
    c5 = [[Card alloc] initWithSuit:kCardSuitSpades andRank:kCardRankSix];
    cards = [NSArray arrayWithObjects:c1,c2,c3,c4,c5,nil];
    hand = [[PokerHand alloc] initWithCards:cards];
    expectedRankName = @"Four of a Kind";
    STAssertTrue([hand.rankName isEqualToString:expectedRankName], @"Incorrect rank name %@", hand.rankName);
    
    c1 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankAce];
    c2 = [[Card alloc] initWithSuit:kCardSuitClubs andRank:kCardRankJack];
    c3 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankQueen];
    c4 = [[Card alloc] initWithSuit:kCardSuitHearts andRank:kCardRankKing];
    c5 = [[Card alloc] initWithSuit:kCardSuitSpades andRank:kCardRankTen];
    cards = [NSArray arrayWithObjects:c1,c2,c3,c4,c5,nil];
    hand = [[PokerHand alloc] initWithCards:cards];
    expectedRankName = @"Straight";
    STAssertTrue([hand.rankName isEqualToString:expectedRankName], @"Incorrect rank name %@", hand.rankName);
    
    c1 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankAce];
    c2 = [[Card alloc] initWithSuit:kCardSuitClubs andRank:kCardRankAce];
    c3 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankQueen];
    c4 = [[Card alloc] initWithSuit:kCardSuitHearts andRank:kCardRankAce];
    c5 = [[Card alloc] initWithSuit:kCardSuitSpades andRank:kCardRankTen];
    cards = [NSArray arrayWithObjects:c1,c2,c3,c4,c5,nil];
    hand = [[PokerHand alloc] initWithCards:cards];
    expectedRankName = @"Three of a Kind";
    STAssertTrue([hand.rankName isEqualToString:expectedRankName], @"Incorrect rank name %@", hand.rankName);
    
    c1 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankAce];
    c2 = [[Card alloc] initWithSuit:kCardSuitClubs andRank:kCardRankAce];
    c3 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankQueen];
    c4 = [[Card alloc] initWithSuit:kCardSuitHearts andRank:kCardRankQueen];
    c5 = [[Card alloc] initWithSuit:kCardSuitSpades andRank:kCardRankTen];
    cards = [NSArray arrayWithObjects:c1,c2,c3,c4,c5,nil];
    hand = [[PokerHand alloc] initWithCards:cards];
    expectedRankName = @"Two Pair";
    STAssertTrue([hand.rankName isEqualToString:expectedRankName], @"Incorrect rank name %@", hand.rankName);
    
    c1 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankAce];
    c2 = [[Card alloc] initWithSuit:kCardSuitClubs andRank:kCardRankAce];
    c3 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankKing];
    c4 = [[Card alloc] initWithSuit:kCardSuitHearts andRank:kCardRankQueen];
    c5 = [[Card alloc] initWithSuit:kCardSuitSpades andRank:kCardRankTen];
    cards = [NSArray arrayWithObjects:c1,c2,c3,c4,c5,nil];
    hand = [[PokerHand alloc] initWithCards:cards];
    expectedRankName = @"One Pair";
    STAssertTrue([hand.rankName isEqualToString:expectedRankName], @"Incorrect rank name %@", hand.rankName);
    
    c1 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankAce];
    c2 = [[Card alloc] initWithSuit:kCardSuitClubs andRank:kCardRankTwo];
    c3 = [[Card alloc] initWithSuit:kCardSuitDiamonds andRank:kCardRankKing];
    c4 = [[Card alloc] initWithSuit:kCardSuitHearts andRank:kCardRankQueen];
    c5 = [[Card alloc] initWithSuit:kCardSuitSpades andRank:kCardRankTen];
    cards = [NSArray arrayWithObjects:c1,c2,c3,c4,c5,nil];
    hand = [[PokerHand alloc] initWithCards:cards];
    expectedRankName = @"High Card";
    STAssertTrue([hand.rankName isEqualToString:expectedRankName], @"Incorrect rank name %@", hand.rankName);
}

- (void)testGame {
    PokerGame *game = [[PokerGame alloc] initWithTable:table_ andDeck:deck_];
    
    // Make sure blinds are correct
    /**
    [game postBlinds];
    PokerPlayer *smallPlayer = [table_.players objectAtIndex:1];
    PokerPlayer *bigPlayer = [table_.players objectAtIndex:2];
    STAssertEquals(smallPlayer.currentBet, table_.smallBlind, @"Failed to post proper small blind", nil);
    STAssertEquals(bigPlayer.currentBet, table_.bigBlind, @"Failed to post proper big blind", nil);
    
    [game dealHoleCards];
    for (PokerPlayer *p in table_.players) {
        STAssertEquals(2, (int)p.holeCards.count, @"Failed to deal correct number of hole cards: %d", p.holeCards.count);
    }
    
    [game collectBetsStartingAtIndex:3 withCallAmount:table_.bigBlind];
     */
    int handNum = 1;
    while (game.table.players.count > 1) {
        NSLog(@"******* Starting hand %d *******", handNum);
        NSLog(@"%@", table_);
        [game playHand];
        handNum++;
    }
}

@end
