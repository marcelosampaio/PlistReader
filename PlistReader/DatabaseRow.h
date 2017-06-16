//
//  DatabaseRow.h
//  PlistReader
//
//  Created by Cast on 6/16/17.
//  Copyright © 2017 MAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseRow : NSObject

@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,strong) NSString *groupItem;
@property (nonatomic,strong) NSString *version;
@property (nonatomic,strong) NSString *endpoint;

- (instancetype)initWithGroupName:(NSString *)groupName groupItem:(NSString *)groupItem version:(NSString *)version endpoint:(NSString *)endpoint;

@end
