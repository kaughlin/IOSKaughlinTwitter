//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (strong, nonatomic) NSMutableArray *tweetsArray;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timelineTableView.dataSource = self;
    self.timelineTableView.delegate = self;
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            
            self.tweetsArray = (NSMutableArray *) tweets;
            NSLog(@"Count %lu:", self.tweetsArray.count);
            for (Tweet *t in self.tweetsArray) {
                NSLog(@"Tweeeet in all tweets:   %@", t.text);
            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        //reload data after network call
        [self.timelineTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.tweetsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweetsArray[indexPath.row];
    
    //initialize cell information
    cell.tweetTextLabel.text = tweet.text;
    cell.screenNameLabel.text = [NSString stringWithFormat: @"@%@", tweet.user.screenName];
    cell.nameLabel.text = tweet.user.name;
    
    NSLog(@"tweet.user.profilePicURL is: %@", tweet.user.profilePicURL);
    [cell.profilePicImageView setImageWithURL:tweet.user.profilePicURL];
    cell.profilePicImageView.layer.cornerRadius = cell.profilePicImageView.frame.size.width / 2;
    cell.profilePicImageView.clipsToBounds = YES;
    cell.profilePicImageView.layer.masksToBounds = YES;
    
//    [cell setTweets:tweet];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
