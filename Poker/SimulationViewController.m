//
//  SimulationViewController.m
//  Poker
//
//  Created by Brandon Smith on 10/2/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "SimulationViewController.h"
#import "HandLogViewController.h"
#import "PokerGame.h"

@implementation SimulationViewController {
    UITableViewCell *simulateHandCell;
    UITableViewCell *simulateGameCell;
    UITableViewCell *viewHandCell;
}
@synthesize game;

- (id)initWithPlayers:(NSMutableArray *)pokerPlayers {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"Game Simulation";
        
        // Generate each of the available cards
        NSMutableArray *cards = [NSMutableArray arrayWithCapacity:52];
        for (CardSuit suit = kCardSuitClubs; suit < kCardSuitCount; suit++) {
            for (CardRank rank = kCardRankTwo; rank < kCardRankCount; rank++) {
                Card *card = [[Card alloc] initWithSuit:suit andRank:rank];
                [cards addObject:card];
            }
        }
        // Create a deck with the cards
        Deck *deck = [[Deck alloc] initWithCards:cards];
        
        // Create a table
        PokerTable *table = [[PokerTable alloc] initWithPlayers:pokerPlayers];
        
        // Create the game
        self.game = [[PokerGame alloc] initWithTable:table andDeck:deck];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)loadView {
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    UITableView *tv = 
    [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) 
                                 style:UITableViewStyleGrouped];
    tv.dataSource = self;
    tv.delegate = self;
    self.view = tv;
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                  target:self 
                                                  action:@selector(goBack)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 3;
    if (section == 1)
        return self.game.table.players.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *PlayerCellIdentifier = @"PlayerCell";
    UITableViewCell *cell;
    if (indexPath.section == 1)
        cell = [tableView dequeueReusableCellWithIdentifier:PlayerCellIdentifier];
    if (cell == nil && indexPath.section == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlayerCellIdentifier];
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Simulate Hand";
            simulateHandCell = cell;
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"View Last hand";
            viewHandCell = cell;
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"Simulate Game";
            simulateGameCell = cell;
        }
    }
    
    if (indexPath.section == 1) {
        PokerPlayer *p = [self.game.table.players objectAtIndex:indexPath.row];
        NSMutableString *cellText = [NSMutableString stringWithString:p.name];
        [cellText appendFormat:@" | chips: %d", p.chips];
        cell.textLabel.text = cellText;
    }  
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Simulation Controls";
    }
    if (section == 1) {
        return @"Players in Game";
    }
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected a row");
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self simulateHand];
        }
        if (indexPath.row == 1) {
            [self viewLastHand];
        }
        if (indexPath.row == 2) {
            [self simulateGame];
        }
    }
}

#pragma mark - Simulation methods

- (void)simulateHand {
    [self.game playHand];
    [(UITableView *)self.view reloadData];
}

- (void)viewLastHand {
    HandLogViewController *hvc = [[HandLogViewController alloc] initWithHandLog:self.game.handLog];
    [self.navigationController pushViewController:hvc animated:YES];
}

- (void)simulateGame {
    //simulateHandCell.userInteractionEnabled = NO;
    //simulateGameCell.userInteractionEnabled = NO;
    dispatch_queue_t pokerQueue = dispatch_queue_create("Poker Queue",0);
    dispatch_queue_t currentQueue = dispatch_get_current_queue();
    dispatch_async(pokerQueue, ^{
        int hands = 0;
        while (!self.game.stopped) {
            [self.game playHand];
            hands++;
            if (hands % 10 == 0) {
                dispatch_async(currentQueue, ^{
                    [(UITableView *)self.view reloadData];
                });
            }
        }
        dispatch_async(currentQueue, ^{ 
            [(UITableView *)self.view reloadData];
            //simulateHandCell.userInteractionEnabled = YES;
            //simulateGameCell.userInteractionEnabled = YES;
        });
    });
}

- (void)goBack {
    self.game.stopped = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
