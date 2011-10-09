//
//  PokerGame.m
//  Poker
//
//  Created by Brandon Smith on 9/25/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "PokerGame.h"

@implementation PokerGame 
@synthesize table = table_;
@synthesize deck = deck_;
@synthesize playersInHand;
@synthesize stopped;
@synthesize handLog;

#pragma mark - Primited Game Methods

- (void)dealCardToPlayer:(PokerPlayer *)p {
    [p.holeCards addObject:[self.deck draw]];
    [self.handLog addObject:[NSString stringWithFormat:@"Hole Card dealt to %@",p.name]];
}

- (void)dealBurnCard {
    [self.table.burnedCards addObject:[self.deck draw]];
    [self.handLog addObject:[NSString stringWithString:@"Burn Card dealt"]];
}

- (void)dealCommunityCard {
    Card *cardToAdd = [self.deck draw];
    [self.table.communityCards addObject:cardToAdd];
    int idx = self.table.communityCards.count;
    if (idx < 4)
        [self.handLog addObject:[NSString stringWithFormat:@"%@ dealt to the flop", cardToAdd]];
    else if (idx == 4)
        [self.handLog addObject:[NSString stringWithFormat:@"%@ dealt to the turn", cardToAdd]];
    else
        [self.handLog addObject:[NSString stringWithFormat:@"%@ dealt to the river", cardToAdd]];
}

- (id)initWithTable:(PokerTable *)table andDeck:(Deck *)deck {
    self = [super init];
    if (self) {
        self.table = table;
        self.deck = deck;
        self.handLog = [NSMutableArray array];
    }
    return self;
}

- (void)addCurrentBetsToPot {
    for (PokerPlayer *p in playersInHand) {
        self.table.pot += p.currentBet;
        p.totalBet += p.currentBet;
        p.currentBet = 0;
    }
    [self.handLog addObject:[NSString stringWithFormat:@"Pot is now %d chips", self.table.pot]];
}

- (void)removeFoldedPlayers {
    for (PokerPlayer *p in self.table.players) {
        if (p.folded) {
            [playersInHand removeObject:p];
            p.folded = NO;
        }
    }
}

- (void)updatePlayers {
    NSMutableArray *players = [NSMutableArray array];
    for (PokerPlayer *p in self.table.players) {
        [p.holeCards removeAllObjects];
        if (p.chips > 0) {
            [players addObject:p];
        }
    }
    self.table.players = players;
    if (self.table.players.count <= 1)
        self.stopped = YES;
}

- (void)resetDeck {
    // Generate each of the available cards
    NSMutableArray *cards = [NSMutableArray arrayWithCapacity:52];
    for (CardSuit suit = kCardSuitClubs; suit < kCardSuitCount; suit++) {
        for (CardRank rank = kCardRankTwo; rank < kCardRankCount; rank++) {
            Card *card = [[Card alloc] initWithSuit:suit andRank:rank];
            [cards addObject:card];
        }
    }
    // Create a deck with the cards
    deck_ = [[Deck alloc] initWithCards:cards];
}

- (void)postBlinds {
    int smallBlindIdx = (self.table.buttonIndex+1) % self.table.players.count;
    int bigBlindIdx   = (self.table.buttonIndex+2) % self.table.players.count;
    PokerPlayer *player = [self.table.players objectAtIndex:smallBlindIdx];
    [player makeBet:self.table.smallBlind];
    player = [self.table.players objectAtIndex:bigBlindIdx];
    [player makeBet:self.table.bigBlind];
}

- (void)dealHoleCards {
    PokerPlayer *p;
    for (int i = 0; i < self.table.players.count*2; i++) {
        p = [self.table.players objectAtIndex:i%self.table.players.count];
        [self dealCardToPlayer:p];
    }
;}

- (void)dealFlop {
    [self dealBurnCard];
    [self dealCommunityCard];
    [self dealCommunityCard];
    [self dealCommunityCard];
}

- (void)dealTurn {
    [self dealBurnCard];
    [self dealCommunityCard];
}

- (void)dealRiver {
    [self dealBurnCard];
    [self dealCommunityCard];
}

- (void)getHands {
    NSMutableArray *sevenCards = [NSMutableArray arrayWithCapacity:7];
    for (PokerPlayer *p in playersInHand) {
        [sevenCards addObjectsFromArray:p.holeCards];
        [sevenCards addObjectsFromArray:self.table.communityCards];
        p.hand = [PokerHand bestHandFrom:sevenCards];
        [self.handLog addObject:[NSString stringWithFormat:@"%@ shows %@", p.name, p.hand]];
        [sevenCards removeAllObjects];
    }
    // Sort players by hand rank
    [playersInHand sortUsingComparator:^NSComparisonResult(PokerPlayer *p1, PokerPlayer *p2){
        if (p1.hand.rank < p2.hand.rank) return NSOrderedAscending;
        if (p1.hand.rank > p2.hand.rank) return NSOrderedDescending;
        return NSOrderedSame;
    }];
}

- (void)distributePot {
    int chipsToWin = table_.pot;
    for (PokerPlayer *p in playersInHand) {
        int beforeChips = p.chips;
        int beforeBet = p.totalBet;
        for (PokerPlayer *q in table_.players) {
            p.chips += MIN(q.totalBet, beforeBet);
            table_.pot -= MIN(q.totalBet, beforeBet);
            q.totalBet -= MIN(q.totalBet, beforeBet);
        }
        if (p.chips - beforeChips > 0)
            [self.handLog addObject:[NSString stringWithFormat:@"%@ won %d chips from the %d chip pot", p.name, (p.chips - beforeChips), chipsToWin]];
    }
}

- (void)collectBetsStartingAtIndex:(int)idx withCallAmount:(int)chips {
    [self.handLog addObject:[NSString stringWithFormat:@"Betting started - %d to call", chips]];
    
    int callAmount = chips;
    int currentPlayerIndex = idx % playersInHand.count;
    int decisions = playersInHand.count;
    PokerPlayer *player;
    
    while (decisions > 0) {
        player = [playersInHand objectAtIndex:currentPlayerIndex];
        int bet = player.folded ? 0 : [player betForTable:self.table andCallAmount:callAmount];
        if (player.folded) {
            decisions--;
        }
        else if (bet < callAmount && !player.allIn) {
            // Fold
            [self.handLog addObject:[NSString stringWithFormat:@"%@ folded", player.name]];
            decisions--;
            player.folded = YES;
        }
        else if (bet == callAmount) {
            // Call/Check
            [self.handLog addObject:[NSString stringWithFormat:@"%@ called %d", player.name, callAmount]];
            decisions--;
        }
        else if (bet > callAmount) {
            // Raise
           [self.handLog addObject:[NSString stringWithFormat:@"%@ raised to %d", player.name, bet]];
            decisions = playersInHand.count-1;
            callAmount = bet;
        }
        else {
            // Player is all in
            [self.handLog addObject:[NSString stringWithFormat:@"%@ is all in", player.name]];
            decisions--;
        }
        currentPlayerIndex = (currentPlayerIndex+1) % playersInHand.count;
    }
    
    // Add chips to the pot
    [self addCurrentBetsToPot];
    
    // Remove folded players from the hand
    [self removeFoldedPlayers];
}

- (void)prepareNewHand {
    // reset hand log
    [self.handLog removeAllObjects];
    
    // prune players
    [self updatePlayers];
    
    // reset deck
    [self resetDeck];
    
    // reset table
    [self.table reset];
    
    // only players with chips are in the hand
    playersInHand = [NSMutableArray arrayWithArray:self.table.players];
    
    // Shuffle deck
    [self.deck shuffle];
    [self.deck shuffle];
}

#pragma mark - Testing Methods for Full Hand or Game

- (void)playHand {
    // Assume that the table state is clean
    // Assume that the button has been moved
    [self prepareNewHand];
    
    // Do nothing if game is stopped
    if (stopped)
        return;
    
    // Post the blinds
    [self postBlinds];
    
    // Deal the hole cards
    [self dealHoleCards];
    // Get the flop bets
    [self collectBetsStartingAtIndex:2 withCallAmount:self.table.bigBlind];
    
    if (playersInHand.count > 1) {
        // Deal the flop
        [self dealFlop];
        // get the turn bets
        [self collectBetsStartingAtIndex:0 withCallAmount:0];
    }
    
    if (playersInHand.count > 1) {
        // Deal the turn
        [self dealTurn];
        // get the river bets
        [self collectBetsStartingAtIndex:0 withCallAmount:0];
    } 
    
    if (playersInHand.count > 1) {
        // Deal the river
        [self dealRiver];
        // get the final bets
        [self collectBetsStartingAtIndex:0 withCallAmount:0];
    }
    // Get hands
    if (playersInHand.count > 1) {
        [self getHands];
    }
    
    // distribute pot
    [self distributePot];
}

- (void)playGame {
    while (self.table.players.count > 1) {
        [self playHand];
    }
}

@end
