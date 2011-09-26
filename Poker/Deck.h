//
//  Deck.h
//  Poker
//
//  Created by Brandon Smith on 9/25/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "Card.h"

@interface Deck : NSObject

@property (nonatomic, strong) NSMutableArray *cards;

- (id)initWithCards:(NSArray *)cards;

- (void)shuffle;

- (Card *)draw;

@end
