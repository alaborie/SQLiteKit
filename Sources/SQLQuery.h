//
//  SQLQuery.h
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/25/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@interface SQLQuery : NSObject
{
@private
    NSString *_SQLStatement;
    va_list _arguments;
}

@property (nonatomic, readonly) NSString *SQLStatement;

+ (id)queryWithSQLStatement:(NSString *)statement, ...;
+ (id)queryWithSQLStatement:(NSString *)statement arguments:(va_list)arguments;

- (id)initWithSQLStatement:(NSString *)statement, ...;

/**
 @param statement Must not be nil!
 @param arguments Must have been previously initialized by va_start()!
 @note Designated initializer.
 */
- (id)initWithSQLStatement:(NSString *)statement arguments:(va_list)arguments;

#pragma mark -

- (id)nextArgument;

@end
