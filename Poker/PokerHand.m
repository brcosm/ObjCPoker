//
//  PokerHand.m
//  Poker
//
//  Created by Brandon Smith on 9/25/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "PokerHand.h"
#import "HandArrays.h"

/**
 Binary search for product idx
 */
int find_product(int key) {
    int low = 0, high = 4887, mid;
    
    while ( low <= high )
    {
        mid = (high+low) >> 1;      // divide by two
        if ( key < products[mid] )
            high = mid - 1;
        else if ( key > products[mid] )
            low = mid + 1;
        else
            return( mid );
    }
    return( -1 );
}

@interface PokerHand() {}
- (int)rankHand;
- (BOOL)sameSuit;
@end

@implementation PokerHand {
    int rank_;
}
@synthesize cards = cards_;

+ (id)bestHandFrom:(NSArray *)cards {
    PokerHand *best;
    PokerHand *curr;
    NSMutableArray *five;
    
    for (int i = 0; i < 21; i++) {
        five = [NSMutableArray arrayWithCapacity:5];
        for (int j = 0; j < 5; j++) {
            [five addObject:[cards objectAtIndex:permutations[i][j]]];
        }
        curr = [[PokerHand alloc] initWithCards:five];
        if (!best || best.rank > curr.rank)
            best = curr;
    }
    return best;
}

- (id)initWithCards:(NSArray *)cards {
    self = [super init];
    if (self) {
        self.cards = cards;
    }
    return self;
}

- (void)setCards:(NSArray *)cards {
    cards_ = cards;
    rank_ = 0;
}

- (NSString *)description {
    NSMutableString *hand = [NSMutableString string];
    for (Card *card in self.cards) {
        [hand appendFormat:@"%@ ", card];
    }
    return hand;
}

- (int)rank {
    if (rank_ == 0)
        rank_ = [self rankHand];
    return rank_;
}

- (NSString *)rankName {
    if (self.rank > 6185) return @"High Card";       // 1277 high card
    if (self.rank > 3325) return @"One Pair";        // 2860 one pair
    if (self.rank > 2467) return @"Two Pair";        //  858 two pair
    if (self.rank > 1609) return @"Three of a Kind";  //  858 three-kind
    if (self.rank > 1599) return @"Straight";        //   10 straights
    if (self.rank > 322)  return @"Flush";           // 1277 flushes
    if (self.rank > 166)  return @"Full House";      //  156 full house
    if (self.rank > 10)   return @"Four of a Kind";  //  156 four-kind
    return @"Straight Flush";                        //   10 straight-flushes
}

- (int)rankHand {
    // Bitwise or to get the rank index
    int idx = 0;
    for (Card *c in self.cards) {
        idx |= c.binaryRank;
    }
    // Determine if hand is suited
    if ([self sameSuit])
        return flushes[idx];
    // Determine if hand is unique
    int uniq = uniques[idx];
    if (uniq != 0)
        return uniq;
    // Multiply prime ranks for unique value without sorting
    idx = 1;
    for (Card *c in self.cards) {
        idx = idx * c.primeRank;
    }
    return others[find_product(idx)];
}

- (BOOL)sameSuit {
    signed int currentSuit = -1;
    int numSuits = 0;
    for (Card *card in self.cards) {
        if ((currentSuit == -1) || (card.suit != currentSuit)) {
            currentSuit = card.suit;
            numSuits++;
        }
        if (numSuits>1)
            return NO;
    }
    return YES;
}

@end
