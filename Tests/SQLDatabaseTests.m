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
    SQLDatabase *database = [[SQLDatabase alloc] init];

    [database open];
    [database close];
    [database release];
}

- (void)testLifeCycleAdvanced
{
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testLifeCycleAdvanced.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [[SQLDatabase alloc] initWithFilePath:storePath];
    /// @todo Check the return values to make sure that the operations have succeed.

    STAssertTrue([database openWithFlags:(SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_SHAREDCACHE | SQLITE_OPEN_FULLMUTEX)], @"Open operation failed (database = %@).", database);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS user (ID INTEGER PRIMARY KEY AUTOINCREMENT, full_name TEXT);"], @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"John Steinbeck", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Alexandre Dumas", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Ernest Hemingway", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Jack Kerouac", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Victor Hugo", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Boris Vian", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Romain Gary", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Hermann Hesse", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Paulo Coelho", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Jean Jacques Rousseau", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Joseph Conrad", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Czeslaw Milosz", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"George Bernard Shaw", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Wallace Stevens", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Rumi", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"W.G. Sebald", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Robert Hayden", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Henry Miller", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Robert Heinlein", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Lorine Niedecker", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"George Eliot", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"David Mamet", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Derek Walcott", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Isak Dinesen", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Maryse Conde", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Joyce Cary", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Frank O'Hara", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Gabriel Garcia Marquez", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Carson McCullers", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Flann O'Brien", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Julio Cortazar", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Saul Bellow", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Jonathan Swift", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Ezra Pound", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Philip K. Dick", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Percy Shelley", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"James Agee", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Stanley Elkin", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Walter Benjamin", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Harold Pinter", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"John Berryman", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"James Baldwin", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Tu Fu", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Jorge Luis Borges", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Malcolm Lowry", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Willa Cather", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Edgar Allan Poe", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Henrik Ibsen", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"W.H. Auden", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Thomas Pynchon", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Emily Brontë/Charlotte Brontë", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Flannery O'Connor", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Leo Tolstoy", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Tennessee Williams", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Nathaniel Hawthorne", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"T.S. Eliot", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Sophocles", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Johann Wolfgang von Goethe", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Toni Morrison", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Charles Olson", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Eugene O'Neill", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Gustave Flaubert", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Ivan Turgenev", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Charles Baudelaire", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Robert Lowell", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Mark Twain", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Robert Creeley", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Iris Murdoch", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Arthur Rimbaud", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Mary Shelley", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Virgil", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Emily Dickinson", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Walt Whitman", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"D.H. Lawrence", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"William Carlos Williams", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Samuel Coleridge", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Henry James", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"John Keats", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"William Wordsworth", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Ovid", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"William Blake", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Dr. Johnson", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Lord Byron", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"George Orwell", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Stendhal", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Euripides", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Miguel Cervantes", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Laurence Sterne", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Herman Melville", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"William Butler Yeats", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Homer", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Charles Dickens", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"John Ashbery", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Virginia Woolf", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Geoffrey Chaucer", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Dante", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Fyodor Doestoyevsky", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Marcel Proust", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Anton Chekhov", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Vladimir Nabokov", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Samuel Beckett", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"John Milton", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Gertrude Stein", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"James Joyce", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"William Shakespeare", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"Franz Kafka", nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO user(full_name) VALUES(?);", @"William Faulkner", nil]), @"Execute statement failed (database = %@).", database);

    SQLQuery *queryAllUsers = [SQLQuery queryWithStatement:@"SELECT * FROM user;"];

    STAssertTrue([database executeQuery:queryAllUsers thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u ----------------------", index);
        NSLog(@"%@", row);
    }], @"Execute query failed (database = %@, query = %@).", database, queryAllUsers);

    SQLQuery *queryCountUsers = [SQLQuery queryWithStatement:@"SELECT count(ID) AS `number of users` FROM user;"];

    STAssertTrue([database executeQuery:queryCountUsers thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u ----------------------", index);
        NSLog(@"%@", row);
    }], @"Execute query failed (database = %@, query = %@).", database, queryCountUsers);

    SQLQuery *queryBorisVian = [SQLQuery queryWithStatementAndArguments:@"SELECT * FROM user WHERE full_name = ?;", @"Boris Vian", nil];

    STAssertTrue([database executeQuery:queryBorisVian thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u ----------------------", index);
        NSLog(@"array = %@", [row objects]);
        NSLog(@"dictionary = %@", [row objectsDict]);
    }], @"Execute query failed (database = %@, query = %@).", database, queryBorisVian);

    SQLQuery *queryLike = [SQLQuery queryWithStatement:@"SELECT * FROM user WHERE full_name LIKE 'J%';"];

    STAssertTrue([database executeQuery:queryLike thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u ----------------------", index);
        NSLog(@"array = %@", [row objects]);
        NSLog(@"dictionary = %@", [row objectsDict]);
    }], @"Execute query failed (database = %@, query = %@).", database, queryLike);

    SQLQuery *queryNoResult = [SQLQuery queryWithStatement:@"SELECT * FROM user WHERE full_name = 'Alain Damasio';"];

    STAssertTrue([database executeQuery:queryNoResult thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSAssert(row == nil, @"This request should have return no result.");
        NSAssert(index == NSNotFound, @"This request should have return no result.");
    }], @"Execute query failed (database = %@, query = %@).", database, queryNoResult);

    SQLQuery *queryCached = [SQLQuery queryWithStatement:@"SELECT * FROM user where full_name LIKE ?;" arguments:[NSArray arrayWithObject:@"W%"]];

    STAssertTrue([database executeQuery:queryCached withOptions:SQLDatabaseExecutingOptionCacheStatement thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u ----------------------", index);
        NSLog(@"array = %@", [row objects]);
        NSLog(@"dictionary = %@", [row objectsDict]);
    }], @"Execute query failed (database = %@, query = %@).", database, queryLike);
    queryCached.arguments = [NSArray arrayWithObject:@"S%"];
    STAssertTrue([database executeQuery:queryCached withOptions:SQLDatabaseExecutingOptionCacheStatement thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSLog(@"#%u ----------------------", index);
        NSLog(@"array = %@", [row objects]);
        NSLog(@"dictionary = %@", [row objectsDict]);
    }], @"Execute query failed (database = %@, query = %@).", database, queryLike);

    [database printRuntimeStatusWithResetFlag:NO];
    STAssertTrue([database close], @"Close operation failed (database = %@).", database);
    [database release];
}

- (void)testExecuteFile
{
    NSString *dumpFilePath = [self pathForSQLResource:@"dump_movie"];
    STAssertNotNil(dumpFilePath, @"The path of the dump file must be different than nil.");
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testExecuteFile.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [SQLDatabase databaseWithFilePath:storePath];

    STAssertTrue([database open], @"Open operation failed (database = %@).", database);
    STAssertTrue([database executeSQLFileAtPath:dumpFilePath], @"Execute SQL file failed (database = %@, filePath = %@).", database, dumpFilePath);

    SQLQuery *numberOfActorsQuery = [SQLQuery queryWithStatement:@"SELECT count(*) FROM actors;"];
    __block NSUInteger numberOfActors = 0;

    [database executeQuery:numberOfActorsQuery thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
       if ( index != NSNotFound )
       {
           numberOfActors = (NSUInteger)[row intForColumnAtIndex:0];
       }
    }];
    STAssertEquals(numberOfActors, 9u, @"Invalid number of actors (value = %u, expected = 9).", numberOfActors);

    SQLQuery *numberOfActorsInPulpFictionQuery = [SQLQuery queryWithStatementAndArguments:@"SELECT count(*) FROM act, actors, movies WHERE act.actor_id = actors.id AND act.movie_id = movies.id AND movies.title = ?;", @"Pulp Fiction", nil];
    __block NSUInteger numberOfActorsInPulpFiction = 0;

    [database executeQuery:numberOfActorsInPulpFictionQuery withOptions:SQLDatabaseExecutingOptionCacheStatement thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
       if ( index != NSNotFound )
       {
           numberOfActorsInPulpFiction = (NSUInteger)[row intForColumnAtIndex:0];
       }
    }];
    STAssertEquals(numberOfActorsInPulpFiction, 2u, @"Invalid number of actors playing in 'Pulp Fiction' (value = %u, expected = 2).", numberOfActorsInPulpFiction);

    STAssertTrue([database close], @"Close operation failed (database = %@).", database);
}

- (void)testNotifications
{
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testNotifications.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [SQLDatabase databaseWithFileURL:[NSURL fileURLWithPath:storePath]];

    STAssertTrue([database open], @"Open operation failed (database = %@).", database);

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    id commitObserver = nil;
    __block NSInteger commitNotificationCount = 0;
    NSInteger commitNotificationExpectedCount = 13;

    id rollbackObserver = nil;
    __block NSInteger rollbackNotificationCount = 0;
    NSInteger rollbackNotificationExpectedCount = 1;

    id notificationObserver = nil;
    __block NSInteger notificationCount = 0;
    NSInteger notificationExpectedCount = 9;

    commitObserver = [defaultCenter addObserverForName:kSQLDatabaseCommitNotification object:database queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Received a commit notification (notification = %@)", note);
        commitNotificationCount++;
    }];
    rollbackObserver = [defaultCenter addObserverForName:kSQLDatabaseRollbackNotification object:database queue:nil usingBlock:^(NSNotification *note) {
       NSLog(@"Received a rollback notification (notification = %@)", note);
        rollbackNotificationCount++;
    }];
    [database beginGeneratingNotificationsIntoCenter:defaultCenter];
    notificationObserver = [defaultCenter addObserverForName:[kSQLDatabaseInsertNotification stringByAppendingString:@"main.country"] object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Received an insertion notification (notification = %@)", note);
        notificationCount++;
    }];
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS country(ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, area INTEGER);"], @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Russia", [NSNumber numberWithInteger:17098242], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Canada", [NSNumber numberWithInteger:9984670], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"China", [NSNumber numberWithInteger:9596961], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"United States", [NSNumber numberWithInteger:9522055], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Brazil", [NSNumber numberWithInteger:851487], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Australia", [NSNumber numberWithInteger:7692024], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"India", [NSNumber numberWithInteger:3166414], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Argentina", [NSNumber numberWithInteger:2780400], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Kazakhstan", [NSNumber numberWithInteger:2724900], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(notificationCount == notificationExpectedCount, @"Invalid number of notifications sent (sent = %u, expected = %u)", notificationCount, notificationExpectedCount);
    [defaultCenter removeObserver:notificationObserver];
    notificationObserver = [defaultCenter addObserverForName:[kSQLDatabaseInsertNotification stringByAppendingString:@"main.country"] object:nil queue:nil usingBlock:^(NSNotification *note) {
        STAssertTrue(false, @"This method should not been called, the observer has been removed!");
    }];
    [defaultCenter removeObserver:notificationObserver];
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Algeria", [NSNumber numberWithInteger:2381741], nil]), @"Execute statement failed (database = %@).", database);
    [defaultCenter removeObserver:notificationObserver];
    notificationObserver = [defaultCenter addObserverForName:[kSQLDatabaseDeleteNotification stringByAppendingString:@"main.country"] object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Received a deletion notification (notification = %@)", note);
        notificationCount++;
    }];
    notificationCount = 0;
    notificationExpectedCount = 3;
    STAssertTrue([database executeStatement:@"DELETE FROM country WHERE name LIKE 'A%';"], @"Execute statement failed (database = %@).", database);
    STAssertTrue(notificationCount == notificationExpectedCount, @"Invalid number of notifications sent (sent = %u, expected = %u)", notificationCount, notificationExpectedCount);
    [defaultCenter removeObserver:notificationObserver];
    notificationObserver = [defaultCenter addObserverForName:[kSQLDatabaseUpdateNotification stringByAppendingString:@"main.country"] object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"Received an update notification (notification = %@)", note);
        notificationCount++;
    }];
    notificationCount = 0;
    notificationExpectedCount = 1;
    STAssertTrue([database executeStatement:@"UPDATE country SET area = 8514877 where name = 'Brazil';"], @"Execute statement failed (database = %@).", database);
    [defaultCenter removeObserver:notificationObserver];
    STAssertTrue(notificationCount == notificationExpectedCount, @"Invalid number of notifications sent (sent = %u, expected = %u)", notificationCount, notificationExpectedCount);
    STAssertTrue([database executeStatement:@"BEGIN TRANSACTION;"], @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Democratic Republic of the Congo", [NSNumber numberWithInteger:2344858], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO country(name, area) VALUES(?, ?);", @"Greenland", [NSNumber numberWithInteger:2166086], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue([database executeStatement:@"ROLLBACK TRANSACTION;"], @"Execute statement failed (database = %@).", database);
    [defaultCenter removeObserver:commitObserver];
    [defaultCenter removeObserver:rollbackObserver];
    STAssertTrue(commitNotificationCount == commitNotificationExpectedCount, @"Invalid number of commit notifications sent (sent = %u, expected = %u)", commitNotificationCount, commitNotificationExpectedCount);
    STAssertTrue(rollbackNotificationCount == rollbackNotificationExpectedCount, @"Invalid number of rollback notifications sent (sent = %u, expected = %u)", rollbackNotificationCount, rollbackNotificationExpectedCount);
    [database close];
}

- (void)testAllExecutionTypes
{
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testAllExecutionTypes.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [SQLDatabase databaseWithFilePath:storePath];

    STAssertTrue([database open], @"Open operation failed (database = %@).", database);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS airports(id INTEGER PRIMARY KEY, fullname TEXT, short TEXT, country TEXT);"], @"Execute statement failed (database = %@).", database);

    STAssertTrue([database lastInsertRowID] == nil, @"No insert operation occurred yet, this method should have returned a nil pointer.");
    STAssertTrue([database lastInsertRowID] == nil, @"No insert operation occurred yet, this method should have returned a nil pointer.");

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
                                  nil];

    [insertAirportData enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        insertAirportQuery.arguments = (NSArray *)object;
        STAssertTrue([database executeQuery:insertAirportQuery withOptions:SQLDatabaseExecutingOptionCacheStatement thenEnumerateRowsUsingBlock:NULL], @"Execute query failed (database = %@).", database);
    }];

    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS companies(id INTEGER PRIMARY KEY, name TEXT);"], @"Execute statement failed (database = %@).", database);

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
        STAssertTrue([database executeQuery:insertCompanyQuery withOptions:SQLDatabaseExecutingOptionCacheStatement thenEnumerateRowsUsingBlock:NULL], @"Execute query failed (database = %@).", database);
    }];

    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS flights(id INTEGER PRIMARY KEY, take_off TEXT, landing TEXT, from_id INTEGER, to_id INTERGER, company id INTEGER, FOREIGN KEY(from_id) REFERENCES airports(id), FOREIGN KEY(to_id) REFERENCES airports(id), FOREIGN KEY(company) REFERENCES companies(id));"], @"Execute statement failed (database = %@).", database);

    SQLQuery *insertFlightQuery = [SQLQuery queryWithStatement:@"INSERT INTO flights(take_off, landing, from_id, to_id, company) SELECT ?, ?, a1.id, a2.id, companies.id FROM airports AS a1, airports as a2, companies WHERE a1.fullname = ? AND a2.fullname = ? AND companies.name = ?;"];
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

//                                 [NSArray arrayWithObjects:@"", @"", @"", @"", @"", nil],
//                                 [NSArray arrayWithObjects:@"", @"", @"", @"", @"", nil],
//                                 [NSArray arrayWithObjects:@"", @"", @"", @"", @"", nil],
//                                 [NSArray arrayWithObjects:@"", @"", @"", @"", @"", nil],
//                                 [NSArray arrayWithObjects:@"", @"", @"", @"", @"", nil],
//                                 [NSArray arrayWithObjects:@"", @"", @"", @"", @"", nil],
//                                 [NSArray arrayWithObjects:@"", @"", @"", @"", @"", nil],
//                                 [NSArray arrayWithObjects:@"", @"", @"", @"", @"", nil],
//                                 [NSArray arrayWithObjects:@"", @"", @"", @"", @"", nil],
//                                 [NSArray arrayWithObjects:@"", @"", @"", @"", @"", nil],
                                 nil];

    [insertFlightData enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        insertFlightQuery.arguments = (NSArray *)object;
        STAssertTrue([database executeQuery:insertFlightQuery withOptions:SQLDatabaseExecutingOptionCacheStatement thenEnumerateRowsUsingBlock:NULL], @"Execute query failed (database = %@).", database);
        STAssertEquals(database.numberOfChanges, 1u, @"Insertion failed (query = %@).", insertFlightQuery);
    }];

    STAssertTrue([database close], @"Close operation failed (database = %@).", database);
}

- (void)testStringEncoding
{
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testStringEncoding.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [SQLDatabase databaseWithFilePath:storePath];

    STAssertTrue([database open], @"Open operation failed (database = %@).", database);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS sentences(ID INTEGER PRIMARY KEY, language TEXT, content TEXT);"], @"Execute statement failed (database = %@).", database);

    NSArray *entries = [NSArray arrayWithObjects:
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
    SQLQuery *insertQuery = [SQLQuery queryWithStatement:@"INSERT INTO sentences(language, content) VALUES(?, ?);"];

    [entries enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        insertQuery.arguments = (NSArray *)object;
        STAssertTrue([database executeQuery:insertQuery withOptions:SQLDatabaseExecutingOptionCacheStatement thenEnumerateRowsUsingBlock:NULL], @"Execute statement failed (database = %@).", database);
    }];

    SQLQuery *selectQuery = [SQLQuery queryWithStatement:@"SELECT * FROM sentences;"];

    [database executeQuery:selectQuery thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
        NSString *sentence = [row objectForColumn:@"content"];
        STAssertTrue([sentence isKindOfClass:[NSString class]] == YES, @"Invalid kind of class.");
        STAssertTrue([sentence characterAtIndex:0] == '[', @"Invalid first character.");
        STAssertTrue([sentence characterAtIndex:(sentence.length - 1)], @"Invalid last character.");
    }];
    STAssertTrue([database close], @"Close operation failed (database = %@).", database);
}

- (void)testDataTypes
{
    NSString *storePath = [self generateValidTemporaryPathWithComponent:@"testDataTypes.sqlite"];
    STAssertNotNil(storePath, @"The path generated must be different than nil.");
    SQLDatabase *database = [SQLDatabase databaseWithFilePath:storePath];

    STAssertTrue([database open], @"Open operation failed (database = %@).", database);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS data(ID INTEGER PRIMARY KEY, description TEXT);"], @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO data(description) VALUES(?);", [NSURL URLWithString:@"http://www.apple.com"], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO data(description) VALUES(?);", [NSData data], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO data(description) VALUES(?);", [NSDate date], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO data(description) VALUES(?);", [NSIndexSet indexSetWithIndex:42], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue([database close], @"Close operation failed (database = %@).", database);
}

@end
