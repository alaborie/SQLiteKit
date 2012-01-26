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
    NSArray *_arguments;
}

@property (nonatomic, readonly) NSString *SQLStatement;
@property (nonatomic, readonly) NSArray *arguments;

/**
 @param SQLStatement Must not be nil!
 */
+ (id)queryWithStatement:(NSString *)SQLStatement __attribute__ ((nonnull(1)));

/**
 @param SQLStatement Must not be nil!
 @note The arguments list must be nil terminated.
 */
+ (id)queryWithStatementAndArguments:(NSString *)SQLStatement, ... __attribute__((sentinel));

/**
 @param SQLStatement Must not be nil!
 */
+ (id)queryWithStatement:(NSString *)SQLStatement arguments:(NSArray *)arguments __attribute__ ((nonnull(1)));

/**
 @param SQLStatement Must not be nil!
 */
- (id)initWithStatement:(NSString *)SQLStatement __attribute__ ((nonnull(1)));

/**
 @param SQLStatement Must not be nil!
 @note The arguments list must be nil terminated.
 */
- (id)initWithStatementAndArguments:(NSString *)SQLStatement, ... __attribute__((sentinel));

/**
 @param SQLStatement Must not be nil!
 */
- (id)initWithStatement:(NSString *)SQLStatement arguments:(NSArray *)arguments __attribute__ ((nonnull(1)));

/**
 @param SQLStatement Must not be nil!
 @param argumentsList If not NULL, must have been previously initialized by va_start().
 @note Designated initializer.
 */
- (id)initWithStatement:(NSString *)SQLStatement arguments:(NSArray *)arguments orArgumentsList:(va_list)argumentsList __attribute__ ((nonnull(1)));

@end
