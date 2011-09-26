//
//  PokerPlayer.m
//  Poker
//
//  Created by Brandon Smith on 9/25/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "PokerPlayer.h"

@implementation PokerPlayer
@synthesize name = name_;
@synthesize currentBet, totalBet;
@synthesize chips = chips_, holeCards;
@synthesize folded, allIn;
@synthesize hand;

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.chips = 1000;
        self.currentBet = 0;
        self.totalBet = 0;
        self.holeCards = [NSMutableArray arrayWithCapacity:2];
        self.allIn = NO;
        self.folded = NO;
        self.hand = nil;
    }
    return self;
}

- (void)makeBet:(int)bet {
    int chipsNeeded = MAX(0, bet - self.currentBet);
    int actualBet = MIN(chipsNeeded, self.chips);
    currentBet = actualBet+self.currentBet;
    self.chips -= actualBet;
    self.allIn = (self.chips == 0);
}

- (int)betForTable:(PokerTable *)table andCallAmount:(int)amnt {
    int decision = arc4random()%3;
    if ((decision == 0) && (self.chips>(amnt-self.currentBet))) {
        [self makeBet:MAX(2*amnt, table.pot/10)];
        return self.currentBet;
    }
    if (decision == 1) {
        [self makeBet:amnt];
        return self.currentBet;
    }
    else {
        return self.currentBet;
    }
}

@end
