//
//  SQLRow.h
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/25/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <sqlite3.h>

@class SQLDatabase;
@class SQLStatement;

@interface SQLRow : NSObject
{
@private
    SQLDatabase *_database;
    SQLStatement *_statement;

@private
    dispatch_once_t _columnCountPredicate;
    NSUInteger _columnCount;
    dispatch_once_t _columnNameDictPredicate;
    NSDictionary *_columnNameDict;
}

@property (nonatomic, readonly) SQLDatabase *database;
@property (nonatomic, readonly) SQLStatement *statement;

@property (nonatomic, readonly) NSUInteger columnCount;
@property (nonatomic, readonly) NSDictionary *columnNameDict;

+ (id)rowWithDatabase:(SQLDatabase *)database statement:(SQLStatement *)statement;

/**
 @param database Must not be nil!
 @param statement Must not be nil!
 */
- (id)initWithDatabase:(SQLDatabase *)database statement:(SQLStatement *)statement;

#pragma mark -

- (id)objectForColumn:(NSString *)name;
- (id)objectForColumnAtIndex:(NSUInteger)index;

- (NSArray *)objects;
- (NSDictionary *)objectsDict;

@end
