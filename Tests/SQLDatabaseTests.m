/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SQLDatabaseTests.h"

#import "SenTestCase+SQLiteKitAdditions.h"

@implementation SQLDatabaseTests

#pragma mark -
#pragma mark Tests

- (void)testLifeCycle
{
    SQLDatabase *database = nil;
    NSError *error = nil;

    database = [SQLDatabase database];
    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);

    NSURL *storeURL = [NSURL fileURLWithPath:[self generateValidTemporaryPathWithComponent:@"testLifeCycle"]];

    database = [SQLDatabase databaseWithFileURL:storeURL];
    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);

    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testLifeCycle"];

    database = [SQLDatabase databaseWithFilePath:storePath];
    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);

    database = [[SQLDatabase alloc] init];
    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
    [database release];

    database = [[SQLDatabase alloc] init];
    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
    [database release];

    storeURL = [NSURL fileURLWithPath:[self generateValidTemporaryPathWithComponent:@"testLifeCycle"]];
    database = [[SQLDatabase alloc] initWithFileURL:storeURL];
    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
    [database release];

    storePath = [self generateValidTemporaryPathWithComponent:@"testLifeCycle"];
    database = [[SQLDatabase alloc] initWithFilePath:storePath];
    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertFalse([database open:NULL], @"Open must failed (database = %@).", database, error);
    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
    STAssertFalse([database close:NULL], @"Close must failed (database = %@).", database);
    STAssertTrue([database openWithFlags:SQLITE_OPEN_READWRITE error:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
    [database release];
}

- (void)testLifeCycleAdvanced
{
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testLifeCycleAdvanced.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [[SQLDatabase alloc] initWithFilePath:storePath];
    __block NSError *error = nil;

    STAssertTrue([database openWithFlags:(SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_SHAREDCACHE | SQLITE_OPEN_FULLMUTEX) error:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS user(id INTEGER PRIMARY KEY AUTOINCREMENT, fullname TEXT);" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);

    SQLQuery *insertUserQuery = [SQLQuery queryWithStatement:@"INSERT INTO user(fullname) VALUES(?);"];
    NSArray *insertUserData = [NSArray arrayWithObjects:
                               [NSArray arrayWithObject:@"John Steinbeck"],
                               [NSArray arrayWithObject:@"Alexandre Dumas"],
                               [NSArray arrayWithObject:@"Ernest Hemingway"],
                               [NSArray arrayWithObject:@"Jack Kerouac"],
                               [NSArray arrayWithObject:@"Victor Hugo"],
                               [NSArray arrayWithObject:@"Boris Vian"],
                               [NSArray arrayWithObject:@"Romain Gary"],
                               [NSArray arrayWithObject:@"Hermann Hesse"],
                               [NSArray arrayWithObject:@"Paulo Coelho"],
                               [NSArray arrayWithObject:@"Jean Jacques Rousseau"],
                               [NSArray arrayWithObject:@"Joseph Conrad"],
                               [NSArray arrayWithObject:@"Czeslaw Milosz"],
                               [NSArray arrayWithObject:@"George Bernard Shaw"],
                               [NSArray arrayWithObject:@"Wallace Stevens"],
                               [NSArray arrayWithObject:@"Rumi"],
                               [NSArray arrayWithObject:@"W.G. Sebald"],
                               [NSArray arrayWithObject:@"Robert Hayden"],
                               [NSArray arrayWithObject:@"Henry Miller"],
                               [NSArray arrayWithObject:@"Robert Heinlein"],
                               [NSArray arrayWithObject:@"Lorine Niedecker"],
                               [NSArray arrayWithObject:@"George Eliot"],
                               [NSArray arrayWithObject:@"David Mamet"],
                               [NSArray arrayWithObject:@"Derek Walcott"],
                               [NSArray arrayWithObject:@"Isak Dinesen"],
                               [NSArray arrayWithObject:@"Maryse Conde"],
                               [NSArray arrayWithObject:@"Joyce Cary"],
                               [NSArray arrayWithObject:@"Frank O'Hara"],
                               [NSArray arrayWithObject:@"Gabriel Garcia Marquez"],
                               [NSArray arrayWithObject:@"Carson McCullers"],
                               [NSArray arrayWithObject:@"Flann O'Brien"],
                               [NSArray arrayWithObject:@"Julio Cortazar"],
                               [NSArray arrayWithObject:@"Saul Bellow"],
                               [NSArray arrayWithObject:@"Jonathan Swift"],
                               [NSArray arrayWithObject:@"Ezra Pound"],
                               [NSArray arrayWithObject:@"Philip K. Dick"],
                               [NSArray arrayWithObject:@"Percy Shelley"],
                               [NSArray arrayWithObject:@"James Agee"],
                               [NSArray arrayWithObject:@"Stanley Elkin"],
                               [NSArray arrayWithObject:@"Walter Benjamin"],
                               [NSArray arrayWithObject:@"Harold Pinter"],
                               [NSArray arrayWithObject:@"John Berryman"],
                               [NSArray arrayWithObject:@"James Baldwin"],
                               [NSArray arrayWithObject:@"Tu Fu"],
                               [NSArray arrayWithObject:@"Jorge Luis Borges"],
                               [NSArray arrayWithObject:@"Malcolm Lowry"],
                               [NSArray arrayWithObject:@"Willa Cather"],
                               [NSArray arrayWithObject:@"Edgar Allan Poe"],
                               [NSArray arrayWithObject:@"Henrik Ibsen"],
                               [NSArray arrayWithObject:@"W.H. Auden"],
                               [NSArray arrayWithObject:@"Thomas Pynchon"],
                               [NSArray arrayWithObject:@"Emily Brontë/Charlotte Brontë"],
                               [NSArray arrayWithObject:@"Flannery O'Connor"],
                               [NSArray arrayWithObject:@"Leo Tolstoy"],
                               [NSArray arrayWithObject:@"Tennessee Williams"],
                               [NSArray arrayWithObject:@"Nathaniel Hawthorne"],
                               [NSArray arrayWithObject:@"T.S. Eliot"],
                               [NSArray arrayWithObject:@"Sophocles"],
                               [NSArray arrayWithObject:@"Johann Wolfgang von Goethe"],
                               [NSArray arrayWithObject:@"Toni Morrison"],
                               [NSArray arrayWithObject:@"Charles Olson"],
                               [NSArray arrayWithObject:@"Eugene O'Neill"],
                               [NSArray arrayWithObject:@"Gustave Flaubert"],
                               [NSArray arrayWithObject:@"Ivan Turgenev"],
                               [NSArray arrayWithObject:@"Charles Baudelaire"],
                               [NSArray arrayWithObject:@"Robert Lowell"],
                               [NSArray arrayWithObject:@"Mark Twain"],
                               [NSArray arrayWithObject:@"Robert Creeley"],
                               [NSArray arrayWithObject:@"Iris Murdoch"],
                               [NSArray arrayWithObject:@"Arthur Rimbaud"],
                               [NSArray arrayWithObject:@"Mary Shelley"],
                               [NSArray arrayWithObject:@"Virgil"],
                               [NSArray arrayWithObject:@"Walt Whitman"],
                               [NSArray arrayWithObject:@"D.H. Lawrence"],
                               [NSArray arrayWithObject:@"William Carlos Williams"],
                               [NSArray arrayWithObject:@"Samuel Coleridge"],
                               [NSArray arrayWithObject:@"Henry James"],
                               [NSArray arrayWithObject:@"John Keats"],
                               [NSArray arrayWithObject:@"William Wordsworth"],
                               [NSArray arrayWithObject:@"Ovid"],
                               [NSArray arrayWithObject:@"William Blake"],
                               [NSArray arrayWithObject:@"Dr. Johnson"],
                               [NSArray arrayWithObject:@"Lord Byron"],
                               [NSArray arrayWithObject:@"George Orwell"],
                               [NSArray arrayWithObject:@"Stendhal"],
                               [NSArray arrayWithObject:@"Euripides"],
                               [NSArray arrayWithObject:@"Miguel Cervantes"],
                               [NSArray arrayWithObject:@"Laurence Sterne"],
                               [NSArray arrayWithObject:@"Herman Melville"],
                               [NSArray arrayWithObject:@"William Butler Yeats"],
                               [NSArray arrayWithObject:@"Homer"],
                               [NSArray arrayWithObject:@"Charles Dickens"],
                               [NSArray arrayWithObject:@"John Ashbery"],
                               [NSArray arrayWithObject:@"Virginia Woolf"],
                               [NSArray arrayWithObject:@"Geoffrey Chaucer"],
                               [NSArray arrayWithObject:@"Dante"],
                               [NSArray arrayWithObject:@"Fyodor Doestoyevsky"],
                               [NSArray arrayWithObject:@"Marcel Proust"],
                               [NSArray arrayWithObject:@"Anton Chekhov"],
                               [NSArray arrayWithObject:@"Vladimir Nabokov"],
                               [NSArray arrayWithObject:@"Samuel Beckett"],
                               [NSArray arrayWithObject:@"John Milton"],
                               [NSArray arrayWithObject:@"Gertrude Stein"],
                               [NSArray arrayWithObject:@"James Joyce"],
                               [NSArray arrayWithObject:@"William Shakespeare"],
                               [NSArray arrayWithObject:@"Franz Kafka"],
                               [NSArray arrayWithObject:@"William Faulkner"],
                               nil];

    NSInteger pivot = insertUserData.count / 2;
    NSRange firtPart = NSMakeRange(0, pivot);
    NSRange secondPart = NSMakeRange(pivot, insertUserData.count - pivot);
    NSDate *startingDate;

    startingDate = [NSDate date];
    [insertUserData enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:firtPart] options:0 usingBlock:^(id object, NSUInteger index, BOOL *stop) {
        insertUserQuery.arguments = (NSArray *)object;
        STAssertTrue([database executeQuery:insertUserQuery options:0 error:&error thenEnumerateRowsUsingBlock:NULL], @"Execute query failed (database = %@, error = %@).", database, error);
        STAssertEquals(database.numberOfChanges, 1u, @"Insertion failed (query = %@).", insertUserQuery);
    }];
    NSLog(@"Duration in seconds to insert %d WITHOUT cache: %fs.", pivot, [[NSDate date] timeIntervalSinceDate:startingDate]);

    startingDate = [NSDate date];
    [insertUserData enumerateObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:secondPart] options:0 usingBlock:^(id object, NSUInteger index, BOOL *stop) {
        insertUserQuery.arguments = (NSArray *)object;
        STAssertTrue([database executeQuery:insertUserQuery options:SQLExecuteCacheStatement error:&error thenEnumerateRowsUsingBlock:NULL], @"Execute query failed (database = %@, error = %@).", database, error);
        STAssertEquals(database.numberOfChanges, 1u, @"Insertion failed (query = %@).", insertUserQuery);
    }];
    NSLog(@"Duration in seconds to insert %d WITH cache: %fs.", pivot, [[NSDate date] timeIntervalSinceDate:startingDate]);

    SQLQuery *queryAllUsers = [SQLQuery queryWithStatement:@"SELECT * FROM user;"];

    NSLog(@"Show all users:");
    STAssertTrue([database executeQuery:queryAllUsers error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%3u %@", index, row);
    }], @"Execute query failed (database = %@, query = %@, errror = %@).", database, queryAllUsers, error);

    SQLQuery *queryCountUsers = [SQLQuery queryWithStatement:@"SELECT count(ID) AS `number of users` FROM user;"];

    NSLog(@"Number of users:");
    STAssertTrue([database executeQuery:queryCountUsers error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u %@", index, row);
    }], @"Execute query failed (database = %@, query = %@, error = %@).", database, queryCountUsers, error);

    SQLQuery *queryBorisVian = [SQLQuery queryWithStatementAndArguments:@"SELECT * FROM user WHERE fullname = ?;", @"Boris Vian", nil];

    NSLog(@"Sow the user called 'Boris Vian':");
    STAssertTrue([database executeQuery:queryBorisVian error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u array = [%@], dictionary = %@", index, [[row objects] componentsJoinedByString:@", "], [row objectsDict]);
    }], @"Execute query failed (database = %@, query = %@, error = %@).", database, queryBorisVian, error);

    SQLQuery *queryLike = [SQLQuery queryWithStatement:@"SELECT * FROM user WHERE fullname LIKE 'J%';"];

    NSLog(@"Show the users with a name starting by J:");
    STAssertTrue([database executeQuery:queryLike error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u array = [%@], dictionary = %@", index, [[row objects] componentsJoinedByString:@", "], [row objectsDict]);
    }], @"Execute query failed (database = %@, query = %@, error = %@).", database, queryLike, error);

    SQLQuery *queryNoResult = [SQLQuery queryWithStatement:@"SELECT * FROM user WHERE fullname = 'Alain Damasio';"];

    __block BOOL blockHasBeenCalled = NO;

    NSLog(@"Show the user called 'Alain Damasio:");
    STAssertTrue([database executeQuery:queryNoResult options:SQLExecuteCallBlockIfNoResult error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        blockHasBeenCalled = YES;
        STAssertNil(row, @"If a request returns no result, the row parameter should be equals to nil.");
        STAssertEquals(index, NSNotFound, @"If a request returns no result, the index parameter should be equals to NSNotFound.");
        STAssertNotNil((void *)stop, @"If a request returns no result, the stop pointer should not be NULL.");
    }], @"Execute query failed (database = %@, query = %@, error = %@).", database, queryNoResult, error);
    STAssertTrue(blockHasBeenCalled == YES, @"A block should have been called even if the request returns no result.");

    SQLQuery *queryCached = [SQLQuery queryWithStatement:@"SELECT * FROM user where fullname LIKE ?;" arguments:[NSArray arrayWithObject:@"W%"]];

    NSLog(@"Show the users with a name starting by W:");
    STAssertTrue([database executeQuery:queryCached options:SQLExecuteCacheStatement error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u array = [%@], dictionary = %@", index, [[row objects] componentsJoinedByString:@", "], [row objectsDict]);
    }], @"Execute query failed (database = %@, query = %@, error = %@).", database, queryLike, error);
    queryCached.arguments = [NSArray arrayWithObject:@"S%"];
    NSLog(@"Show the users with a name starting by S:");
    STAssertTrue([database executeQuery:queryCached options:SQLExecuteCacheStatement error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u array = [%@], dictionary = %@", index, [[row objects] componentsJoinedByString:@", "], [row objectsDict]);
    }], @"Execute query failed (database = %@, query = %@, error = %@).", database, queryLike, error);

    [database printRuntimeStatusWithResetFlag:NO];
    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
    [database release];
}

- (void)testExecuteFile
{
    NSString *dumpFilePath = [self pathForSQLResource:@"dump_movie"];
    STAssertNotNil(dumpFilePath, @"The path of the dump file must be different than nil.");
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testExecuteFile.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [SQLDatabase databaseWithFilePath:storePath];
    NSError *error = nil;

    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeSQLFileAtPath:dumpFilePath error:&error], @"Execute SQL file failed (database = %@, filePath = %@, error = %@).", database, dumpFilePath, error);

    SQLQuery *numberOfActorsQuery = [SQLQuery queryWithStatement:@"SELECT count(*) FROM actors;"];
    __block NSUInteger numberOfActors = 0;

    NSLog(@"Number of actors:");
    STAssertTrue([database executeQuery:numberOfActorsQuery error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        numberOfActors = (NSUInteger)[row intForColumnAtIndex:0];
        NSLog(@"%u", numberOfActors);
    }], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertEquals(numberOfActors, 9u, @"Invalid number of actors (value = %u, expected = 9).", numberOfActors);

    SQLQuery *numberOfActorsInPulpFictionQuery = [SQLQuery queryWithStatementAndArguments:@"SELECT count(*) FROM act, actors, movies WHERE act.actor_id = actors.id AND act.movie_id = movies.id AND movies.title = ?;", @"Pulp Fiction", nil];
    __block NSUInteger numberOfActorsInPulpFiction = 0;

    NSLog(@"Number of actors playing in 'Pulp Fiction':");
    STAssertTrue([database executeQuery:numberOfActorsInPulpFictionQuery options:SQLExecuteCacheStatement error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        numberOfActorsInPulpFiction = (NSUInteger)[row intForColumnAtIndex:0];
        NSLog(@"%u", numberOfActorsInPulpFiction);
    }], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertEquals(numberOfActorsInPulpFiction, 2u, @"Invalid number of actors playing in 'Pulp Fiction' (value = %u, expected = 2).", numberOfActorsInPulpFiction);

    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
}

- (void)testNotifications
{
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testNotifications.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [SQLDatabase databaseWithFileURL:[NSURL fileURLWithPath:storePath]];
    __block NSError *error = nil;

    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    id commitObserver = nil;
    __block NSInteger commitNotificationCount = 0;
    NSInteger commitNotificationExpectedCount = 13; // 9 insert + 3 delete + 1 update

    id rollbackObserver = nil;
    __block NSInteger rollbackNotificationCount = 0;
    NSInteger rollbackNotificationExpectedCount = 1;

    id notificationObserver = nil;
    __block NSInteger notificationCount = 0;
    NSInteger notificationExpectedCount = 9;

    // Adds an observer for each notification.
    commitObserver = [defaultCenter addObserverForName:kSQLDatabaseCommitNotification object:database queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@" - Received a commit notification (notification = %@)", note);
        commitNotificationCount++;
    }];
    rollbackObserver = [defaultCenter addObserverForName:kSQLDatabaseRollbackNotification object:database queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@" - Received a rollback notification (notification = %@)", note);
        rollbackNotificationCount++;
    }];
    [database beginGeneratingNotificationsIntoCenter:defaultCenter];
    notificationObserver = [defaultCenter addObserverForName:[kSQLDatabaseInsertNotification stringByAppendingString:@"main.countries"] object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@" - Received an insertion notification (notification = %@)", note);
        notificationCount++;
    }];

    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS countries(ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, area INTEGER);" error:&error], @"Execute statement failed (database = %@, error = %@).", database);

    SQLQuery *insertCountryQuery = [SQLQuery queryWithStatement:@"INSERT INTO countries(name, area) VALUES(?, ?);"];
    NSArray *insertCountryData = [NSArray arrayWithObjects:
                                  [NSArray arrayWithObjects:@"Russia", [NSNumber numberWithInteger:17098242], nil],
                                  [NSArray arrayWithObjects:@"Canada", [NSNumber numberWithInteger:9984670], nil],
                                  [NSArray arrayWithObjects:@"China", [NSNumber numberWithInteger:9596961], nil],
                                  [NSArray arrayWithObjects:@"United States", [NSNumber numberWithInteger:9522055], nil],
                                  [NSArray arrayWithObjects:@"Brazil", [NSNumber numberWithInteger:851487], nil],
                                  [NSArray arrayWithObjects:@"Australia", [NSNumber numberWithInteger:7692024], nil],
                                  [NSArray arrayWithObjects:@"India", [NSNumber numberWithInteger:3166414], nil],
                                  [NSArray arrayWithObjects:@"Argentina", [NSNumber numberWithInteger:2780400], nil],
                                  [NSArray arrayWithObjects:@"Kazakhstan", [NSNumber numberWithInteger:2724900], nil],
                                  nil];

    NSLog(@"Insert 9 rows in the table countries countries:");
    [insertCountryData enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        insertCountryQuery.arguments = (NSArray *)object;
        STAssertTrue([database executeQuery:insertCountryQuery options:SQLExecuteCacheStatement error:&error thenEnumerateRowsUsingBlock:NULL], @"Execute query failed (database = %@, error = %@).", database, error);
        STAssertEquals(database.numberOfChanges, 1u, @"Insertion failed (query = %@).", insertCountryQuery);
    }];
    STAssertEquals(notificationCount, notificationExpectedCount, @"Invalid number of notifications sent (sent = %u, expected = %u)", notificationCount, notificationExpectedCount);
    // Removes the observer that listens the updates of the table countries.
    [defaultCenter removeObserver:notificationObserver];

    // Adds a observer that listens the updates of the tables countries.
    notificationObserver = [defaultCenter addObserverForName:[kSQLDatabaseInsertNotification stringByAppendingString:@"main.countries"] object:nil queue:nil usingBlock:^(NSNotification *note) {
        STAssertTrue(false, @"This method should not been called, the observer has been removed!");
    }];
    // Remove it immediately.
    [defaultCenter removeObserver:notificationObserver];
    // Then insert a new row in the table countries.
    insertCountryQuery.arguments = [NSArray arrayWithObjects:@"Algeria", [NSNumber numberWithInteger:2381741], nil];
    [database executeQuery:insertCountryQuery error:&error];
    STAssertEquals(database.numberOfChanges, 1u, @"Insertion failed (query = %@).", insertCountryQuery);
    [defaultCenter removeObserver:notificationObserver];

    // Adds another observer that listen the updates (only delete in this case) of the tables countries.
    notificationObserver = [defaultCenter addObserverForName:[kSQLDatabaseDeleteNotification stringByAppendingString:@"main.countries"] object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@" - Received a deletion notification (notification = %@)", note);
        notificationCount++;
    }];
    notificationCount = 0;
    notificationExpectedCount = 3;
    NSLog(@"Delete all the rows (3) in the table countries where the name start by A:");
    STAssertTrue([database executeStatement:@"DELETE FROM countries WHERE name LIKE 'A%';" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertEquals(notificationCount, notificationExpectedCount, @"Invalid number of notifications sent (sent = %u, expected = %u)", notificationCount, notificationExpectedCount);
    [defaultCenter removeObserver:notificationObserver];

    // Adds another observer that listen the updates (only update in this case) of the tables countries.
    notificationObserver = [defaultCenter addObserverForName:[kSQLDatabaseUpdateNotification stringByAppendingString:@"main.countries"] object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@" - Received an update notification (notification = %@)", note);
        notificationCount++;
    }];
    notificationCount = 0;
    notificationExpectedCount = 1;
    NSLog(@"Update the area of Brazil from 851487 to 8514877:");
    STAssertTrue([database executeStatement:@"UPDATE countries SET area = 8514877 where name = 'Brazil';" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertEquals(database.numberOfChanges, 1u, @"Insertion failed.");
    STAssertEquals(notificationCount, notificationExpectedCount, @"Invalid number of notifications sent (sent = %u, expected = %u)", notificationCount, notificationExpectedCount);
    [defaultCenter removeObserver:notificationObserver];

    // Creates a new transaction in order to know if a notification is sent when a transaction is cancelled.
    STAssertTrue([database executeStatement:@"BEGIN TRANSACTION;" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);

    NSArray *insertOtherCountriesData = [NSArray arrayWithObjects:
                                         [NSArray arrayWithObjects:@"Democratic Republic of the Congo", [NSNumber numberWithInteger:2344858], nil],
                                         [NSArray arrayWithObjects:@"Greenland", [NSNumber numberWithInteger:2166086], nil],
                                         nil];

    [insertOtherCountriesData enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        insertCountryQuery.arguments = (NSArray *)object;
        STAssertTrue([database executeQuery:insertCountryQuery options:SQLExecuteCacheStatement error:&error thenEnumerateRowsUsingBlock:NULL], @"Execute query failed (database = %@, error = %@).", database, error);
        STAssertEquals(database.numberOfChanges, 1u, @"Insertion failed (query = %@).", insertCountryQuery);
    }];

    STAssertTrue([database executeStatement:@"ROLLBACK TRANSACTION;" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertEquals(rollbackNotificationCount, rollbackNotificationExpectedCount, @"Invalid number of rollback notifications sent (sent = %u, expected = %u)", rollbackNotificationCount, rollbackNotificationExpectedCount);
    [defaultCenter removeObserver:rollbackObserver];

    // Checks if all the commit notifications have been sent.
    STAssertEquals(commitNotificationCount, commitNotificationExpectedCount, @"Invalid number of commit notifications sent (sent = %u, expected = %u)", commitNotificationCount, commitNotificationExpectedCount);
    [defaultCenter removeObserver:commitObserver];

    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
}

- (void)testAllExecutionTypes
{
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testAllExecutionTypes.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [SQLDatabase databaseWithFilePath:storePath];
    __block NSError *error = nil;

    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS airports(id INTEGER PRIMARY KEY, fullname TEXT, short TEXT, country TEXT);" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);

    STAssertNil(database.lastInsertRowID, @"No insert operation occurred yet, this method should have returned a nil pointer.");
    STAssertNil(database.lastInsertRowID, @"No insert operation occurred yet, this method should have returned a nil pointer.");

    SQLQuery *insertAirportQuery = [SQLQuery queryWithStatement:@"INSERT INTO airports(fullname, short, country) VALUES(?, ?, ?);"];
    NSArray *insertAirportData = [NSArray arrayWithObjects:
                                  [NSArray arrayWithObjects:@"San Francisco", @"SFO", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Atlanta", @"ATL", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Beijing", @"PEK", @"China", nil],
                                  [NSArray arrayWithObjects:@"Boston", @"BOS", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Buenos Aires", @"BUE", @"Argentina", nil],
                                  [NSArray arrayWithObjects:@"Charlotte", @"CLT", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Los Angeles", @"LAX", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Honolulu", @"HNL", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Portland", @"PDX", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Paris", @"CDG", @"France", nil],
                                  [NSArray arrayWithObjects:@"Denver", @"DEN", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Seatle", @"SEA", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Sydney", @"SYD", @"Australia", nil],
                                  [NSArray arrayWithObjects:@"Brisbane", @"BNE", @"Australia", nil],
                                  [NSArray arrayWithObjects:@"Kuala Lumpur", @"KUL", @"Malaysia", nil],
                                  [NSArray arrayWithObjects:@"Berlin", @"BER", @"Germany", nil],
                                  [NSArray arrayWithObjects:@"London", @"LHR", @"England", nil],
                                  [NSArray arrayWithObjects:@"Madrid", @"MAD", @"Spain", nil],
                                  [NSArray arrayWithObjects:@"Rome", @"ROM", @"Italia", nil],
                                  [NSArray arrayWithObjects:@"Prague", @"PRG", @"Czech Republic", nil],
                                  [NSArray arrayWithObjects:@"Wellington", @"WLG", @"New Zealand", nil],
                                  [NSArray arrayWithObjects:@"Auckland", @"AKL", @"New Zeland", nil],
                                  [NSArray arrayWithObjects:@"Amsterdam", @"AMS", @"Holland", nil],
                                  [NSArray arrayWithObjects:@"Athens", @"ATH", @"Greece", nil],
                                  [NSArray arrayWithObjects:@"Austin", @"AUS", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Barcelona", @"BCN", @"Spain", nil],
                                  [NSArray arrayWithObjects:@"Bangkok", @"BKK", @"Thailand",nil],
                                  [NSArray arrayWithObjects:@"Baltimore", @"BWI", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Chicago", @"CHI", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Columbus", @"CMH", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Cleveland", @"CLV", @"USA", nil],
                                  [NSArray arrayWithObjects:@"El Paso", @"ELP", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Florence", @"FLR", @"Italia", nil],
                                  [NSArray arrayWithObjects:@"Ouagadougou", @"OUA", @"Burkina Faso", nil],
                                  [NSArray arrayWithObjects:@"Guatemala", @"GUA", @"Guatemala", nil],
                                  [NSArray arrayWithObjects:@"Geneva", @"GVA", @"Switzerland", nil],
                                  [NSArray arrayWithObjects:@"Hong Kong", @"HKG", @"Taiwan", nil],
                                  [NSArray arrayWithObjects:@"Helsinki", @"HEL", @"Finland", nil],
                                  [NSArray arrayWithObjects:@"Istanbul", @"IST", @"Turkey", nil],
                                  [NSArray arrayWithObjects:@"Kiev", @"KBP", @"Ukraine", nil],
                                  [NSArray arrayWithObjects:@"Lima", @"LIM", @"Peru", nil],
                                  [NSArray arrayWithObjects:@"Miami", @"MIA", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Munich", @"MUC", @"Germany", nil],
                                  [NSArray arrayWithObjects:@"Reno", @"RNO", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Ulaanbaatar", @"ULN", @"Mongolia", nil],
                                  [NSArray arrayWithObjects:@"Zurich", @"ZRH", @"Switzerland", nil],
                                  [NSArray arrayWithObjects:@"Zagreb", @"ZAG", @"Croatia", nil],
                                  [NSArray arrayWithObjects:@"La Paz", @"LAP", @"Mexico", nil],
                                  [NSArray arrayWithObjects:@"Darwin", @"DRW", @"Australia", nil],
                                  [NSArray arrayWithObjects:@"Tunis", @"TUN", @"Tunisia", nil],
                                  [NSArray arrayWithObjects:@"Djibouti", @"JIB", @"Djibouti", nil],
                                  [NSArray arrayWithObjects:@"Accra", @"ACC", @"Ghana", nil],
                                  [NSArray arrayWithObjects:@"Singapore", @"SIN", @"Singapore Republic", nil],
                                  [NSArray arrayWithObjects:@"Bamako", @"BKO", @"Mali", nil],
                                  [NSArray arrayWithObjects:@"Marrakesh", @"RAK", @"Morocco", nil],
                                  [NSArray arrayWithObjects:@"Casablanca", @"CMN", @"Morocco", nil],
                                  [NSArray arrayWithObjects:@"Cotonou", @"COO", @"Benin Republic", nil],
                                  [NSArray arrayWithObjects:@"Abidjan", @"ABJ", @"Côte d'Ivoire", nil],
                                  [NSArray arrayWithObjects:@"Toulouse", @"TLS", @"France", nil],
                                  [NSArray arrayWithObjects:@"Nice", @"NCE", @"France", nil],
                                  [NSArray arrayWithObjects:@"Marseille", @"MRS", @"France", nil],
                                  [NSArray arrayWithObjects:@"New York", @"JFK", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Dallas", @"DFW", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Shanghai", @"SH", @"China", nil],
                                  [NSArray arrayWithObjects:@"Dubai", @"DBX", @"United Arab Emirates", nil],
                                  [NSArray arrayWithObjects:@"Rio de Janeiro", @"GIG", @"Brazil", nil],
                                  [NSArray arrayWithObjects:@"Houston", @"IAH", @"USA", nil],
                                  [NSArray arrayWithObjects:@"Lome", @"LFW", @"Togo", nil],
                                  nil];

    [insertAirportData enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        insertAirportQuery.arguments = (NSArray *)object;
        STAssertTrue([database executeQuery:insertAirportQuery options:SQLExecuteCacheStatement error:&error thenEnumerateRowsUsingBlock:NULL], @"Execute query failed (database = %@, error = %@).", database, error);
        STAssertEquals(database.numberOfChanges, 1u, @"Insertion failed (query = %@).", insertAirportQuery);
        STAssertNotNil(database.lastInsertRowID, @"The last inserted row should have an ID different from nil.");
    }];

    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS companies(id INTEGER PRIMARY KEY, name TEXT);" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);

    SQLQuery *insertCompanyQuery = [SQLQuery queryWithStatement:@"INSERT INTO companies(name) VALUES(?);"];
    NSArray *insertCompanyData = [NSArray arrayWithObjects:
                                  [NSArray arrayWithObject:@"Alaska Airlines"],
                                  [NSArray arrayWithObject:@"American Airlines"],
                                  [NSArray arrayWithObject:@"Delta"],
                                  [NSArray arrayWithObject:@"United"],
                                  [NSArray arrayWithObject:@"US Airways"],
                                  [NSArray arrayWithObject:@"Virgin America"],
                                  [NSArray arrayWithObject:@"Air France"],
                                  [NSArray arrayWithObject:@"Air China"],
                                  [NSArray arrayWithObject:@"Air Nostrum LAMSA"],
                                  [NSArray arrayWithObject:@"Turkish Airlines"],
                                  [NSArray arrayWithObject:@"Iberia"],
                                  [NSArray arrayWithObject:@"British Airways"],
                                  [NSArray arrayWithObject:@"Virgin Australia"],
                                  [NSArray arrayWithObject:@"Lufthansa"],
                                  [NSArray arrayWithObject:@"China Eastern Air"],
                                  [NSArray arrayWithObject:@"Hawaiian Airlines"],
                                  [NSArray arrayWithObject:@"China Southern"],
                                  [NSArray arrayWithObject:@"SWISS"],
                                  [NSArray arrayWithObject:@"LAN Airlines"],
                                  [NSArray arrayWithObject:@"Emirates"],
                                  [NSArray arrayWithObject:@"Aerolineas Argentinas"],
                                  [NSArray arrayWithObject:@"Malaysia Airlines"],
                                  [NSArray arrayWithObject:@"Singapore Air"],
                                  [NSArray arrayWithObject:@"Ethiopian Air"],
                                  [NSArray arrayWithObject:@"Air New Zealand"],
                                  [NSArray arrayWithObject:@"Hainan Airlines"],
                                  nil];

    [insertCompanyData enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        insertCompanyQuery.arguments = (NSArray *)object;
        STAssertTrue([database executeQuery:insertCompanyQuery options:SQLExecuteCacheStatement error:&error thenEnumerateRowsUsingBlock:NULL], @"Execute query failed (database = %@, error = %@).", database, error);
        STAssertEquals(database.numberOfChanges, 1u, @"Insertion failed (query = %@).", insertAirportQuery);
        STAssertNotNil(database.lastInsertRowID, @"The last inserted row should have an ID different from nil.");
    }];

    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS flights(id INTEGER PRIMARY KEY, take_off TEXT, landing TEXT, from_id INTEGER, to_id INTERGER, company_id INTEGER, FOREIGN KEY(from_id) REFERENCES airports(id), FOREIGN KEY(to_id) REFERENCES airports(id), FOREIGN KEY(company_id) REFERENCES companies(id));" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);

    SQLQuery *insertFlightQuery = [SQLQuery queryWithStatement:@"INSERT INTO flights(take_off, landing, from_id, to_id, company_id) SELECT ?, ?, a1.id, a2.id, companies.id FROM airports AS a1, airports as a2, companies WHERE a1.fullname = ? AND a2.fullname = ? AND companies.name = ?;"];
    NSArray *insertFlightData = [NSArray arrayWithObjects:
                                 [NSArray arrayWithObjects:@"Tue 6:50a", @"Tue 8:10a", @"San Francisco", @"Los Angeles", @"Alaska Airlines", nil],
                                 [NSArray arrayWithObjects:@"Tue 1:35p", @"Tue 2:55p", @"San Francisco", @"Los Angeles", @"Virgin America", nil],
                                 [NSArray arrayWithObjects:@"Tue 6:00a", @"Tue 8:40a", @"El Paso", @"Dallas", @"American Airlines", nil],
                                 [NSArray arrayWithObjects:@"Tue 10:00a", @"Tue 2:20p", @"Dallas", @"New York", @"American Airlines", nil],
                                 [NSArray arrayWithObjects:@"Tue 11:00a", @"Tue 1:09p", @"Chicago", @"Columbus", @"United", nil],
                                 [NSArray arrayWithObjects:@"Tue 5:45p", @"Tue 6:20p", @"Columbus", @"Chicago", @"American Airlines", nil],
                                 [NSArray arrayWithObjects:@"Tue 7:00a", @"Tue 10:35a", @"Boston", @"Los Angeles", @"Virgin America", nil],
                                 [NSArray arrayWithObjects:@"Tue 12:15p", @"Tue 3:05p", @"Boston", @"Atlanta", @"Delta", nil],
                                 [NSArray arrayWithObjects:@"Tue 4:30p", @"Tue 6:22p", @"Atlanta", @"Los Angeles", @"Delta", nil],
                                 [NSArray arrayWithObjects:@"Tue 1:35p", @"Tue 3:19p", @"Dallas", @"San Francisco", @"United", nil],

                                 [NSArray arrayWithObjects:@"Tue 9:35a", @"Tue 11:05a", @"Toulouse", @"Paris", @"Air France", nil],
                                 [NSArray arrayWithObjects:@"Tue 11:05a", @"Tue 12:25p", @"Toulouse", @"Nice", @"Air France", nil],
                                 [NSArray arrayWithObjects:@"Tue 7:00a", @"Tue 8:20a", @"Toulouse", @"Madrid", @"Air Nostrum LAMSA", nil],
                                 [NSArray arrayWithObjects:@"Tue 10:20a", @"Tue 10:10a", @"Madrid", @"Casablanca", @"Air Nostrum LAMSA", nil],
                                 [NSArray arrayWithObjects:@"Tue 2:00p", @"Tue 8:30p", @"Casablanca", @"Istanbul", @"Turkish Airlines", nil],
                                 [NSArray arrayWithObjects:@"Tue 4:10p", @"Tue 8:45p", @"Paris", @"Ouagadougou", @"Air France", nil],
                                 [NSArray arrayWithObjects:@"Tue 5:50p", @"Wed 8:50a", @"Dallas", @"London", @"Iberia", nil],
                                 [NSArray arrayWithObjects:@"Wed 9:55a", @"Wed 12:45p", @"London", @"Berlin", @"British Airways", nil],
                                 [NSArray arrayWithObjects:@"Tue 6:45p", @"Wed 9:35a", @"Dallas", @"London", @"British Airways", nil],
                                 [NSArray arrayWithObjects:@"Fri 8:45p", @"Sat 12:20a", @"Brisbane", @"Darwin", @"Virgin Australia", nil],

                                 [NSArray arrayWithObjects:@"Sat 3:50p", @"Sat 4:50p", @"Nice", @"London", @"British Airways", nil],
                                 [NSArray arrayWithObjects:@"Fri 2:55p", @"Fri 4:50p", @"Nice", @"Berlin", @"Lufthansa", nil],
                                 [NSArray arrayWithObjects:@"Sat 2:45p", @"Sat 3:00p", @"Paris", @"London", @"British Airways", nil],
                                 [NSArray arrayWithObjects:@"Sat 5:15p", @"Sat 9:15p", @"London", @"New York", @"British Airways", nil],
                                 [NSArray arrayWithObjects:@"Mon 5:30p", @"Mon 8:00p", @"New York", @"Denver", @"United", nil],
                                 [NSArray arrayWithObjects:@"Mon 9:00a", @"Mon 12:10p", @"New York", @"Los Angeles", @"American Airlines", nil],
                                 [NSArray arrayWithObjects:@"Thu 12:00p", @"Thu 7:20p", @"Sydney", @"Shanghai", @"China Eastern Air", nil],
                                 [NSArray arrayWithObjects:@"Thu 9:20p", @"Thu 10:10a", @"Sydney", @"Honolulu", @"Hawaiian Airlines", nil],
                                 [NSArray arrayWithObjects:@"Thu 2:00p", @"Thu 9:20p", @"Honolulu", @"Los Angeles", @"Hawaiian Airlines", nil],
                                 [NSArray arrayWithObjects:@"Thu 9:25a", @"Thu 2:40p", @"Sydney", @"Auckland", @"LAN Airlines", nil],

                                 [NSArray arrayWithObjects:@"Thu 7:00p", @"Thu 3:50p", @"Auckland", @"Buenos Aires", @"Aerolineas Argentinas", nil],
                                 [NSArray arrayWithObjects:@"Thu 7:00p", @"Thu 10:25p", @"Buenos Aires", @"Lima", @"Aerolineas Argentinas", nil],
                                 [NSArray arrayWithObjects:@"Mon 2:35p", @"Mon 2:55p", @"Cotonou", @"Abidjan", @"Ethiopian Air", nil],
                                 [NSArray arrayWithObjects:@"Thu 2:30p", @"Thu 10:55p", @"Tunis", @"Dubai", @"Emirates", nil],
                                 [NSArray arrayWithObjects:@"Fri 7:40a", @"Fri 12:40p", @"Dubai", @"Accra", @"Emirates", nil],
                                 [NSArray arrayWithObjects:@"Fri 1:55p", @"Fri 2:55p", @"Accra", @"Abidjan", @"Emirates", nil],
                                 [NSArray arrayWithObjects:@"Sat 6:05p", @"Sun 6:00a", @"Dubai", @"Beijing", @"China Southern", nil],
                                 [NSArray arrayWithObjects:@"Sun 12:35p", @"Sun 3:05p", @"Shanghai", @"Beijing", @"China Eastern Air", nil],
                                 [NSArray arrayWithObjects:@"Tue 7:40a", @"Tue 8:35a", @"Geneva", @"Zurich", @"SWISS", nil],
                                 [NSArray arrayWithObjects:@"Tue 9:25a", @"Tue 11:55a", @"Zurich", @"Marrakesh", @"SWISS", nil],

                                 [NSArray arrayWithObjects:@"Fri 4:10p", @"Fri 8:55p", @"Paris", @"Bamako", @"Air France", nil],
                                 [NSArray arrayWithObjects:@"Thu 10:10a", @"Thu 11:42a", @"Charlotte", @"Cleveland", @"United", nil],
                                 [NSArray arrayWithObjects:@"Thu 12:20p", @"Thu 1:07p", @"Cleveland", @"Columbus", @"United", nil],
                                 [NSArray arrayWithObjects:@"Tue 8:00p", @"Wed 7:20a", @"Dubai", @"Singapore", @"Ethiopian Air", nil],
                                 [NSArray arrayWithObjects:@"Wed 11:30p", @"Thu 5:50a", @"Beijing", @"Singapore", @"Air China", nil],
                                 [NSArray arrayWithObjects:@"Tue 11:30p", @"Wed 5:50a", @"Beijing", @"Singapore", @"Air China", nil],
                                 [NSArray arrayWithObjects:@"Sun 8:50a", @"Sun 12:20p", @"Beijing", @"Hong Kong", @"China Southern", nil],
                                 [NSArray arrayWithObjects:@"Sun 6:45p", @"Sun 10:30p", @"Kuala Lumpur", @"Hong Kong", @"Malaysia Airlines", nil],
                                 [NSArray arrayWithObjects:@"Sat 5:50p", @"Sat 9:35p", @"Singapore", @"Hong Kong", @"Singapore Air", nil],
                                 [NSArray arrayWithObjects:@"Mon 6:45a", @"Mon 7:45a", @"Singapore", @"Kuala Lumpur", @"Malaysia Airlines", nil],

                                 [NSArray arrayWithObjects:@"Mon 2:35a", @"Mon 5:35a", @"Darwin", @"Singapore", @"Singapore Air", nil],
                                 [NSArray arrayWithObjects:@"Mon 8:35a", @"Mon 9:30a", @"Singapore", @"Kuala Lumpur", @"Singapore Air", nil],
                                 [NSArray arrayWithObjects:@"Sat 2:40a", @"Sat 6:35a", @"Dubai", @"London", @"British Airways", nil],
                                 [NSArray arrayWithObjects:@"Sat 12:00p", @"Sat 9:50p", @"London", @"Rio de Janeiro", @"British Airways", nil],
                                 [NSArray arrayWithObjects:@"Sat 9:30p", @"Sun 1:23a", @"Buenos Aires", @"Rio de Janeiro", @"Emirates", nil],
                                 [NSArray arrayWithObjects:@"Sun 6:30a", @"Sun 9:30a", @"Buenos Aires", @"Rio de Janeiro", @"Aerolineas Argentinas", nil],
                                 [NSArray arrayWithObjects:@"Fri 11:50p", @"Sat 6:45a", @"Rio de Janeiro", @"Miami", @"American Airlines", nil],
                                 [NSArray arrayWithObjects:@"Mon 9:45a", @"Mon 11:25a", @"Miami", @"Guatemala", @"American Airlines", nil],
                                 [NSArray arrayWithObjects:@"Tue 12:00p", @"Tue 3:05p", @"Miami", @"New York", @"Delta", nil],
                                 [NSArray arrayWithObjects:@"Tue 4:00p", @"Tue 7:35p", @"New York", @"San Francisco", @"Delta", nil],

                                 [NSArray arrayWithObjects:@"Wed 2:05p", @"Wed 3:30p", @"Zagreb", @"Berlin", @"Lufthansa", nil],
                                 [NSArray arrayWithObjects:@"Wed 6:30p", @"Wed 7:55p", @"Berlin", @"Zurich", @"Lufthansa", nil],
                                 [NSArray arrayWithObjects:@"Thu 3:35p", @"Thu 6:15p", @"London", @"Zurich", @"British Airways", nil],
                                 [NSArray arrayWithObjects:@"Sat 12:05p", @"Sat 3:05p", @"London", @"Nice", @"British Airways", nil],
                                 [NSArray arrayWithObjects:@"Sun 3:15p", @"Sun 4:40p", @"Nice", @"Tunis", @"Air France", nil],
                                 [NSArray arrayWithObjects:@"Mon 8:15p", @"Mon 10:25p", @"London", @"Paris", @"Air France", nil],
                                 [NSArray arrayWithObjects:@"Tue 4:10p", @"Tue 8:45p", @"Paris", @"Ouagadougou", @"Air France", nil],
                                 [NSArray arrayWithObjects:@"Tue 6:33p", @"Tue 7:59p", @"Reno", @"Los Angeles", @"United", nil],
                                 [NSArray arrayWithObjects:@"Tue 8:30p", @"Tue 9:45p", @"Los Angeles", @"San Francisco", @"United", nil],
                                 [NSArray arrayWithObjects:@"Thu 7:10a", @"Thu 2:50p", @"San Francisco", @"Atlanta", @"Delta", nil],

                                 [NSArray arrayWithObjects:@"Thu 5:15p", @"Thu 11:55p", @"Atlanta", @"Lima", @"Delta", nil],
                                 [NSArray arrayWithObjects:@"Fri 1:20p", @"Sat 4:35p", @"Seatle", @"Beijing", @"Hainan Airlines", nil],
                                 [NSArray arrayWithObjects:@"Fri 1:50p", @"Sat 5:55p", @"San Francisco", @"Beijing", @"Air China", nil],
                                 [NSArray arrayWithObjects:@"Thu 9:25a", @"Thu 12:40p", @"London", @"Florence", @"Air France", nil],
                                 [NSArray arrayWithObjects:@"Fri 5:25p", @"Fri 6:40p", @"Zurich", @"Florence", @"SWISS", nil],
                                 [NSArray arrayWithObjects:@"Fri 7:20p", @"Fri 8:30p", @"Florence", @"Zurich", @"SWISS", nil],
                                 [NSArray arrayWithObjects:@"Sat 9:40a", @"Sat 1:30p", @"Zurich", @"Istanbul", @"SWISS", nil],
                                 [NSArray arrayWithObjects:@"Wed 8:00a", @"Wed 1:15p", @"Kiev", @"London", @"British Airways", nil],
                                 [NSArray arrayWithObjects:@"Fri 9:05p", @"Sat 5:15p", @"London", @"Hong Kong", @"Air New Zealand", nil],
                                 [NSArray arrayWithObjects:@"Sat 7:15p", @"Sun 11:10a", @"Hong Kong", @"Auckland", @"Air New Zealand", nil],

                                 [NSArray arrayWithObjects:@"Sun 1:00p", @"Sun 2:00p", @"Auckland", @"Wellington", @"Air New Zealand", nil],
                                 [NSArray arrayWithObjects:@"Sun 3:40p", @"Sun 5:20p", @"Wellington", @"Sydney", @"Virgin Australia", nil],
                                 [NSArray arrayWithObjects:@"Tue 1:50p", @"Wed 5:55p", @"San Francisco", @"Beijing", @"Air China", nil],
                                 [NSArray arrayWithObjects:@"Thu 11:55a", @"Thu 2:30p", @"Beijing", @"Ulaanbaatar", @"Air China", nil],
                                 [NSArray arrayWithObjects:@"Thu 3:30p", @"Thu 5:35p", @"Ulaanbaatar", @"Beijing", @"Air China", nil],
                                 [NSArray arrayWithObjects:@"Fri 4:00p", @"Fri 10:30p", @"Beijing", @"Kuala Lumpur", @"Air China", nil],
                                 [NSArray arrayWithObjects:@"Fri 2:15p", @"Sat 1:30a", @"Casablanca", @"Dubai", @"Emirates", nil],
                                 [NSArray arrayWithObjects:@"Sat 3:20a", @"Sat 2:30p", @"Dubai", @"Hong Kong", @"Emirates", nil],
                                 [NSArray arrayWithObjects:@"Sat 7:45a", @"Sat 10:25a", @"Istanbul", @"Paris", @"Turkish Airlines", nil],
                                 [NSArray arrayWithObjects:@"Wed 10:10a", @"Wed 2:25p", @"Paris", @"Athens", @"Air France", nil],

                                 [NSArray arrayWithObjects:@"Sat 7:30p", @"Sat 8:45p", @"Athens", @"Istanbul", @"Turkish Airlines", nil],
                                 [NSArray arrayWithObjects:@"Sun 8:10a", @"Sun 10:40a", @"Istanbul", @"Barcelona", @"Turkish Airlines", nil],
                                 [NSArray arrayWithObjects:@"Sat 6:20a", @"Sat 8:05a", @"Charlotte", @"Houston", @"United", nil],
                                 [NSArray arrayWithObjects:@"Sat 9:05a", @"Sat 9:48a", @"Houston", @"Austin", @"United", nil],
                                 [NSArray arrayWithObjects:@"Sat 2:05p", @"Sat 3:15p", @"Houston", @"Dallas", @"American Airlines", nil],
                                 [NSArray arrayWithObjects:@"Sat 5:45p", @"Sat 8:55p", @"Dallas", @"Guatemala", @"American Airlines", nil],
                                 [NSArray arrayWithObjects:@"Sat 10:35p", @"Sun 10:30a", @"New York", @"London", @"British Airways", nil],
                                 [NSArray arrayWithObjects:@"Sun 12:05p", @"Sun 9:55p", @"London", @"Rio de Janeiro", @"British Airways", nil],
                                 [NSArray arrayWithObjects:@"Mon 8:05p", @"Tue 7:30a", @"Miami", @"Rio de Janeiro", @"United", nil],
                                 [NSArray arrayWithObjects:@"Fri 3:35a", @"Fri 6:30a", @"Dubai", @"Istanbul", @"Turkish Airlines", nil],

                                 [NSArray arrayWithObjects:@"Sun 10:55p", @"Mon 5:15a", @"Rio de Janeiro", @"Houston", @"United", nil],
                                 [NSArray arrayWithObjects:@"Mon 11:40a", @"Mon 2:05p", @"Houston", @"San Francisco", @"United", nil],
                                 [NSArray arrayWithObjects:@"Mon 10:39p", @"Wed 8:10a", @"San Francisco", @"Sydney", @"United", nil],
                                 [NSArray arrayWithObjects:@"Wed 9:40a", @"Wed 2:50p", @"Sydney", @"Wellington", @"Air New Zealand", nil],
                                 [NSArray arrayWithObjects:@"Sat 11:30p", @"Sun 5:55a", @"Ouagadougou", @"Paris", @"Air France", nil],
                                 [NSArray arrayWithObjects:@"Sun 9:45a", @"Sun 11:45a", @"Paris", @"Zagreb", @"Air France", nil],
                                 [NSArray arrayWithObjects:@"Tue 9:30a", @"Tue 11:15a", @"Ouagadougou", @"Lome", @"Ethiopian Air", nil],
                                 [NSArray arrayWithObjects:@"Tue 1:20p", @"Tue 3:00p", @"Lome", @"Cotonou", @"Ethiopian Air", nil],
                                 [NSArray arrayWithObjects:@"Sat 5:10p", @"Sun 5:55a", @"Chicago", @"London", @"Iberia", nil],
                                 [NSArray arrayWithObjects:@"Sat 3:00p", @"Sat 5:25p", @"Rome", @"Madrid", @"Iberia", nil],

                                 [NSArray arrayWithObjects:@"Sun 9:05a", @"Sun 11:05a", @"Madrid", @"Paris", @"Iberia", nil],
                                 [NSArray arrayWithObjects:@"Tue 7:45p", @"Tue 9:55p", @"Rome", @"Paris", @"Air France", nil],
                                 [NSArray arrayWithObjects:@"Tue 6:05p", @"Tue 9:25p", @"Rome", @"Istanbul", @"Turkish Airlines", nil],
                                 [NSArray arrayWithObjects:@"Sat 7:25p", @"Sun 8:50a", @"Miami", @"London", @"Iberia", nil],
                                 [NSArray arrayWithObjects:@"Sun 4:10p", @"Sun 9:05p", @"London", @"Helsinki", @"British Airways", nil],
                                 [NSArray arrayWithObjects:@"Fri 10:25a", @"Fri 11:25a", @"Helsinki", @"Berlin", @"Lufthansa", nil],
                                 [NSArray arrayWithObjects:@"Fri 7:25p", @"Sat 11:50a", @"Berlin", @"Beijing", @"Hainan Airlines", nil],
                                 [NSArray arrayWithObjects:@"Sat 1:30p", @"Sat 5:45p", @"Beijing", @"Paris", @"Air China", nil],
                                 [NSArray arrayWithObjects:@"Sun 1:30a", @"Sun 5:30a", @"Beijing", @"Paris", @"Air France", nil],
                                 [NSArray arrayWithObjects:@"Sun 10:40a", @"Sun 5:05p", @"Paris", @"Lima", @"Air France", nil],
                                 nil];

    [insertFlightData enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        insertFlightQuery.arguments = (NSArray *)object;
        STAssertTrue([database executeQuery:insertFlightQuery options:SQLExecuteCacheStatement error:&error thenEnumerateRowsUsingBlock:NULL], @"Execute query failed (database = %@, error = %@).", database, error);
        STAssertEquals(database.numberOfChanges, 1u, @"Insertion failed (query = %@).", insertFlightQuery);
        STAssertNotNil(database.lastInsertRowID, @"The last inserted row should have an ID different from nil.");
    }];

    STAssertTrue([database executeStatement:@"INSERT INTO airports(country, short, fullname) VALUES('Egypt', 'CAI', 'Cairo');" error:&error], @"Execute query failed (database = %@), error = %@).", database, error);
    STAssertEquals(database.numberOfChanges, 1u, @"Insertion failed (query = %@).", insertFlightQuery);

    NSNumber *cairoAirportID = database.lastInsertRowID;
    STAssertNotNil(cairoAirportID, @"The last inserted row should have an ID different from nil.");

    STAssertTrue([database executeStatement:@"INSERT INTO companies(name) VALUES(?);" arguments:[NSArray arrayWithObject:@"Egypt Air"] error:&error], @"Execute query failed (database = %@), error = %@).", database, error);
    STAssertEquals(database.numberOfChanges, 1u, @"Insertion failed (query = %@).", insertFlightQuery);

    NSNumber *egyptAirID = database.lastInsertRowID;
    STAssertNotNil(egyptAirID, @"The last inserted row should have an ID different from nil.");

    SQLQuery *getParisIDQuery = [SQLQuery queryWithStatement:@"SELECT id FROM airports WHERE fullname = 'Paris' LIMIT 1;"];
    __block NSNumber *parisAirportID = nil;

    NSLog(@"Show the id of the airport called 'Paris':");
    STAssertTrue([database executeQuery:getParisIDQuery error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        parisAirportID = [row objectForColumnAtIndex:0];
        NSLog(@"%@", parisAirportID);
    }], @"Execute query failed (database = %@).", database);
    STAssertNotNil(parisAirportID, @"Cannot found the ID of the paris airport in the database.");

    NSArray *flightsCairoParisData = [NSArray arrayWithObjects:
                                      [NSArray arrayWithObjects:@"Sat 3:10p", @"Sat 8:30p", parisAirportID, cairoAirportID, egyptAirID, nil],
                                      [NSArray arrayWithObjects:@"Sat 9:45p", @"Sun 3:15a", cairoAirportID, parisAirportID, egyptAirID, nil],
                                      nil];
    SQLQuery *flightsCairoParisInsertQuery = [SQLQuery queryWithStatement:@"INSERT INTO flights(take_off, landing, from_id, to_id, company) VALUES(?, ?, ?, ?, ?);"];

    [flightsCairoParisData enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        flightsCairoParisInsertQuery.arguments = (NSArray *)object;
        STAssertTrue([database executeQuery:insertFlightQuery error:&error], @"Execute query failed (database = %@, error = %@).", database, error);
        STAssertEquals(database.numberOfChanges, 1u, @"Insertion failed (query = %@).", flightsCairoParisInsertQuery);
        STAssertNotNil(database.lastInsertRowID, @"The last inserted row should have an ID different from nil.");
    }];

    NSString *dumpFilePath = [self pathForSQLResource:@"dump_travel_alter"];

    STAssertTrue([database executeSQLFileAtPath:dumpFilePath error:&error], @"Execute SQL file failed (database = %@, filePath = %@, error = %@).", database, dumpFilePath, error);

    // SELECT take_off, landing, airports_to.name AS destination, companies.name AS companies  FROM flights, airports as airport_from, airports as airport_to, companies WHERE airport_from.name = 'Paris' AND airport_from.id = flights.from_id AND flights.id = airports_to.id AND flights.id = companies.id;

    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
}

- (void)testStringEncoding
{
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testStringEncoding.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [SQLDatabase databaseWithFilePath:storePath];
    __block NSError *error = nil;

    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS sentences(ID INTEGER PRIMARY KEY, language TEXT, content TEXT);" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);

    NSArray *sentenceData = [NSArray arrayWithObjects:
                             [NSArray arrayWithObjects:@"Danish", @"[Quizdeltagerne spiste jordbær med fløde, mens cirkusklovnen Wolther spillede på xylofon.]", nil],
                             [NSArray arrayWithObjects:@"German", @"[Zwölf Boxkämpfer jagten Eva quer über den Sylter Deich.]", nil],
                             [NSArray arrayWithObjects:@"Greek", @"[Γαζέες καὶ μυρτιὲς δὲν θὰ βρῶ πιὰ στὸ χρυσαφὶ ξέφωτο.]", nil],
                             [NSArray arrayWithObjects:@"English", @"[The quick brown fox jumps over the lazy dog.]", nil],
                             [NSArray arrayWithObjects:@"Spanish", @"[El pingüino Wenceslao hizo kilómetros bajo exhaustiva lluvia y frío, añoraba a su querido cachorro.]", nil],
                             [NSArray arrayWithObjects:@"French", @"[Le cœur déçu mais l'âme plutôt naïve, Louÿs rêva de crapaüter en canoë au delà des îles, près du mälström où brûlent les novæ.]", nil],
                             [NSArray arrayWithObjects:@"Irish Gaelic", @"[D'fhuascail Íosa, Úrmhac na hÓighe Beannaithe, pór Éava agus Ádhaimh]", nil],
                             [NSArray arrayWithObjects:@"Hungarian", @"[Árvíztűrő tükörfúrógép]", nil],
                             [NSArray arrayWithObjects:@"Icelandic", @"[Kæmi ný öxi hér ykist þjófum nú bæði víl og ádrepa]", nil],
                             [NSArray arrayWithObjects:@"Japanese (Hiragana)", @"[いろはにほへとちりぬるを わかよたれそつねならむ うゐのおくやまけふこえて あさきゆめみしゑひもせす]", nil],
                             [NSArray arrayWithObjects:@"Japanese (Katakana)", @"[イロハニホヘト チリヌルヲ ワカヨタレソ ツネナラム ウヰノオクヤマ ケフコエテ アサキユメミシ ヱヒモセスン]", nil],
                             [NSArray arrayWithObjects:@"Hebrew", @"[ג סקרן שט בים מאוכזב ולפתע מצא לו חברה איך הקליטה]", nil],
                             [NSArray arrayWithObjects:@"Polish", @"[Pchnąć w tę łódź jeża lub ośm skrzyń fig]", nil],
                             [NSArray arrayWithObjects:@"Russian", @"[В чащах юга жил бы цитрус? Да, но фальшивый экземпляр!]", nil],
                             [NSArray arrayWithObjects:@"Thai", @"[ฉบับย่อกระโดดสีน้ำตาลมากกว่าสุนัขจิ้งจอกสุนัขขี้เกียจ]", nil],
                             nil];
    SQLQuery *insertSentenceQuery = [SQLQuery queryWithStatement:@"INSERT INTO sentences(language, content) VALUES(?, ?);"];

    [sentenceData enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        insertSentenceQuery.arguments = (NSArray *)object;
        STAssertTrue([database executeQuery:insertSentenceQuery options:SQLExecuteCacheStatement error:&error thenEnumerateRowsUsingBlock:NULL], @"Execute statement failed (database = %@, error = %@).", database, error);
        STAssertEquals(database.numberOfChanges, 1u, @"Insertion failed (query = %@).", insertSentenceQuery);
        STAssertNotNil(database.lastInsertRowID, @"The last inserted row should have an ID different from nil.");
    }];

    SQLQuery *selectQuery = [SQLQuery queryWithStatement:@"SELECT * FROM sentences;"];

    STAssertTrue([database executeQuery:selectQuery error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSString *sentence = [row objectForColumn:@"content"];
        STAssertTrue([sentence isKindOfClass:[NSString class]] == YES, @"Invalid kind of class.");
        STAssertEquals([sentence characterAtIndex:0], (unichar)'[', @"Invalid first character.");
        STAssertEquals([sentence characterAtIndex:(sentence.length - 1)], (unichar)']', @"Invalid last character.");
    }], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
}

- (void)testDataTypes
{
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testDataTypes.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [SQLDatabase databaseWithFilePath:storePath];
    NSError *error = nil;

    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS data(ID INTEGER PRIMARY KEY, description TEXT);" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"INSERT INTO data(description) VALUES(?);" arguments:[NSArray arrayWithObject:[NSURL URLWithString:@"http://www.apple.com"]] error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"INSERT INTO data(description) VALUES(?);" arguments:[NSArray arrayWithObject:[NSData data]] error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"INSERT INTO data(description) VALUES(?);" arguments:[NSArray arrayWithObject:[NSDate date]] error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"INSERT INTO data(description) VALUES(?);" arguments:[NSArray arrayWithObject:[NSIndexSet indexSetWithIndex:42]] error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
}

- (void)testExecuteOptions
{
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testGetObjects.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [SQLDatabase databaseWithFilePath:storePath];
    NSError *error = nil;

    STAssertTrue([database open:&error], @"Open operation failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS  users(username TEXT NOT NULL, realname TEXT);" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"INSERT INTO users(username, realname) values('hello', 'hector');" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);
    STAssertTrue([database executeStatement:@"INSERT INTO users(username, realname) values('goodbye', NULL);" error:&error], @"Execute statement failed (database = %@, error = %@).", database, error);

    SQLQuery *getUserGoodbye = [SQLQuery queryWithStatement:@"SELECT * FROM users WHERE realname = 'goodbye';"];
    __block NSUInteger numberOfBlockExecuted = 0;

    STAssertTrue([database executeQuery:getUserGoodbye options:SQLExecuteCallBlockIfNoResult error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        numberOfBlockExecuted++;
        STAssertNil(row, @"If a request returns no result, the row parameter should be equals to nil.");
        STAssertEquals(index, NSNotFound, @"If a request returns no result, the index parameter should be equals to NSNotFound.");
        STAssertNotNil((void *)stop, @"If a request returns no result, the stop pointer should not be NULL.");
    }], @"Execute query failed (database = %@, query = %@, error = %@).", database, getUserGoodbye, error);
    STAssertTrue([database executeQuery:getUserGoodbye error:&error thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        numberOfBlockExecuted++;
        STAssertTrue(false, @"This block should not have been called. By default, the block of a query that returns no result should not called.");
    }], @"Execute query failed (database = %@, query = %@, error = %@).", database, getUserGoodbye, error);
    STAssertEquals(numberOfBlockExecuted, 1u, @"The number of blocks executed is invalid (value = %u, expected = '1')", numberOfBlockExecuted);

    STAssertTrue([database close:&error], @"Close operation failed (database = %@, error = %@).", database, error);
}

@end
