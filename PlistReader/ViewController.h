//
//  ViewController.h
//  PlistReader
//
//  Created by Cast on 6/12/17.
//  Copyright © 2017 MAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "DatabaseRow.h"

@interface ViewController : UIViewController


@property (nonatomic,strong) Database *database;

@property (nonatomic,strong) NSMutableArray<DatabaseRow *> *plistInfo;


@end

