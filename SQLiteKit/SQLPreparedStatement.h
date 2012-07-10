/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

@class SQLDatabase;
@class SQLQuery;

/**
 @brief An object that represents a prepared-statement.
 @note This class must be used only inside the library!
 */
@interface SQLPreparedStatement : NSObject
{
@private
    SQLDatabase *_database;
    sqlite3_stmt *_compiledStatement;
}

/**
 A database that is associated with the receiver.
 */
@property (nonatomic, readonly) SQLDatabase *database;

/**
 An handle on the SQL prepared-statement provided by the C library.

 @warning This property should be used outside the class only if some functionalities provided by the C library are not implemented yet. This property might disappear in the future.
 */
@property (nonatomic, readonly) sqlite3_stmt *compiledStatement;

#pragma mark -
/// @name Creation & Initialization

/**
 Creates a new prepared-statement for the given database and query.

 @param database A database object.
 @param query A query object.
 @return A new prepared statement or nil if an error occurred during its allocation or initialization.
 */
+ (id)statementWithDatabase:(SQLDatabase *)database query:(SQLQuery *)query;

/**
 Initializes a prepared-statement for the given database and query.

 @param database A database object.
 @param query A query object.
 @return An initialized prepared statement or nil if an error occured.
 */
- (id)initWithDatabase:(SQLDatabase *)database query:(SQLQuery *)query;

#pragma mark -
/// @name Termination

/**
 Resets the prepared-statement in order to be reused.

 @return A boolean value that indicates whether the prepared-statement has been reseted or not.
 @note In order to be reused, a prepared-statement must be clear its bindings then be reseted.
 */
- (BOOL)reset;

/**
 Finalizes the prepared-statement and releases all the memory associated.

 @return A boolean value that indicates whether the prepared-statement has been finalized or not.
 @note This method is called automatically when the prepared-statement is released.
 @note This method should be called finalize but a method with the same name already exists in NSObject and has another purpose.
 */
- (BOOL)complete;

#pragma mark -

/**
 Clears the arguments bound to the prepared-statement.

 @return A boolean value that indicates whether the arguments bound have been removed or not.
 @note In order to be reused, a prepared-statement must be clear its bindings then be reseted.
 */
- (BOOL)clearBindings;

/**
 Binds the given arguments to the prepared-argument.

 @return A boolean value that indicates whether the arguments have been bound successfully or not.
 */
- (BOOL)bindArguments:(NSArray *)arguments;

@end
