//
//  DatabaseRow.m
//  PlistReader
//
//  Created by Cast on 6/16/17.
//  Copyright © 2017 MAS. All rights reserved.
//

#import "DatabaseRow.h"

@implementation DatabaseRow


- (instancetype)initWithGroupName:(NSString *)groupName groupItem:(NSString *)groupItem version:(NSString *)version endpoint:(NSString *)endpoint
{
    self = [super init];
    if (self) {
        _groupName = groupName;
        _groupItem = groupItem;
        _version = version;
        _endpoint = endpoint;
        
    }
    return self;
}

@end
