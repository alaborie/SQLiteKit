/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

@class SQLDatabase;
@class SQLPreparedStatement;

/**
 @brief An object that represents a row in an SQL table.
 */
@interface SQLRow : NSObject
{
@private
    SQLDatabase *_database;
    SQLPreparedStatement *_statement;

@private
    dispatch_once_t _columnCountPredicate;
    NSUInteger _columnCount;
    dispatch_once_t _columnNameDictPredicate;
    NSDictionary *_columnNameDict;
}

/**
 A database that is associated with the receiver.
 */
@property (nonatomic, readonly) SQLDatabase *database;

/**
 A prepared-statement that is associated with the receiver.
 */
@property (nonatomic, readonly) SQLPreparedStatement *statement;

/**
 An integer that indicates the number of columns in the row.
 */
@property (nonatomic, readonly) NSUInteger columnCount;

/**
 A dictionary that contains the name of the columns and their associated index within the row.

 @note The key is the name of the column, the value is a number that represents the index.
 */
@property (nonatomic, readonly) NSDictionary *columnNameDict;

#pragma mark -
/// @name Creation & Initialization

/**
 Creates a new row associated to the specified database and prepared-statement.

 @param database A database object. Must not be nil!
 @param statement A prepared-statement object. Must not be nil!
 @return A new row or nil if an error occurs during its allocation or initialization.
 */
+ (id)rowWithDatabase:(SQLDatabase *)database statement:(SQLPreparedStatement *)statement __attribute__ ((nonnull(1, 2)));

/**
 Initializes a row associated to the specified database and prepared-statement.

 @param database A database object. Must not be nil!
 @param statement A prepared-statement object. Must not be nil!
 @return An initialized row or nil if an error occured.
 */
- (id)initWithDatabase:(SQLDatabase *)database statement:(SQLPreparedStatement *)statement __attribute__ ((nonnull(1, 2)));

#pragma mark -
/// @name Getting objects

/**
 Returns an object for the column that matches the specified name.

 @return Returns an object if the specified name matches a column or nil otherwise.
 @warning Please make sure to understand the difference between nil and NSNull! If nil is returned, there is no column with the given name. If NSNull is returned, the column exists but the value in the database is NULL.
 */
- (id)objectForColumn:(NSString *)name;

/**
 Returns the object for the column located at the specified index.

 @return Returns the object for the column located at the specified index. If SQLite cannot determine the type of the column, nil will be returned.
 @warning If index is greater than the number of columns, an NSRangeException is raised!
 */
- (id)objectForColumnAtIndex:(NSUInteger)index;

/**
 Returns an array that contains all the objects of the row, starting from the leftmost column and going to the rightmost column.

 @return An array that contains all the objects of the row or nil if there is no column.
 @see objectsDict
 @see objectsDictWithoutNull
 */
- (NSArray *)objects;

/**
 Returns a dictionary that contains all the objects of the row. The key is the name of the column, the value is the value in the SQL database for this row.

 @return A dictionary that contains all the objects of the row or nil if there is no column.
 @see objects
 @see objectsDictWithoutNull
 */
- (NSDictionary *)objectsDict;

/**
 Returns a dictionary that contains all the non-NULL objects of the row. The key is the name of the column, the value is the value in the SQL database for this row.

 @return A dictionary that contains all the non-NULL objects of the row or nil if there is no column. If all the values in the row are equal to NULL, an empty dictionary is returned.
 @see objects
 @see objectsDict
 */
- (NSDictionary *)objectsDictWithoutNull;

#pragma mark -
/// @name Getting scalars

/**
 Returns an integer for the column that matches the specified name.

 @param name A string that contains the name of the column.
 @return An integer.
 @warning If name does not match to a column, an NSInvalidArgumentException is raised.
 @see intForColumnAtIndex:
 */
- (int)intForColumn:(NSString *)name;

/**
 Returns an integer for the column located at the specified index.

 @param index An integer that contains the index of the column
 @return An integer.
 @warning If index is greater than the number of columns, an NSRangeException is raised.
 @see intForColumn:
 */
- (int)intForColumnAtIndex:(NSUInteger)index;

/**
 Returns a long long for the column that matched the specifed name.

 @param name A string that contains the name of the column.
 @return A long long.
 @warning If name does not match to a column, an NSInvalidArgumentException is raised.
 @see longlongForColumnAtIndex:
 */
- (long long)longlongForColumn:(NSString *)name;

/**
 Returns an integer for the column located at the specified index.

 @param index An integer that contains the index of the column.
 @return A long long.
 @warning If index is greater than the number of columns, an NSRangeException is raised.
 @see longlongForColumn:
 */
- (long long)longlongForColumnAtIndex:(NSUInteger)index;

/**
 Returns a double for the column that matches the specified name.

 @param name A string that contains the name of the column.
 @return A double.
 @warning If name does not match to a column, an NSInvalidArgumentException is raised.
 @see doubleForColumnAtIndex:
 */
- (double)doubleForColumn:(NSString *)name;

/**
 Returns a double for the column located at the specified index.

 @param index An integer that contains the index of the column.
 @return A double.
 @warning If index is greater than the number of columns, an NSRangeException is raised.
 @see doubleForColumn:
 */
- (double)doubleForColumnAtIndex:(NSUInteger)index;

/**
 Returns a string for the column that matches the specified name.

 @param name A string that contains the name of the column.
 @return A string zero-terminated.
 @warning If name does not match to a column, an NSInvalidArgumentException is raised.
 @see textForColumnAtIndex:
 */
- (const char *)textForColumn:(NSString *)name;

/**
 Returns a string for the column located at the specified index.

 @param index An integer that contains the index of the column.
 @return A string zero-terminated.
 @warning If index is greater than the number of columns, an NSRangeException is raised.
 @see textForColumn:
 */
- (const char *)textForColumnAtIndex:(NSUInteger)index;

#pragma mark -
/// @name Getting blob

/**
 Returns an integer that specifies the length of the blob for the column that matches the specified name.

 @param name A string that contains the name of the column.
 @return An integer that specifies the length of a blob.
 @warning If name does not match to a column, an NSInvalidArgumentException is raised.
 */
- (int)blobLengthForColumn:(NSString *)name;

/**
 Returns an integer that specifies the length for the column located at the specified index.

 @param index An integer that contains the index of the column.
 @return An integer that specifies the length of a blob.
 @warning If index is greater than the number of columns, an NSRangeException is raised.
 */
- (int)blobLengthForColumnAtIndex:(NSUInteger)index;

/**
 Returns a pointer to a blob for the column that matches the specified name.

 @param name A string that contains the name of the column.
 @param buffer A buffer used to copy the blob. If NULL, the pointer will be automatically allocated. In this case, this is the responsibility of the caller to free this pointer.
 @param length An integer that contains the number of bytes copied. May be NULL.
 @return A pointer to a blob or NULL if there is nothing to copy or if an error occurs.
 @warning If name does not match to a column, an NSInvalidArgumentException is raised.
 */
- (void *)blobForColumn:(NSString *)name buffer:(void *)buffer length:(int *)length;

/**
 Returns a pointer to a blob for the column located at the specified index.

 @param index An integer that contains the index of the column.
 @param buffer A buffer used to copy the blob. If NULL, the pointer will be automatically allocated. In this case, this is the responsibility of the caller to free this pointer.
 @param length An integer that contains the number of bytes copied. May be NULL.
 @return A pointer to a blob or NULL if there is nothing to copy or if an error occurs.
 @warning If index is greater than the number of columns, an NSRangeException is raised.
 */
- (void *)blobForColumnAtIndex:(NSUInteger)index buffer:(void *)buffer length:(int *)length;

@end
