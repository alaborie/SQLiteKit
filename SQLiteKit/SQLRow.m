//
//  SQLRow.m
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/25/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SQLRow.h"
#import "SQLDatabase.h"
#import "SQLStatement.h"

@interface SQLRow ()

- (void)_raiseRangeExceptionIfInvalidIndex:(NSUInteger)index parent:(const char *)function;
- (NSNumber *)_raiseInvalidArgumentExceptionIfInvalidColumn:(NSString *)name parent:(const char *)function;

@end

@implementation SQLRow

@synthesize database = _database;
@synthesize statement = _statement;

@synthesize columnCount = _columnCount;
@synthesize columnNameDict = _columnNameDict;

- (NSUInteger)columnCount
{
    dispatch_once(&_columnCountPredicate, ^{
        _columnCount = (NSUInteger)sqlite3_column_count(self.statement.compiledStatement);
    });
    return _columnCount;
}

- (NSDictionary *)columnNameDict
{
    dispatch_once(&_columnNameDictPredicate, ^{
        _columnNameDict = [[NSMutableDictionary alloc] initWithCapacity:self.columnCount];
        for ( NSUInteger index = 0; index < self.columnCount; index++ )
        {
            NSString *key = [NSString stringWithUTF8String:sqlite3_column_name(self.statement.compiledStatement, index)];
            NSNumber *value = [NSNumber numberWithUnsignedInteger:index];

            [_columnNameDict setValue:value forKey:key];
        }
    });
    return _columnNameDict;
}

#pragma mark -
#pragma mark Lifecycle

+ (id)rowWithDatabase:(SQLDatabase *)database statement:(SQLStatement *)statement
{
    return [[[self alloc] initWithDatabase:database statement:statement] autorelease];
}

- (id)initWithDatabase:(SQLDatabase *)database statement:(SQLStatement *)statement
{
    NSParameterAssert(database);
    NSParameterAssert(statement);

    self = [super init];
    if ( self != nil )
    {
        _database = [database retain];
        _statement = [statement retain];
    }
    return self;
}

- (void)dealloc
{
    [_database release];
    [_statement release];
    [super dealloc];
}

#pragma mark -
#pragma mark NSObject

- (NSString *)description
{
    NSMutableString *description = [NSMutableString string];
    __block BOOL firstItem = YES;

    [self.columnNameDict enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        [description appendFormat:( ( firstItem == YES ) ? @"%@ = %@" : @", %@ = %@" ), key, [self objectForColumnAtIndex:[object unsignedIntegerValue]]];
        firstItem = NO;
    }];
    return description;
}

#pragma mark -
#pragma mark Public

- (id)objectForColumn:(NSString *)name
{
    NSNumber *columnIndex = [self.columnNameDict objectForKey:name];

    if ( columnIndex == nil )
    {
        return nil;
    }
    return [self objectForColumnAtIndex:[columnIndex unsignedIntegerValue]];
}

- (id)objectForColumnAtIndex:(NSUInteger)index
{
    [self _raiseRangeExceptionIfInvalidIndex:index parent:__FUNCTION__];
    switch ( sqlite3_column_type(self.statement.compiledStatement, index) )
    {
        case SQLITE_INTEGER:
        {
            return [NSNumber numberWithLongLong:sqlite3_column_int64(self.statement.compiledStatement, index)];
        }
        case SQLITE_FLOAT:
        {
            return [NSNumber numberWithDouble:sqlite3_column_double(self.statement.compiledStatement, index)];
        }
        case SQLITE_TEXT:
        {
            return [NSString stringWithUTF8String:(const char *)sqlite3_column_text(self.statement.compiledStatement, index)];
        }
        case SQLITE_BLOB:
        {
            int numberOfBytes = sqlite3_column_bytes(self.statement.compiledStatement, index);
            void *bytes = malloc(numberOfBytes);

            if (bytes == NULL)
            {
                sqlitekit_warning(@"Cannot allocate memory to hold the blob object.");
                return [NSNull null];
            }
            memcpy(bytes, sqlite3_column_blob(self.statement.compiledStatement, index), numberOfBytes);
            return [NSData dataWithBytesNoCopy:bytes length:numberOfBytes freeWhenDone:YES];
        }
        case SQLITE_NULL:
        {
            return [NSNull null];
        }
        default:
        {
            sqlitekit_warning(@"Cannot determine the type of the column at the index %i.", index);
        }
    }
    return [NSNull null];
}

- (NSArray *)objects
{
    if ( self.columnCount == 0 )
    {
        return nil;
    }

    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:self.columnCount];

    for ( NSUInteger index = 0; index < self.columnCount; index++ )
    {
        [objects addObject:[self objectForColumnAtIndex:index]];
    }
    return objects;
}

- (NSDictionary *)objectsDict
{
    if ( self.columnCount == 0 )
    {
        return nil;
    }

    NSMutableDictionary *objectsDict = [NSMutableDictionary dictionaryWithCapacity:self.columnCount];

    [self.columnNameDict enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        [objectsDict setObject:[self objectForColumnAtIndex:[object unsignedIntegerValue]] forKey:key];
    }];
    return objectsDict;
}

#pragma mark -

- (int)intForColumn:(NSString *)name
{
    NSNumber *columnIndex = [self _raiseInvalidArgumentExceptionIfInvalidColumn:name parent:__FUNCTION__];

    return [self intForColumnAtIndex:[columnIndex unsignedIntegerValue]];
}

- (int)intForColumnAtIndex:(NSUInteger)index
{
    [self _raiseRangeExceptionIfInvalidIndex:index parent:__FUNCTION__];
    return sqlite3_column_int(self.statement.compiledStatement, index);
}

- (long long)longlongForColumn:(NSString *)name
{
    NSNumber *columnIndex = [self _raiseInvalidArgumentExceptionIfInvalidColumn:name parent:__FUNCTION__];

    return [self longlongForColumnAtIndex:[columnIndex unsignedIntegerValue]];
}

- (long long)longlongForColumnAtIndex:(NSUInteger)index
{
    [self _raiseRangeExceptionIfInvalidIndex:index parent:__FUNCTION__];
    return sqlite3_column_int64(self.statement.compiledStatement, index);
}

- (double)doubleForColumn:(NSString *)name
{
    NSNumber *columnIndex = [self _raiseInvalidArgumentExceptionIfInvalidColumn:name parent:__FUNCTION__];

    return [self doubleForColumnAtIndex:[columnIndex unsignedIntegerValue]];
}

- (double)doubleForColumnAtIndex:(NSUInteger)index
{
    [self _raiseRangeExceptionIfInvalidIndex:index parent:__FUNCTION__];
    return sqlite3_column_double(self.statement.compiledStatement, index);
}

- (const char *)textForColumn:(NSString *)name
{
    NSNumber *columnIndex = [self _raiseInvalidArgumentExceptionIfInvalidColumn:name parent:__FUNCTION__];

    return [self textForColumnAtIndex:[columnIndex unsignedIntegerValue]];
}

- (const char *)textForColumnAtIndex:(NSUInteger)index
{
    [self _raiseRangeExceptionIfInvalidIndex:index parent:__FUNCTION__];
    return (const char *)sqlite3_column_text(self.statement.compiledStatement, index);
}

#pragma mark -

- (int)blobLengthForColumn:(NSString *)name
{
    NSNumber *columnIndex = [self _raiseInvalidArgumentExceptionIfInvalidColumn:name parent:__FUNCTION__];

    return [self blobLengthForColumnAtIndex:[columnIndex unsignedIntegerValue]];
}

- (int)blobLengthForColumnAtIndex:(NSUInteger)index
{
    [self _raiseRangeExceptionIfInvalidIndex:index parent:__FUNCTION__];
    return sqlite3_column_bytes(self.statement.compiledStatement, index);
}

- (void *)blobForColumn:(NSString *)name buffer:(void *)buffer length:(int *)length
{
    NSNumber *columnIndex = [self _raiseInvalidArgumentExceptionIfInvalidColumn:name parent:__FUNCTION__];

    return [self blobForColumnAtIndex:[columnIndex unsignedIntegerValue] buffer:buffer length:length];
}

- (void *)blobForColumnAtIndex:(NSUInteger)index buffer:(void *)buffer length:(int *)length
{
    [self _raiseRangeExceptionIfInvalidIndex:index parent:__FUNCTION__];

    int numberOfBytes = sqlite3_column_bytes(self.statement.compiledStatement, index);

    if ( length != NULL )
    {
        *length = numberOfBytes;
    }
    if ( numberOfBytes == 0 )
    {
        return NULL;
    }

    void *bytes = (( buffer == NULL ) ? malloc(numberOfBytes) : buffer);

    if (bytes == NULL)
    {
        sqlitekit_warning(@"Cannot allocate memory to hold the blob object.");
        if ( length != NULL )
        {
            *length = 0;
        }
        return NULL;
    }
    memcpy(bytes, sqlite3_column_blob(self.statement.compiledStatement, index), numberOfBytes);
    return bytes;
}

#pragma mark -
#pragma mark Private

- (void)_raiseRangeExceptionIfInvalidIndex:(NSUInteger)index parent:(const char *)function
{
    NSCParameterAssert(function);

    if ( index >= self.columnCount )
    {
        [NSException raise:NSRangeException format:@"*** %s: index %u beyond bounds [0 .. %u]", function, index, self.columnCount];
    }
}

- (NSNumber *)_raiseInvalidArgumentExceptionIfInvalidColumn:(NSString *)name parent:(const char *)function
{
    NSNumber *columnIndex = [self.columnNameDict objectForKey:name];

    if ( columnIndex == nil )
    {
        [NSException raise:NSInvalidArgumentException format:@"*** %s: the column %@ does not exists", __FUNCTION__, name];
    }
    return columnIndex;
}

@end