/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SQLStatement.h"
#import "SQLiteKitInternal.h"

@interface SQLStatement ()

- (NSUInteger)_indexForName:(NSString *)name;
- (void)_raiseExceptionIfIndexOutOfRange:(NSUInteger)index;

@end

@implementation SQLStatement

#pragma mark -
#pragma mark Lifecycle

- (id)init {
    return nil;
}

- (void)dealloc {
    _handle = NULL;
}

#pragma mark -
#pragma mark Public

- (NSUInteger)numberOfColumns {
    if (_numberOfColumns == NSNotFound) {
        _numberOfColumns = (NSUInteger)__sqlite3_column_count(_statement);
    }
    return _numberOfColumns;
}

- (id)objectForColumnAtIndex:(NSUInteger)index {
    NSUInteger numberOfColumns = self.numberOfColumns;

    if (index >= numberOfColumns) {
        [NSException raise:NSRangeException format:NSLocalizedString(@"SQLiteKit_Range", @"Exception raised when an index is not part of a range"), 0, numberOfColumns, index];
    }
    switch (__sqlite3_column_type(_statement, index)) {
        case SQLITE_INTEGER: {
            return [NSNumber numberWithLongLong:__sqlite3_column_int64(_statement, index)];
        }
        case SQLITE_FLOAT: {
            return [NSNumber numberWithDouble:__sqlite3_column_double(_statement, index)];
        }
        case SQLITE_TEXT: {
            return [NSString stringWithCString:(const char *)__sqlite3_column_text(_statement, index) encoding:SQLiteKitStringEncoding];
        }
        case SQLITE_BLOB: {
            int numberOfBytes = __sqlite3_column_bytes(_statement, index);
            void *bytes = malloc(numberOfBytes);

            if (bytes == NULL)
            {
                SQLITEKIT_WARNING(@"Cannot allocate memory to hold the blob object (statement = %@, index = %u).", self, index);
                return [NSNull null];
            }
            memcpy(bytes, __sqlite3_column_blob(_statement, index), numberOfBytes);
            return [NSData dataWithBytesNoCopy:bytes length:numberOfBytes freeWhenDone:YES];
        }
        case SQLITE_NULL: {
            return [NSNull null];
        }
        default: {
            [NSException raise:SQLiteKitException format:NSLocalizedString(@"SQLiteKit_ColumnTypeUnknown", @"Exception raised when the type of column cannot be determined.")];
            return nil; // Returns nil to prevent compilation warning.
        }
    }
}

- (NSDictionary *)columnsName {
    if (_columnsName == nil) {
        NSUInteger numberOfColumns = self.numberOfColumns;
        NSMutableDictionary *mutableColumnsName = [NSMutableDictionary dictionaryWithCapacity:numberOfColumns];

        for (NSUInteger index = 0; index < numberOfColumns; index++) {
            NSString *name = [NSString stringWithCString:__sqlite3_column_name(_statement, (int)index) encoding:SQLiteKitStringEncoding];

            [mutableColumnsName setObject:[NSNumber numberWithUnsignedInteger:index] forKey:name];
        }
        _columnsName = [mutableColumnsName copy];
    }
    return _columnsName;
}

- (id)objectForColumn:(NSString *)name {
    NSNumber *index = [self.columnsName objectForKey:name];

    if (index != nil) {
        return [self objectForColumnAtIndex:index.unsignedIntegerValue];
    }
    return nil;
}

#pragma mark -

- (NSArray *)allObjects {
    NSUInteger numberOfColumns = self.numberOfColumns;
    NSMutableArray *allObjects = [NSMutableArray arrayWithCapacity:numberOfColumns];

    for (NSUInteger index = 0; index < numberOfColumns; index++) {
        [allObjects addObject:[self objectForColumnAtIndex:index]];
    }
    return [allObjects copy];
}

- (NSDictionary *)allObjectsAndColumns {
    NSUInteger numberOfColumns = self.numberOfColumns;
    NSMutableDictionary *allObjectsAndColumns = [NSMutableDictionary dictionaryWithCapacity:numberOfColumns];

    [self.columnsName enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSNumber *index, BOOL *stop) {
        NSAssert([name isKindOfClass:[NSString class]] == YES, @"Invalid kind of class.");
        NSAssert([index isKindOfClass:[NSString class]] == YES, @"Invalid kind of class.");
        [allObjectsAndColumns setObject:[self objectForColumnAtIndex:index.unsignedIntegerValue] forKey:name];
    }];
    return [allObjectsAndColumns copy];
}

- (NSDictionary *)allNonNullObjectsAndColumns {
    NSUInteger numberOfColumns = self.numberOfColumns;
    NSMutableDictionary *allObjectsAndColumns = [NSMutableDictionary dictionaryWithCapacity:numberOfColumns];

    [self.columnsName enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSNumber *index, BOOL *stop) {
        NSAssert([name isKindOfClass:[NSString class]] == YES, @"Invalid kind of class.");
        NSAssert([index isKindOfClass:[NSString class]] == YES, @"Invalid kind of class.");
        id object = [self objectForColumnAtIndex:index.unsignedIntegerValue];

        if ([object isEqual:[NSNull null]] == NO) {
            [allObjectsAndColumns setObject:[self objectForColumnAtIndex:index.unsignedIntegerValue] forKey:name];
        }
    }];
    return [allObjectsAndColumns copy];
}

#pragma mark -

- (int)intForColumnAtIndex:(NSUInteger)index {
    [self _raiseExceptionIfIndexOutOfRange:index];
    return __sqlite3_column_int(_statement, index);
}

- (int)intForColumn:(NSString *)name {
    return [self intForColumnAtIndex:[self _indexForName:name]];
}

- (long long)longlongForColumnAtIndex:(NSUInteger)index {
    [self _raiseExceptionIfIndexOutOfRange:index];
    return __sqlite3_column_int64(_statement, index);
}

- (long long)longlongForColumn:(NSString *)name {
    return [self longlongForColumnAtIndex:[self _indexForName:name]];
}

- (double)doubleForColumnAtIndex:(NSUInteger)index {
    [self _raiseExceptionIfIndexOutOfRange:index];
    return __sqlite3_column_double(_statement, index);
}

- (double)doubleForColumn:(NSString *)name {
    return [self doubleForColumnAtIndex:[self _indexForName:name]];
}

- (const char *)textForColumnAtIndex:(NSUInteger)index {
    [self _raiseExceptionIfIndexOutOfRange:index];
    return (const char *)__sqlite3_column_text(_statement, index);
}

- (const char *)textForColumn:(NSString *)name {
    return [self textForColumnAtIndex:[self _indexForName:name]];
}

- (int)blobLengthForColumnAtIndex:(NSUInteger)index {
    [self _raiseExceptionIfIndexOutOfRange:index];
    return __sqlite3_column_bytes(_statement, index);
}

- (int)blobLengthForColumn:(NSString *)name {
    return [self blobLengthForColumnAtIndex:[self _indexForName:name]];
}

- (void *)blobForColumnAtIndex:(NSUInteger)index buffer:(void *)buffer length:(int *)length {
    int numberOfBytes = [self blobLengthForColumnAtIndex:index];

    if (length != NULL) {
        *length = numberOfBytes;
    }
    if (numberOfBytes == 0) {
        return NULL;
    }

    void *bytes = (buffer == NULL ) ? malloc(numberOfBytes) : buffer;

    if (bytes == NULL) {
        SQLITEKIT_WARNING(@"Cannot allocate memory to hold the blob object (statement = %@, index = %u).", self, index);
        if ( length != NULL )
        {
            *length = 0;
        }
        return NULL;
    }
    memcpy(bytes, __sqlite3_column_blob(_statement, index), numberOfBytes);
    return bytes;
}

- (void *)blobForColumn:(NSString *)name buffer:(void *)buffer length:(int *)length {
    return [self blobForColumnAtIndex:[self _indexForName:name] buffer:buffer length:length];
}

#pragma mark -

- (NSUInteger)_indexForName:(NSString *)name {
    NSNumber *index = [self.columnsName objectForKey:name];

    if (index == nil) {
        [NSException raise:NSInvalidArgumentException format:NSLocalizedString(@"SQLiteKit_ColumnNameUnknown", @"Exception raised when the given column name is unknown.")];
    }
    return index.unsignedIntegerValue;
}

- (void)_raiseExceptionIfIndexOutOfRange:(NSUInteger)index {
    NSUInteger numberOfColumns = self.numberOfColumns;

    if (index >= numberOfColumns) {
        [NSException raise:NSRangeException format:NSLocalizedString(@"SQLiteKit_Range", @"Exception raised when an index is not part of a range"), 0, numberOfColumns, index];
    }
}

@end
