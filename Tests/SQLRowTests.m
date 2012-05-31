/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SQLRowTests.h"

#import "SenTestCase+SQLiteKitAdditions.h"

@implementation SQLRowTests

#pragma mark -
#pragma mark Tests

- (void)testGetObjects
{
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testGetObjects.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [SQLDatabase databaseWithFilePath:storePath];
    NSError *error = nil;

    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS  users(username TEXT NOT NULL, realname TEXT);" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"INSERT INTO users(username, realname) values('hello', 'hector');" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"INSERT INTO users(username, realname) values('goodbye', NULL);" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);

    SQLQuery *getUserHello = [SQLQuery queryWithStatement:@"SELECT * FROM users WHERE username = 'hello';"];
    __block NSArray *objects = nil;
    __block NSDictionary *objectsDict = nil;
    __block NSDictionary *objectsDictWithoutNull = nil;

    [database executeQuery:getUserHello error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        STAssertEquals(row.columnCount, 2u, @"#%u The number of columns is invalid (value = %u, expected = 2).", index, row.columnCount);
        objects = [row objects];
        STAssertEquals(row.columnCount, objects.count, @"#%u The number of objects in the array is invalid (value = %u, expected = %u).", index, objects.count, row.columnCount);
        STAssertTrue([[objects objectAtIndex:0] isEqualToString:@"hello"], @"#%u The first object in the array is invalid (value = '%@', expected = 'hello').", index, [objects objectAtIndex:0]);
        STAssertTrue([[objects objectAtIndex:1] isEqualToString:@"hector"], @"#%u The second object in the array is invalid (value = '%@', expected = 'hector').", index, [objects objectAtIndex:1]);
        objectsDict = [row objectsDict];
        STAssertEquals(row.columnCount, objectsDict.count, @"#%u The number of objects in the dictionary is invalid (value = %u, expected = %u).", index, objectsDict.count, row.columnCount);
        STAssertTrue([[objectsDict objectForKey:@"username"] isEqualToString:@"hello"], @"#%u The object in the dictionary for the key 'username' is invalid (value = '%@', expected = 'hello').", index, [objectsDict objectForKey:@"username"]);
        STAssertTrue([[objectsDict objectForKey:@"realname"] isEqualToString:@"hector"], @"#%u The object in the dictionary for the key 'realname' is invalid (value = '%@', expected = 'hector').", index, [objectsDict objectForKey:@"realname"]);
        objectsDictWithoutNull = [row objectsDictWithoutNull];
        STAssertEquals(row.columnCount, objectsDictWithoutNull.count, @"#%u The number of objects in the dictionary is invalid (value = %u, expected = %u).", index, objectsDictWithoutNull.count, row.columnCount);
        STAssertTrue([[objectsDictWithoutNull objectForKey:@"username"] isEqualToString:@"hello"], @"#%u The object in the dictionary for the key 'username' is invalid (value = '%@', expected = 'hello').", index, [objectsDictWithoutNull objectForKey:@"username"]);
        STAssertTrue([[objectsDictWithoutNull objectForKey:@"realname"] isEqualToString:@"hector"], @"#%u The object in the dictionary for the key 'realname' is invalid (value = '%@', expected = 'hector').", index, [objectsDictWithoutNull objectForKey:@"realname"]);
    }];
    STAssertNotNil(objects, @"Cannot get the result of the request in an array.");
    STAssertNotNil(objectsDict, @"Cannot get the result of the request in an dictionary.");
    STAssertNotNil(objectsDictWithoutNull, @"Cannot get the result of the request in an dictionary.");
    objects = nil;
    objectsDict = nil;
    objectsDictWithoutNull = nil;

    SQLQuery *getUserGoodbye = [SQLQuery queryWithStatement:@"SELECT * FROM users WHERE username = 'goodbye';"];

    [database executeQuery:getUserGoodbye error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        STAssertEquals(row.columnCount, 2u, @"#%u The number of columns is invalid (value = %u, expected = 2).", index, row.columnCount);
        objects = [row objects];
        STAssertEquals(row.columnCount, objects.count, @"#%u The number of objects in the array is invalid (value = %u, expected = %u).", index, objects.count, row.columnCount);
        STAssertTrue([[objects objectAtIndex:0] isEqualToString:@"goodbye"], @"#%u The first object in the array is invalid (value = '%@', expected = 'hello').", index, [objects objectAtIndex:0]);
        STAssertTrue([[objects objectAtIndex:1] isEqual:[NSNull null]], @"#%u The second object in the array is invalid (value = '%@', expected = 'hector').", index, [objects objectAtIndex:1]);
        objectsDict = [row objectsDict];
        STAssertEquals(row.columnCount, objectsDict.count, @"#%u The number of objects in the dictionary is invalid (value = %u, expected = %u).", index, objectsDict.count, row.columnCount);
        STAssertTrue([[objectsDict objectForKey:@"username"] isEqualToString:@"goodbye"], @"#%u The object in the dictionary for the key 'username' is invalid (value = '%@', expected = 'hello').", index, [objectsDict objectForKey:@"username"]);
        STAssertTrue([[objectsDict objectForKey:@"realname"] isEqual:[NSNull null]], @"#%u The object in the dictionary for the key 'realname' is invalid (value = '%@', expected = 'hector').", index, [objectsDict objectForKey:@"realname"]);
        objectsDictWithoutNull = [row objectsDictWithoutNull];
        STAssertEquals(row.columnCount - 1, objectsDictWithoutNull.count, @"#%u The number of objects in the dictionary is invalid (value = %u, expected = %u).", index, objectsDictWithoutNull.count, row.columnCount - 1);
        STAssertTrue([[objectsDictWithoutNull objectForKey:@"username"] isEqualToString:@"goodbye"], @"#%u The object in the dictionary for the key 'username' is invalid (value = '%@', expected = 'hello').", index, [objectsDictWithoutNull objectForKey:@"username"]);
    }];
    STAssertNotNil(objects, @"Cannot get the result of the request in an array.");
    STAssertNotNil(objectsDict, @"Cannot get the result of the request in an dictionary.");
    STAssertNotNil(objectsDictWithoutNull, @"Cannot get the result of the request in an dictionary.");
    objects = nil;
    objectsDict = nil;
    objectsDictWithoutNull = nil;

    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
}

- (void)testGetColumns
{
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testGetColumns.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [SQLDatabase databaseWithFilePath:storePath];
    NSError *error = nil;

    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS  provider(ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, thumbnail BLOB, ratio REAL);" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"INSERT INTO provider(name, ratio) values('rtc2004', 2.4);" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"INSERT INTO provider(name, ratio) values('hugo_2', 0.61);" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"INSERT INTO provider(name, ratio) values('@l3)(', 1.02);" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"INSERT INTO provider(name, ratio) values('anibal', 1.2);" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"INSERT INTO provider(name, ratio) values('ttt', 0.834);" error:&error], @"Execute statement failed (database = %@), error = %@).", database, error);

    SQLQuery *query = [SQLQuery queryWithStatement:@"SELECT * FROM provider;"];

    STAssertTrue([database executeQuery:query error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        STAssertThrows([row objectForColumnAtIndex:99], @"The index is greater than the number of columns, an exception should have been raised.");
        NSLog(@"#%u ----------------------", index);
        [row.columnNameDict enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
            NSString *columnName = (NSString *)key;
            NSAssert([columnName isKindOfClass:[NSString class]] == YES, @"Invalid kind of class.");
            void *blob = [row blobForColumn:columnName buffer:NULL length:NULL];

            NSLog(@"  * %@\t[ id = %@, int = %i, long long = %qi, double = %f, text = '%s', blob = %p (length = %i bytes) ]",
                  columnName,
                  [row objectForColumn:columnName],
                  [row intForColumn:columnName],
                  [row longlongForColumn:columnName],
                  [row doubleForColumn:columnName],
                  [row textForColumn:columnName],
                  blob,
                  [row blobLengthForColumn:columnName]);
            if ( blob != NULL )
            {
                free(blob);
            }
        }];
    }], @"Execute query failed (database = %@, query = %@, error = %@).", database, query, error);
    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
}

- (void)testBlob
{
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testBlob.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [SQLDatabase databaseWithFilePath:storePath];
    NSError *error = nil;

    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS  thumbnail(ID INTEGER PRIMARY KEY, data BLOB);" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    srandom(time(NULL));

    int rowCount = random() % 5 + 5;
    int *sourceDataLength;
    int maxSourceDataLength;
    unsigned char *maxSourceData;
    unsigned char **sourceData;

    sourceDataLength = malloc(rowCount * sizeof(int));
    STAssertNotNil((void *)sourceDataLength, @"Cannot allocate memory to hold the number of row (length = %i).", rowCount);
    sourceData = malloc(rowCount * sizeof(unsigned char **));
    STAssertNotNil((void *)sourceData, @"Cannot allocate memory to hold the random data (length = %i).", maxSourceDataLength);
    for ( NSUInteger row = 0; row < rowCount; row++ )
    {
        sourceDataLength[row] = random() % 1024 + 128;
        maxSourceDataLength = MAX(maxSourceDataLength, sourceDataLength[row]);
        sourceData[row] = malloc(sourceDataLength[row] * sizeof(unsigned char *));
        STAssertNotNil((void *)sourceData[row], @"Cannot allocate memory to hold the random data (length = %i, row = %i).", maxSourceDataLength, row);
        for ( NSUInteger byteIndex = 0; byteIndex < sourceDataLength[row]; byteIndex++ )
        {
            sourceData[row][byteIndex] = random() % 256;
        }
        [database executeStatement:@"INSERT INTO thumbnail values(?, ?)" arguments:[NSArray arrayWithObjects:[NSNumber numberWithInt:row], [NSData dataWithBytes:sourceData[row] length:sourceDataLength[row]], nil] error:&error];
    }
    maxSourceData = malloc(maxSourceDataLength * sizeof(unsigned char *));
    STAssertNotNil((void *)maxSourceData, @"Cannot allocate memory to hold the random data (length = %i).", maxSourceDataLength);

    SQLQuery *query = [SQLQuery queryWithStatement:@"SELECT * FROM thumbnail ORDER BY ID ASC;"];

    STAssertTrue([database executeQuery:query error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        int databaseDataLength = 0;
        void *databaseData = [row blobForColumn:@"data" buffer:NULL length:&databaseDataLength];

        STAssertEquals(sourceDataLength[index], databaseDataLength, @"#%u The length of the data saved in the database is not equals to the length of the source.", index);
        STAssertTrue(memcmp(databaseData, sourceData[index], databaseDataLength) == 0, @"#%u The data saved in the database are not equal to the source.", index);

        [row blobForColumn:@"data" buffer:maxSourceData length:NULL];

        STAssertTrue(memcmp(databaseData, maxSourceData, databaseDataLength) == 0, @"#%u The data saved in the database are not equal to the source.", index);

        databaseDataLength = 0;
        [row blobForColumn:@"data" buffer:maxSourceData length:&databaseDataLength];

        STAssertEquals(sourceDataLength[index], databaseDataLength, @"#%u The length of the data saved in the database is not equals to the length of the source.", index);
        STAssertTrue(memcmp(databaseData, maxSourceData, databaseDataLength) == 0, @"#%u The data saved in the database are not equal to the source.", index);

        NSLog(@"#%u The data in the database are the same than the source (length %i).", index, databaseDataLength);
    }], @"Execute query failed (database = %@, query = %@, error = %@).", database, query, error);

    free(sourceDataLength);
    for ( NSUInteger row = 0; row < rowCount; row++ )
    {
        free(sourceData[row]);
    }
    free(sourceData);
    free(maxSourceData);
    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
}

@end
