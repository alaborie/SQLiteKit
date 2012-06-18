/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

@interface SQLQuery : NSObject
{
@private
    NSString *_SQLStatement;
    NSArray *_arguments;
}

@property (nonatomic, readonly) NSString *SQLStatement;
@property (nonatomic, retain, readwrite) NSArray *arguments;

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

#pragma mark -
/// @name Explain

/**
 Returns a new query that is prefixed by the EXPLAIN keyword.

 @return A new query that should be used for troubleshooting only.
 @see http://www.sqlite.org/lang_explain.html
 */
- (id)explainQuery;

/**
 Returns a new query that is prefixed by the EXPLAIN QUERY PLAN keyword.

 @return A new query that should be used for troubleshooting only.
 @see http://www.sqlite.org/lang_explain.html
 */
- (id)explainQueryPlan;

@end
