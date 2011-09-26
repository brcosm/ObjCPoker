//
//  PokerHand.h
//  Poker
//
//  Created by Brandon Smith on 9/25/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "Card.h"

@interface PokerHand : NSObject

@property (nonatomic, strong) NSArray *cards;
@property (nonatomic, readonly) int rank;
@property (nonatomic, readonly) NSString *rankName;

+ (id)bestHandFrom:(NSArray *)cards;

- (id)initWithCards:(NSArray *)cards;

@end
