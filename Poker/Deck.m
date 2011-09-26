//
//  Deck.m
//  Poker
//
//  Created by Brandon Smith on 9/25/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "Deck.h"

@implementation Deck
@synthesize cards = cards_;

- (id)initWithCards:(NSArray *)cards {
    self = [super init];
    if (self) {
        cards_ = [cards mutableCopy];
    }
    return self;
}

- (void)shuffle {
    // Knuth shuffle
    for (int i = 0; i < cards_.count; i++) {
        int swap_index = arc4random()%cards_.count;
        Card *tmp = [cards_ objectAtIndex:i];
        [cards_ replaceObjectAtIndex:i withObject:[cards_ objectAtIndex:swap_index]];
        [cards_ replaceObjectAtIndex:swap_index withObject:tmp];
    }
}

- (Card *)draw {
    if (cards_.count < 1)
        return nil;
    Card *card = [cards_ objectAtIndex:0];
    [cards_ removeObjectAtIndex:0];
    return card;
}

@end
