//
//  ViewController.m
//  PlistReader
//
//  Created by Cast on 6/12/17.
//  Copyright © 2017 MAS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSMutableArray *apis;
    NSDate *expirationDateCardNSDate;
}

@end

@implementation ViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Database Initial Procedures
    [self databaseInitialProcedures];
    
    // get plist info into memory
    [self plistReader];
    
    // add plist info to database
    [self addPlistInfoToDatabase];

    
}

#pragma mark - Plist Reader
-(void)plistReader{

    self.plistInfo = [[NSMutableArray alloc]init];
    
    
    NSDictionary *contents = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"]];
    NSDictionary *endpoints = [contents objectForKey:@"endpoints"];

    NSString *rowGroupName = @"";
    NSString *rowGroupItem = @"";
    NSString *rowVersion = @"";
    NSString *rowEndpoint = @"";
    
    
    
    for (NSString *groupKey in endpoints) {
        NSLog(@"📍 groupKey: %@",groupKey);
        rowGroupName = groupKey;
        
        NSDictionary *groupItems = [endpoints objectForKey:groupKey];
        for (NSString *groupItem in groupItems) {
            NSLog(@"    📌 groupItem: %@",groupItem);
            rowGroupItem = groupItem;
            
            NSDictionary *items = [groupItems objectForKey:groupItem];
            for (NSString *item in items) {
                NSLog(@"        👉 %@ : %@",item,[items objectForKey:item]);
                if ([item isEqualToString:@"version"]) {
                    rowVersion = [items objectForKey:item];
                }else{
                    rowEndpoint = [items objectForKey:item];
                }
            }
            // release database row
            DatabaseRow *row = [[DatabaseRow alloc]initWithGroupName:rowGroupName groupItem:rowGroupItem version:rowVersion endpoint:rowEndpoint];
            
            [self.plistInfo addObject:row];
            
        }

    }
    

}

-(void)addPlistInfoToDatabase{
    
    // reset database
    [self.database deletePlist];
    
    for (DatabaseRow *row in self.plistInfo) {
        // add values to database
        [self.database addEndpointWithGroupName:row.groupName groupItem:row.groupItem version:row.version endpoint:row.endpoint];
    }
    
    NSLog(@"✏️ database updated");
}


#pragma mark - Database Helper
-(void)databaseInitialProcedures{
    self.database=[[Database alloc]init];
    
    // copy database from resource folder to documents folder
    [self.database copyDatabaseToWritableFolder];
}





@end
