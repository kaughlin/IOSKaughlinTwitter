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
#import "ComposeViewController.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (strong, nonatomic) NSMutableArray *tweetsArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    //bind action to refresh control
    [self.refreshControl addTarget:self action:@selector(refreshTimeline) forControlEvents:UIControlEventValueChanged];
    // add refresh control to table view
    [self.timelineTableView insertSubview:self.refreshControl atIndex:0];
    
    self.timelineTableView.dataSource = self;
    self.timelineTableView.delegate = self;
    
    [self refreshTimeline];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTimeline {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweetsArray = (NSMutableArray *) tweets;
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@",error.localizedDescription);
        }
        //reload data after network call
        [self.timelineTableView reloadData];
        [self.refreshControl endRefreshing];
    }];
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
    
    //make profile image circular
    cell.profilePicImageView.layer.cornerRadius = cell.profilePicImageView.frame.size.width / 2;
    cell.profilePicImageView.clipsToBounds = YES;
    cell.profilePicImageView.layer.masksToBounds = YES;
    
//    [cell setTweets:tweet];
    return cell;
}

- (void)didTweet:(Tweet *)tweet {
    [self.tweetsArray addObject:tweet];
    [self.timelineTableView reloadData];
    [self refreshTimeline];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
}


@end
