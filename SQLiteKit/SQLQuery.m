/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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

#pragma mark -
#pragma mark Public

+ (id)beginTransaction
{
    static SQLQuery *beginTransaction;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{
        beginTransaction = [[SQLQuery alloc] initWithStatement:@"BEGIN TRANSACTION;"];
    });
    return beginTransaction;
}

+ (id)commitTransaction
{
    static SQLQuery *commitTransaction;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{
        commitTransaction = [[SQLQuery alloc] initWithStatement:@"COMMIT TRANSACTION;"];
    });
    return commitTransaction;
}

+ (id)rollbackTransaction
{
    static SQLQuery *rollbackTransaction;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{
        rollbackTransaction = [[SQLQuery alloc] initWithStatement:@"ROLLBACK TRANSACTION;"];
    });
    return rollbackTransaction;
}

@end
