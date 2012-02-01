//
//  SQLRowTests.m
//  SQLiteKit
//
//  Created by Alexandre Laborie on 1/30/12.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SQLRowTests.h"
#import "SQLDatabase.h"
#import "SQLQuery.h"
#import "SQLRow.h"

@implementation SQLRowTests

- (void)testGetColumns
{
    NSString *databaseLocalPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"server.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;

    [fileManager removeItemAtPath:databaseLocalPath error:&error];
    if ( error != nil && error.code != NSFileNoSuchFileError )
    {
        STAssertNil(error, [error localizedDescription]);
    }

    SQLDatabase *database = [SQLDatabase databaseWithPath:databaseLocalPath];

    STAssertTrue([database open], @"Open operation failed (database = %@).", database);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS  provider(ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, thumbnail BLOB, ratio REAL);"], @"Execute statement failed (database = %@).", database);
    STAssertTrue([database executeStatement:@"INSERT INTO provider(name, ratio) values('rtc2004', 2.4);"], @"Execute statement failed (database = %@).", database);
    STAssertTrue([database executeStatement:@"INSERT INTO provider(name, ratio) values('hugo_2', 0.61);"], @"Execute statement failed (database = %@).", database);
    STAssertTrue([database executeStatement:@"INSERT INTO provider(name, ratio) values('@l3)(', 1.02);"], @"Execute statement failed (database = %@).", database);
    STAssertTrue([database executeStatement:@"INSERT INTO provider(name, ratio) values('anibal', 1.2);"], @"Execute statement failed (database = %@).", database);
    STAssertTrue([database executeStatement:@"INSERT INTO provider(name, ratio) values('ttt', 0.834);"], @"Execute statement failed (database = %@).", database);

    SQLQuery *query = [SQLQuery queryWithStatement:@"SELECT * FROM provider;"];

    STAssertTrue([database executeQuery:query thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
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
    }], @"Execute query failed (database = %@, query = %@).", database, query);
    STAssertTrue([database close], @"Close operation failed (database = %@).", database);
}

- (void)testBlob
{
    NSString *databaseLocalPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"blob.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;

    [fileManager removeItemAtPath:databaseLocalPath error:&error];
    if ( error != nil && error.code != NSFileNoSuchFileError )
    {
        STAssertNil(error, [error localizedDescription]);
    }

    SQLDatabase *database = [SQLDatabase databaseWithPath:databaseLocalPath];

    STAssertTrue([database open], @"Open operation failed (database = %@).", database);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS  thumbnail(ID INTEGER PRIMARY KEY, data BLOB);"], @"Execute statement failed (database = %@).", database);
    srandom(time(NULL));

    int rowCount = random() % 5 + 5;
    int *sourceDataLength;
    int maxSourceDataLength;
    unsigned char *maxSourceData;
    unsigned char **sourceData;

    sourceDataLength = malloc(rowCount * sizeof(int));
    STAssertTrue(sourceDataLength != NULL, @"Cannot allocate memory to hold the number of row (length = %i).", rowCount);
    sourceData = malloc(rowCount * sizeof(unsigned char **));
    STAssertTrue(sourceData != NULL , @"Cannot allocate memory to hold the random data (length = %i).", maxSourceDataLength);
    for ( NSUInteger row = 0; row < rowCount; row++ )
    {
        sourceDataLength[row] = random() % 1024 + 128;
        maxSourceDataLength = MAX(maxSourceDataLength, sourceDataLength[row]);
        sourceData[row] = malloc(sourceDataLength[row] * sizeof(unsigned char *));
        STAssertTrue(sourceData[row] != NULL , @"Cannot allocate memory to hold the random data (length = %i, row = %i).", maxSourceDataLength, row);
        for ( NSUInteger byteIndex = 0; byteIndex < sourceDataLength[row]; byteIndex++ )
        {
            sourceData[row][byteIndex] = random() % 256;
        }
        [database executeWithStatementAndArguments:@"INSERT INTO thumbnail values(?, ?)", [NSNumber numberWithInt:row], [NSData dataWithBytes:sourceData[row] length:sourceDataLength[row]], nil];
    }
    maxSourceData = malloc(maxSourceDataLength * sizeof(unsigned char *));
    STAssertTrue(maxSourceData != NULL, @"Cannot allocate memory to hold the random data (length = %i).", maxSourceDataLength);

    SQLQuery *query = [SQLQuery queryWithStatement:@"SELECT * FROM thumbnail ORDER BY ID ASC;"];

    STAssertTrue([database executeQuery:query thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
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

        NSLog(@"#%u The data in the database are the same than the source (length %i)", index, databaseDataLength);
    }], @"Execute query failed (database = %@, query = %@).", database, query);

    free(sourceDataLength);
    for ( NSUInteger row = 0; row < rowCount; row++ )
    {
        free(sourceData[row]);
    }
    free(sourceData);
    free(maxSourceData);
    STAssertTrue([database close], @"Close operation failed (database = %@).", database);
}

@end
