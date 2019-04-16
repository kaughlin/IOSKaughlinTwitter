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
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        
        // Initialize any other properties
    }
    return self;
}

@end