//
//  AddPlayerViewController.m
//  Poker
//
//  Created by Brandon Smith on 10/2/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "EditPlayerViewController.h"
#import "PlayersViewController.h"

@implementation EditPlayerViewController {
    UITextField *nameField;
    UITextField *chipsField;
    BOOL newPlayer_;
}
@synthesize player;
@synthesize pvc;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Add Player";
        self.player = [[PokerPlayer alloc] initWithName:nil];
        newPlayer_ = YES;
    }
    return self;
}

- (id)initWithPlayer:(PokerPlayer *)pokerPlayer {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"Edit Player";
        self.player = pokerPlayer;
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
                                                  action:@selector(doneEditing)];
    self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                  target:self 
                                                  action:@selector(cancelEditing)];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect frame = cell.contentView.frame;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 20)];
    
    if (indexPath.section == 0) {
        textField.tag = 1;
        textField.placeholder = @"Name";
        textField.returnKeyType = UIReturnKeyNext;
        if (self.player.name)
            textField.text = self.player.name;
        nameField = textField;
    } else {
        textField.placeholder = @"Number of Chips";
        textField.tag = 2;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        chipsField = textField;
    }
    
    [cell.contentView addSubview:textField];
    
    return cell;
}

#pragma mark - Table view delegate


#pragma mark - Private methods

- (void)doneEditing {
    if (nameField.text)
        self.player.name = nameField.text;
    if (chipsField.text)
        self.player.chips = chipsField.text.intValue;
    if (newPlayer_)
        [self.pvc.players addObject:self.player];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelEditing {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
