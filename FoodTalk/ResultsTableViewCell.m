//
//  ResultsTableViewCell.m
//  FoodTalk
//
//  Created by Eric Hong on 4/25/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

#import "ResultsTableViewCell.h"

@interface ResultsTableViewCell()

@end

@implementation ResultsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onFavoriteButtonPressed:(UIButton *)sender {
    
    [self.delegateCheckmark resultsTableViewCell:self didFavoriteButton:sender];
    
    UIImage *checkedBox = [UIImage imageNamed:@"Checkedbox-100"];
    UIImage *uncheckedBox = [UIImage imageNamed:@"Uncheckedbox-100"];
    
    if (sender.imageView.image == uncheckedBox) {
        //        Save this object Atousa
        sender.imageView.image = checkedBox;
    } else {
        //        Delete this object from core data Atousa
        sender.imageView.image = uncheckedBox;
    }
}



@end
