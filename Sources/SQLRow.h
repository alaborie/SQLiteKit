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

/**
 @return Returns the object located at the column that match the specified name. If name does not match to a column, returns nil.
 */
- (id)objectForColumn:(NSString *)name;

/**
 @warning If index is greater than the number of columns, an NSRangeException is raised.
 */
- (id)objectForColumnAtIndex:(NSUInteger)index;

- (NSArray *)objects;
- (NSDictionary *)objectsDict;

#pragma mark -

/**
 @warning If name does not match to a column, an NSInvalidArgumentException is raised.
 */
- (int)intForColumn:(NSString *)name;

/**
 @warning If index is greater than the number of columns, an NSRangeException is raised.
 */
- (int)intForColumnAtIndex:(NSUInteger)index;

/**
 @warning If name does not match to a column, an NSInvalidArgumentException is raised.
 */
- (long long)longlongForColumn:(NSString *)name;

/**
 @warning If index is greater than the number of columns, an NSRangeException is raised.
 */
- (long long)longlongForColumnAtIndex:(NSUInteger)index;

/**
 @warning If name does not match to a column, an NSInvalidArgumentException is raised.
 */
- (double)doubleForColumn:(NSString *)name;

/**
 @warning If index is greater than the number of columns, an NSRangeException is raised.
 */
- (double)doubleForColumnAtIndex:(NSUInteger)index;

/**
 @warning If name does not match to a column, an NSInvalidArgumentException is raised.
 */
- (const char *)textForColumn:(NSString *)name;

/**
 @warning If index is greater than the number of columns, an NSRangeException is raised.
 */
- (const char *)textForColumnAtIndex:(NSUInteger)index;

#pragma mark -

/**
 @warning If name does not match to a column, an NSInvalidArgumentException is raised.
 */
- (int)blobLengthForColumn:(NSString *)name;

/**
 @warning If index is greater than the number of columns, an NSRangeException is raised.
 */
- (int)blobLengthForColumnAtIndex:(NSUInteger)index;

/**
 @warning If name does not match to a column, an NSInvalidArgumentException is raised.
 */
- (void *)blobForColumn:(NSString *)name buffer:(void *)buffer length:(int *)length;

/**
 @warning If index is greater than the number of columns, an NSRangeException is raised.
 */
- (void *)blobForColumnAtIndex:(NSUInteger)index buffer:(void *)buffer length:(int *)length;

@end
