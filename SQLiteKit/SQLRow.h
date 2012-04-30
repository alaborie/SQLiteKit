/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

@class SQLDatabase;
@class SQLPreparedStatement;

@interface SQLRow : NSObject
{
@private
    SQLDatabase *_database;
    SQLPreparedStatement *_statement;

@private
    dispatch_once_t _columnCountPredicate;
    NSUInteger _columnCount;
    dispatch_once_t _columnNameDictPredicate;
    NSDictionary *_columnNameDict;
}

@property (nonatomic, readonly) SQLDatabase *database;
@property (nonatomic, readonly) SQLPreparedStatement *statement;

@property (nonatomic, readonly) NSUInteger columnCount;
@property (nonatomic, readonly) NSDictionary *columnNameDict;

+ (id)rowWithDatabase:(SQLDatabase *)database statement:(SQLPreparedStatement *)statement;

/**
 @param database Must not be nil!
 @param statement Must not be nil!
 */
- (id)initWithDatabase:(SQLDatabase *)database statement:(SQLPreparedStatement *)statement;

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
