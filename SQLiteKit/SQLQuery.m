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
@synthesize arguments = _arguments;

#pragma mark -
#pragma mark Lifecycle

+ (id)queryWithStatement:(NSString *)SQLStatement
{
    return [[[self alloc] initWithStatement:SQLStatement arguments:nil orArgumentsList:NULL] autorelease];
}

+ (id)queryWithStatementAndArguments:(NSString *)SQLStatement, ...
{
    va_list argumentsList;
    SQLQuery *query;

    va_start(argumentsList, SQLStatement);
    query = [[[self alloc] initWithStatement:SQLStatement arguments:nil orArgumentsList:argumentsList] autorelease];
    va_end(argumentsList);
    return query;
}

+ (id)queryWithStatement:(NSString *)SQLStatement arguments:(NSArray *)arguments
{
    return [[[self alloc] initWithStatement:SQLStatement arguments:arguments orArgumentsList:NULL] autorelease];
}

- (id)initWithStatement:(NSString *)SQLStatement
{
    return [self initWithStatement:SQLStatement arguments:nil orArgumentsList:NULL];
}

- (id)initWithStatementAndArguments:(NSString *)SQLStatement, ...
{
    va_list argumentsList;

    va_start(argumentsList, SQLStatement);
    self = [self initWithStatement:SQLStatement arguments:nil orArgumentsList:argumentsList];
    va_end(argumentsList);
    return self;
}

- (id)initWithStatement:(NSString *)SQLStatement arguments:(NSArray *)arguments
{
    return [self initWithStatement:SQLStatement arguments:arguments orArgumentsList:NULL];
}

- (id)initWithStatement:(NSString *)SQLStatement arguments:(NSArray *)arguments orArgumentsList:(va_list)argumentsList
{
    NSParameterAssert(SQLStatement);

    self = [super init];
    if ( self != nil )
    {
        _SQLStatement = [SQLStatement retain];
        if ( arguments != nil )
        {
            _arguments = [arguments retain];
        }
        else if ( argumentsList != NULL )
        {
            id argument = va_arg(argumentsList, id);

            if ( argument != nil )
            {
                _arguments = [[NSMutableArray alloc] init];
                while ( argument != nil )
                {
                    [(NSMutableArray *)_arguments addObject:argument];
                    argument = va_arg(argumentsList, id);
                }
            }
        }
    }
    return self;
}

- (void)dealloc
{
    [_SQLStatement release];
    [_arguments release];
    [super dealloc];
}

#pragma mark -
#pragma mark NSObject

- (NSString *)description
{
    if ( self.arguments == nil )
    {
        return self.SQLStatement;
    }
    return [NSString stringWithFormat:@"%@ [ %@ ]", self.SQLStatement, [self.arguments componentsJoinedByString:@", "]];
}

@end
