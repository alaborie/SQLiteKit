//
//  SQLEnumerator.m
//  SQLiteKit
//
//  Created by Alexandre Laborie on 10/30/12.
//
//

#import "SQLEnumerator.h"
#import "SQLStatement+Private.h"

@interface SQLEnumerator ()

@property (nonatomic, retain, readwrite) SQLStatement *statement;

@property (nonatomic, assign, readwrite, getter = isDone) BOOL done;

- (void)_enumerateRowsUsingBlock:(void (^)(id object, BOOL *stop))block retrieveDataWithSelector:(SEL)selector;

@end

@implementation SQLEnumerator

#pragma mark -
#pragma mark Lifecycle

+ (id)enumeratorForStatement:(SQLStatement *)statement {
    return [[self alloc] initForStatement:statement];
}

- (id)init {
    return nil;
}

- (id)initForStatement:(SQLStatement *)statement {
    NSParameterAssert(statement);
    self = [super init];
    if (self != nil) {
        self.statement = statement;
        self.done = [statement step];
    }
    return self;
}

- (void)dealloc {
    self.statement = nil;
}

#pragma mark -
#pragma mark NSEnumeration

- (NSArray *)allObjects {
    NSMutableArray *allObjects = [NSMutableArray array];
    id object;

    while ((object = [self nextObject]) != nil ) {
        [allObjects addObject:object];
    }
    return [allObjects copy];
}

- (id)nextObject {
    if (self.isDone == YES) {
        return nil;
    }

    NSDictionary *row = [self.statement allObjectsAndColumns];

    self.done = [self.statement step];
    return row;
}

#pragma mark -
#pragma mark Public

- (void)enumerateRowsValuesUsingBlock:(void (^)(NSArray *values, BOOL *stop))block {
    [self _enumerateRowsUsingBlock:block retrieveDataWithSelector:@selector(allObjects)];
}

- (void)enumerateRowsValuesAndColumnsUsingBlock:(void (^)(NSDictionary *values, BOOL *stop))block {
    [self _enumerateRowsUsingBlock:block retrieveDataWithSelector:@selector(allObjectsAndColumns)];
}

- (void)enumerateRowsNonNullValuesAndColumnsUsingBlock:(void (^)(NSDictionary *nonNullValues, BOOL *stop))block {
    [self _enumerateRowsUsingBlock:block retrieveDataWithSelector:@selector(allNonNullObjectsAndColumns)];
}

#pragma mark -
#pragma mark Private

- (void)_enumerateRowsUsingBlock:(void (^)(id object, BOOL *stop))block retrieveDataWithSelector:(SEL)selector {
    if (block == NULL) {
        [NSException raise:NSInvalidArgumentException format:NSLocalizedString(@"SQLiteKit_BlockCannotBeNil", @"Exception raised when a NULL block is given to a method that requires a valid block.")];
    }

    BOOL stop = NO;

    while (self.isDone == NO) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        block([self.statement performSelector:selector], &stop);
#pragma clang diagnostic pop
        if (stop == NO) {
            self.done = [self.statement step];
            break;
        }
    }
}

@end
