/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SQLStatement+Private.h"
#import "SQLiteKitInternal.h"

@implementation SQLStatement (Private)

#pragma mark -
#pragma mark Lifecycle

+ (id)statementWithSQL:(NSString *)sql database:(sqlite3 *)handle {
    return [[self alloc] initWithSQL:sql database:handle];
}

- (id)initWithSQL:(NSString *)sql database:(sqlite3 *)handle {
    NSParameterAssert(sql);
    NSParameterAssert(handle);
    self = [super init];
    if (self != nil) {
        _handle = handle;
        _numberOfColumns = NSNotFound;
        if (__sqlite3_prepare_v2(_handle, [sql cStringUsingEncoding:SQLiteKitStringEncoding], sql.length, &_statement, NULL) != SQLITE_OK) {
            [NSException raise:SQLiteKitException format:[NSString stringWithCString:__sqlite3_errmsg(_handle) encoding:SQLiteKitStringEncoding], nil];
        }
        NSAssert(_statement != NULL, @"The statement must be not nil at this point.");
    }
    return self;
}

#pragma mark -

- (void)bindObjects:(NSArray *)objects {
    static NSDictionary *bindDictionary = nil;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{
        bindDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [NSValue valueWithPointer:@selector(bindData:atIndex:)], NSStringFromClass([NSData class]),
                          [NSValue valueWithPointer:@selector(bindNumber:atIndex:)], NSStringFromClass([NSNumber class]),
                          [NSValue valueWithPointer:@selector(bindDate:atIndex:)], NSStringFromClass([NSDate class]),
                          [NSValue valueWithPointer:@selector(bindNull:atIndex:)], NSStringFromClass([NSNull class]),
                          nil];
    });

    NSUInteger numberOfParameters = __sqlite3_bind_parameter_count(_statement);

    if (numberOfParameters != objects.count) {
        [NSException raise:NSInvalidArgumentException format:NSLocalizedString(@"SQLiteKit_InvalidNumberOfParameters", @"Exception raised when the number of parameters provided is not equal to the number required by the statement."), objects.count, numberOfParameters];
    }
    [objects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        SEL bindSelector = [[bindDictionary objectForKey:NSStringFromClass([object class])] pointerValue];

        if (bindSelector != NULL) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:bindSelector withObject:object withObject:[NSNumber numberWithUnsignedInteger:index + 1]];
#pragma clang diagnostic pop
        }
        else {
            [self bindObject:object atIndex:[NSNumber numberWithUnsignedInteger:index + 1]];
        }
    }];
}

- (void)bindData:(NSData *)data atIndex:(NSNumber *)index {
    NSParameterAssert(data);
    if (__sqlite3_bind_blob(_statement, index.intValue, data.bytes, data.length, SQLITE_STATIC) != SQLITE_OK) {
        [NSException raise:SQLiteKitException format:[NSString stringWithCString:__sqlite3_errmsg(_handle) encoding:SQLiteKitStringEncoding], nil];
    }
}

- (void)bindNumber:(NSNumber *)number atIndex:(NSNumber *)index {
    NSParameterAssert(number);
    const char *type = [number objCType];
    NSAssert(type != nil && strlen(type) > 0, @"Cannot determine the type of the given number(%@).", number);

    // For more details about the type see http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html.
    switch (type[0]) {
        case 'B':   // C++ bool or a C99 _Bool
        case 'c':   // char
        case 'i':   // int
        case 's':   // short
        case 'l':   // long (l is treated as a 32-bit quantity on 64-bit programs.)
        case 'L':   // unsigned long
        case 'C':   // unsigned char
        case 'I':   // unsigned integer
        case 'S': { // unsigned short
            if (__sqlite3_bind_int(_statement, index.intValue, [number intValue]) != SQLITE_OK) {
                [NSException raise:SQLiteKitException format:[NSString stringWithCString:__sqlite3_errmsg(_handle) encoding:SQLiteKitStringEncoding], nil];
            }
            break;
        }
        case 'q':   // long long
        case 'Q': { // unsigned long long
            if (__sqlite3_bind_int64(_statement, index.intValue, [number longLongValue]) != SQLITE_OK) {
                [NSException raise:SQLiteKitException format:[NSString stringWithCString:__sqlite3_errmsg(_handle) encoding:SQLiteKitStringEncoding], nil];
            }
            break;
        }
        case 'f':   // float
        case 'd': { // double
            if (__sqlite3_bind_double(_statement, index.intValue, [number doubleValue]) != SQLITE_OK) {
                [NSException raise:SQLiteKitException format:[NSString stringWithCString:__sqlite3_errmsg(_handle) encoding:SQLiteKitStringEncoding], nil];
            }
            break;
        }
        default: {
            SQLITEKIT_WARNING(NSLocalizedString(@"SQLiteKit_UnknownNumberType", @"Warning displayed when the type of a number is unknown."));
            [self bindObject:number atIndex:index];
        }
    }
}

- (void)bindDate:(NSDate *)date atIndex:(NSNumber *)index {
    NSParameterAssert(date);
    if (__sqlite3_bind_double(_statement, index.intValue, date.timeIntervalSince1970) != SQLITE_OK) {
        [NSException raise:SQLiteKitException format:[NSString stringWithCString:__sqlite3_errmsg(_handle) encoding:SQLiteKitStringEncoding], nil];
    }
}

- (void)bindNull:(NSNull *)null atIndex:(NSNumber *)index {
    if (__sqlite3_bind_null(_statement, index.intValue) != SQLITE_OK) {
        [NSException raise:SQLiteKitException format:[NSString stringWithCString:__sqlite3_errmsg(_handle) encoding:SQLiteKitStringEncoding], nil];
    }
}

- (void)bindObject:(id)object atIndex:(NSNumber *)index {
    NSParameterAssert(object);
    NSString *description = [object description];

    if (__sqlite3_bind_text(_statement, index.intValue, [description cStringUsingEncoding:SQLiteKitStringEncoding], description.length, SQLITE_STATIC) != SQLITE_OK) {
        [NSException raise:SQLiteKitException format:[NSString stringWithCString:__sqlite3_errmsg(_handle) encoding:SQLiteKitStringEncoding], nil];
    }
}

- (void)clearBindings {
    if (__sqlite3_clear_bindings(_statement) != SQLITE_OK) {
        [NSException raise:SQLiteKitException format:[NSString stringWithCString:__sqlite3_errmsg(_handle) encoding:SQLiteKitStringEncoding], nil];
    }
}

#pragma mark -

- (void)reset {
    if (__sqlite3_reset(_statement) != SQLITE_OK) {
        [NSException raise:SQLiteKitException format:[NSString stringWithCString:__sqlite3_errmsg(_handle) encoding:SQLiteKitStringEncoding], nil];
    }
}

- (void)terminate {
    if (__sqlite3_finalize(_statement) != SQLITE_OK) {
        [NSException raise:SQLiteKitException format:[NSString stringWithCString:__sqlite3_errmsg(_handle) encoding:SQLiteKitStringEncoding], nil];
    }
}

#pragma mark -

- (BOOL)step {
    int result = __sqlite3_step(_statement);

    if (result == SQLITE_ROW) {
        return NO;
    }
    if (result == SQLITE_DONE) {
        return YES;
    }
    [NSException raise:SQLiteKitException format:NSLocalizedString(@"SQLiteKit_UnexpectedStepResult", @"Exeception raised when the result of a step operation is unpexted.")];
    return YES;
}

@end
