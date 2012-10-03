/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

/**
 @brief An object that represents a SQL query.
 */
@interface SQLQuery : NSObject
{
@private
    NSString *_SQLStatement;
    NSArray *_arguments;
}

/**
 A string that contains the SQL statement of the query.
 */
@property (nonatomic, readonly) NSString *SQLStatement;

/**
 An array that contains all the arguments required by the query.
 */
@property (nonatomic, retain, readwrite) NSArray *arguments;

#pragma mark -
/// @name Creation & Initialization

/**
 Creates a new query with the specified SQL statement.

 @param SQLStatement A string that contains the SQL statement associated to the query. Must not be nil!
 @return A new query or nil if an error occurs during its allocation or initialization.
 */
+ (id)queryWithStatement:(NSString *)SQLStatement __attribute__ ((nonnull(1)));

/**
 Creates a new query with the specified SQL statement and its arguments.

 @param SQLStatement A string that contains the SQL statement associated to the query. This string must be followed by all the arguments required by the query. The list must be nil terminated.
 @return A new query or nil if an error occurs during its allocation or initialization.
 */
+ (id)queryWithStatementAndArguments:(NSString *)SQLStatement, ... __attribute__((sentinel));

/**
 Creates a new query with the specified SQL statement and its arguments.

 @param SQLStatement A string that contains the SQL statement associated to the query. Must not be nil!
 @param arguments An array that contains all the arguments required by the query. May be nil.
 @return A new query or nil if an error occurs during its allocation or initialization.
 */
+ (id)queryWithStatement:(NSString *)SQLStatement arguments:(NSArray *)arguments __attribute__ ((nonnull(1)));

/**
 Initializes a query with the specified SQL statement.

 @param SQLStatement A string that contains the SQL statement associated to the query. Must not be nil!
 @return An initialized query or nil if an error occured.
 */
- (id)initWithStatement:(NSString *)SQLStatement __attribute__ ((nonnull(1)));

/**
 Initializes a query with the specified SQL statement and its arguments.

 @param SQLStatement A string that contains the SQL statement associated to the query. This string must be followed by all the arguments required by the query. The list must be nil terminated.
 @return An initialized query or nil if an error occured.
 */
- (id)initWithStatementAndArguments:(NSString *)SQLStatement, ... __attribute__((sentinel));

/**
 Initializes a query with the specified SQL statement and its arguments.

 @param SQLStatement A string that contains the SQL statement associated to the query. Must not be nil!
 @param arguments An array that contains all the arguments required by the query. May be nil.
 @return An initialized query or nil if an error occured.
 */
- (id)initWithStatement:(NSString *)SQLStatement arguments:(NSArray *)arguments __attribute__ ((nonnull(1)));

/**
 Initializes a query with the specified SQL statement and its arguments.

 @param SQLStatement A string that contains the SQL statement associated to the query. Must not be nil!
 @param arguments An array that may contains all the arguments required by the query. May be nil.
 @param argumentsList An argument lists required by the query. May be NULL. If not NULL, must have been previously initialized by va_start()!
 @return An initialized query or nil if an error occured.
 @note Designated initializer.
 */
- (id)initWithStatement:(NSString *)SQLStatement arguments:(NSArray *)arguments orArgumentsList:(va_list)argumentsList __attribute__ ((nonnull(1)));

#pragma mark -
/// @name Transaction Queries

/**
 Returns a query that begins a transaction.

 @return A query that begins a transaction.
 */
+ (id)beginTransaction;

/**
 Returns a query that commits a transaction.

 @return A query that commits a transaction.
 */
+ (id)commitTransaction;

/**
 Returns a query that rollback a transaction.

 @return A query that rollback a transaction.
 */
+ (id)rollbackTransaction;

@end
