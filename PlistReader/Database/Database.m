//
//  Database.m
//  Desafio2
//
//  Created by Marcelo Sampaio on 7/8/15.
//  Copyright (c) 2015 Marcelo Sampaio. All rights reserved.
//

#import "Database.h"
#import "DatabaseRow.h"

#define DATABASE_IDENTIFIER         @"PlistReader.db"


@interface Database()

@property (nonatomic,strong) Database *database;

@end


@implementation Database

@synthesize database=_database;


#pragma mark - Lazy Instantiation
- (Database *) database
{
    if(!_database)
    {
        _database = [[Database alloc] init];
    }
    return _database;
}

#pragma mark - Database Methods
-(NSString *) dbPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSLog(@"📀 database path: %@ ",[[paths objectAtIndex:0] stringByAppendingPathComponent:DATABASE_IDENTIFIER]);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:DATABASE_IDENTIFIER];
}

-(void) openDB
{
    if (sqlite3_open([[self.database dbPath] UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0,@"Open database failure!");
        return;
    }
}

-(void) closeDB
{
    sqlite3_close(db);
}

-(void) copyDatabaseToWritableFolder
{

    // check if database exists
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DATABASE_IDENTIFIER];
    
    NSLog(@"📀 writable databasePath: %@", writableDBPath);
    
    
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
    {
        return;
    }
    
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_IDENTIFIER];
    
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    
}

#pragma mark - Data Manipulation
-(void)addEndpointWithGroupName:(NSString *)groupName groupItem:(NSString *)groupItem version:(NSString *)version endpoint:(NSString *)endpoint {
    // open database
    [self openDB];
    
    // add user
    NSString *sql=[NSString stringWithFormat:@"insert into plist (groupName,groupItem,version,endpoint) values ('%@','%@','%@','%@')",groupName,groupItem,version,endpoint];
    
    // about to connect and execute sql command
    char *err;
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSAssert(0, @"Insert plist table - database error");
    }
    
    
    
    // close database
    [self closeDB];

}

-(NSMutableArray *)getPlist{
    
    // open database
    [self openDB];
    
    
    NSMutableArray *result=[[NSMutableArray alloc]init];
    
    NSString *sql=@"select groupName, groupItem, version, endpoint from plist order by 'group', groupItem, version, endpoint";
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW)
        {
            
            // Field #1 - groupName
            char *field1 = (char *) sqlite3_column_text(statement, 0);
            NSString *groupName = [[NSString alloc] initWithUTF8String:field1];
            
            // Field #2 - groupItem
            char *field2 = (char *) sqlite3_column_text(statement, 1);
            NSString *groupItem = [[NSString alloc] initWithUTF8String:field2];
            
            // Field #3 - version
            char *field3 = (char *) sqlite3_column_text(statement, 2);
            NSString *version = [[NSString alloc] initWithUTF8String:field3];
            
            // Field #4 - endpoint
            char *field4 = (char *) sqlite3_column_text(statement, 3);
            NSString *endpoint = [[NSString alloc] initWithUTF8String:field4];
            
            
            // compose the result
            DatabaseRow *row=[[DatabaseRow alloc] initWithGroupName:groupName groupItem:groupItem version:version endpoint:endpoint];
            [result addObject:row];

            
        }
    }
    else
    {
        //
        // SQLITE Error
        //
    }
    
    // close database
    [self closeDB];

    
    return result;
    
}

-(void)deletePlist{
    NSString *sql=[NSString stringWithFormat:@"delete from plist"];
    
    // open database
    [self openDB];
    
    
    // about to connect and execute sql command
    char *err;
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSAssert(0, @"delete plist - database error");
    }

    // close database
    [self closeDB];
}



@end
