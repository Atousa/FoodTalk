//
//  YlpClientViewController.m
//  FoodTalk
//
//  Created by Eric Hong on 4/20/16.
//  Copyright © 2016 EricDHong. All rights reserved.
//

#import "YlpClientViewController.h"



@interface YlpClientViewController ()

@end

@implementation YlpClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.consumerKey = @"LRm2QLqnKWviXdVCf6O-mA";
    self.consumerSecret = @"79_-HyVtKeKTjrl_MgsSaLoq5qA";
    self.token = @"QKQQYxDxrPp3lJFw9dIsOy_n_X-ifcsV";
    self.tokenSecret = @"ip0M1FBKwgRViXxZIChEjvNFwnw";
    
    YLPClient *client = [[YLPClient alloc]initWithConsumerKey:_consumerKey
                                               consumerSecret:_consumerSecret
                                                        token:_token
                                                  tokenSecret:_tokenSecret];
}





@end
