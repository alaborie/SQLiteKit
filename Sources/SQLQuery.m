//
//  SQLQuery.m
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/25/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SQLQuery.h"

@implementation SQLQuery

@synthesize SQLStatement = _SQLStatement;

#pragma mark -
#pragma mark Lifecycle

+ (id)queryWithSQLStatement:(NSString *)statement, ...
{
    va_list arguments;
    SQLQuery *newSQLQuery;

    va_start(arguments, statement);
    newSQLQuery = [[[self alloc] initWithSQLStatement:statement arguments:arguments] autorelease];
    va_end(arguments);
    return newSQLQuery;
}

+ (id)queryWithSQLStatement:(NSString *)statement arguments:(va_list)arguments
{
    return [[[self alloc] initWithSQLStatement:statement arguments:arguments] autorelease];
}

- (id)initWithSQLStatement:(NSString *)statement, ...
{
    va_list arguments;

    va_start(arguments, statement);
    self = [self initWithSQLStatement:statement arguments:arguments];
    va_end(arguments);
    return self;
}

- (id)initWithSQLStatement:(NSString *)statement arguments:(va_list)arguments
{
    NSParameterAssert(statement);

    self = [super self];
    if ( self != nil )
    {
        _SQLStatement = [statement retain];
        va_copy(_arguments, arguments);
    }
    return self;
}

- (void)dealloc
{
    [_SQLStatement release];
    va_end(_arguments);
    [super dealloc];
}

#pragma mark -
#pragma mark Public

- (id)nextArgument
{
    return va_arg(_arguments, id);
}

@end
