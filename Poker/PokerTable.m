//
//  PokerTable.m
//  Poker
//
//  Created by Brandon Smith on 9/25/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "PokerTable.h"
#import "PokerPlayer.h"

@implementation PokerTable
@synthesize players = players_;
@synthesize smallBlind, bigBlind, buttonIndex;
@synthesize pot, communityCards, burnedCards;

- (id)initWithPlayers:(NSMutableArray *)players {
    self = [super init];
    if (self) {
        self.players = players;
        self.smallBlind = 10;
        self.bigBlind = 20;
        self.buttonIndex = 0;
        self.communityCards = [NSMutableArray arrayWithCapacity:5];
        self.burnedCards = [NSMutableArray arrayWithCapacity:3];
    }
    return self;
}

- (void)reset {
    self.buttonIndex = (self.buttonIndex+1)%self.players.count;
    [self.communityCards removeAllObjects];
    [self.burnedCards removeAllObjects];
}

- (NSString *)description {
    NSMutableString *pString = [NSMutableString string];
    for (PokerPlayer *p in self.players) {
        [pString appendFormat:@"(%@ | %d) ",p.name, p.chips];
    }
    return pString;
}

@end