//
//  PokerGame.h
//  Poker
//
//  Created by Brandon Smith on 9/25/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "PokerTable.h"
#import "PokerPlayer.h"
#import "PokerHand.h"
#import "Deck.h"

@interface PokerGame : NSObject

@property (nonatomic, strong) PokerTable *table;
@property (nonatomic, strong) Deck *deck;

- (id)initWithTable:(PokerTable *)table andDeck:(Deck *)deck;

- (void)postBlinds;

- (void)dealHoleCards;

- (void)collectBetsStartingAtIndex:(int)idx withCallAmount:(int)amnt;

- (void)playHand;


@end
