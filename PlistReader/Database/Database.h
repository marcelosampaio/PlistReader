//
//  Database.h
//  Desafio2
//
//  Created by Marcelo Sampaio on 7/8/15.
//  Copyright (c) 2015 Marcelo Sampaio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"


@interface Database : NSObject
{
    sqlite3 *db;
}


#pragma mark - Database Methods
-(void) copyDatabaseToWritableFolder;


#pragma mark - Data Manipulation
-(void)addEndpointWithGroupName:(NSString *)groupName groupItem:(NSString *)groupItem version:(NSString *)version endpoint:(NSString *)endpoint;
-(NSMutableArray *)getPlist;
-(void)deletePlist;

@end
