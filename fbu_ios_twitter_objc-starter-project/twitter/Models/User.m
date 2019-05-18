//
//  User.m
//  twitter
//
//  Created by Kaughlin Caver on 4/16/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        // Initialize properties
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        NSMutableString *profilePicString = [NSMutableString stringWithString:dictionary[@"profile_image_url"]];
        [profilePicString insertString:@"s" atIndex:4];
        self.profilePicURL = [NSURL URLWithString:profilePicString];
        self.backdropURL = [NSURL URLWithString:dictionary[@"profile_banner_url"]];
        
    }
    return self;
}

@end
