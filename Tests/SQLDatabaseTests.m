/*
 Copyright (c) 2012 Alexandre Laborie

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "SQLDatabaseTests.h"
#import "SQLDatabase.h"
#import "SQLQuery.h"
#import "SQLRow.h"

@implementation SQLDatabaseTests

- (void)testLifeCycle
{
    SQLDatabase *database = [[SQLDatabase alloc] init];

    [database open];
    [database close];
    [database release];
}

- (void)testLifeCycleAdvanced
{
    NSString *databaseLocalPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"foo.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;

    [fileManager removeItemAtPath:databaseLocalPath error:&error];
    if ( error != nil && error.code != NSFileNoSuchFileError )
    {
        STAssertNil(error, [error localizedDescription]);
    }

    SQLDatabase *database = [[SQLDatabase alloc] initWithPath:databaseLocalPath];
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
    NSError *error = nil;
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"movie-db.sql"];
    NSString *databaseDump = @"\
    PRAGMA foreign_keys=OFF;\
    BEGIN TRANSACTION;\
    CREATE TABLE movies(ID INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, rating INTEGER);\
    INSERT INTO movies VALUES(1,'The Shawshank Redemption',9.2);\
    INSERT INTO movies VALUES(2,'The Godfather',9.2);\
    INSERT INTO movies VALUES(3,'The Godfather: Part II',9);\
    INSERT INTO movies VALUES(4,'The Good, the Bad and the Ugly',8.9);\
    INSERT INTO movies VALUES(5,'Pulp Fiction',8.9);\
    CREATE TABLE actors(ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);\
    INSERT INTO actors VALUES(1,'Morgan Freeman');\
    INSERT INTO actors VALUES(2,'Tim Robbins');\
    INSERT INTO actors VALUES(3,'Marlon Brando');\
    INSERT INTO actors VALUES(4,'Al Pacino');\
    INSERT INTO actors VALUES(5,'Robert Duvall');\
    INSERT INTO actors VALUES(6,'Eli Wallach');\
    INSERT INTO actors VALUES(7,'Clint Eastwood');\
    INSERT INTO actors VALUES(8,'John Travolta');\
    INSERT INTO actors VALUES(9,'Samuel L. Jackson');\
    CREATE TABLE act(movie_ID INTEGER, actor_ID INTEGER);\
    INSERT INTO act VALUES(1,1);\
    INSERT INTO act VALUES(1,2);\
    INSERT INTO act VALUES(2,3);\
    INSERT INTO act VALUES(2,4);\
    INSERT INTO act VALUES(3,4);\
    INSERT INTO act VALUES(3,5);\
    INSERT INTO act VALUES(4,6);\
    INSERT INTO act VALUES(4,7);\
    INSERT INTO act VALUES(5,8);\
    INSERT INTO act VALUES(5,9);\
    DELETE FROM sqlite_sequence;\
    INSERT INTO sqlite_sequence VALUES('movies',5);\
    INSERT INTO sqlite_sequence VALUES('actors',9);\
    COMMIT;";

    [databaseDump writeToFile:filePath atomically:YES encoding:NSASCIIStringEncoding error:&error];
    STAssertNil(error, [error localizedDescription]);

    NSString *databaseLocalPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"movie.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    [fileManager removeItemAtPath:databaseLocalPath error:&error];
    if ( error != nil && error.code != NSFileNoSuchFileError )
    {
        STAssertNil(error, [error localizedDescription]);
    }

    SQLDatabase *movieDatabase = [SQLDatabase databaseWithPath:databaseLocalPath];

    STAssertTrue([movieDatabase open], @"Open operation failed (database = %@).", movieDatabase);
    STAssertTrue([movieDatabase executeSQLFileAtPath:filePath], @"Execute SQL file failed (database = %@, filePath = %@).", movieDatabase, filePath);
    STAssertTrue([movieDatabase close], @"Close operation failed (database = %@).", movieDatabase);
}

- (void)testNotifications
{
    NSString *databaseLocalPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"observation.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;

    [fileManager removeItemAtPath:databaseLocalPath error:&error];
    if ( error != nil && error.code != NSFileNoSuchFileError )
    {
        STAssertNil(error, [error localizedDescription]);
    }

    SQLDatabase *database = [SQLDatabase databaseWithURL:[NSURL URLWithString:databaseLocalPath]];

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
    NSString *databaseLocalPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"travel.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;

    [fileManager removeItemAtPath:databaseLocalPath error:&error];
    if ( error != nil && error.code != NSFileNoSuchFileError )
    {
        STAssertNil(error, [error localizedDescription]);
    }

    SQLDatabase *database = [SQLDatabase databaseWithPath:databaseLocalPath];

    STAssertTrue([database open], @"Open operation failed (database = %@).", database);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS airports(ID INTEGER PRIMARY KEY, fullname TEXT, short TEXT, country TEXT);"], @"Execute statement failed (database = %@).", database);

    STAssertTrue([database lastInsertRowID] == nil, @"No insert operation occurred yet, this method should have returned a nil pointer.");
    STAssertTrue([database lastInsertRowID] == nil, @"No insert operation occurred yet, this method should have returned a nil pointer.");

    SQLQuery *insertAirportQuery = [SQLQuery queryWithStatement:@"INSERT INTO airports(fullname, short) VALUES(?, ?);"];
    NSArray *insertAirportData = [NSArray arrayWithObjects:
                                  [NSArray arrayWithObjects:@"San Francisco", @"SFO", nil],
                                  [NSArray arrayWithObjects:@"Atlanta", @"ATL", nil],
                                  [NSArray arrayWithObjects:@"Beijing", @"PEK", nil],
                                  [NSArray arrayWithObjects:@"Boston", @"BOS", nil],
                                  [NSArray arrayWithObjects:@"Buenos Aires", @"BUE", nil],
                                  [NSArray arrayWithObjects:@"Charlotte", @"CLT", nil],
                                  [NSArray arrayWithObjects:@"Los Angeles", @"LAX", nil],
                                  [NSArray arrayWithObjects:@"Honolulu", @"HNL", nil],
                                  [NSArray arrayWithObjects:@"Portland", @"PDX", nil],
                                  [NSArray arrayWithObjects:@"Paris", @"CDG", nil],
                                  [NSArray arrayWithObjects:@"Denver", @"DEN", nil],
                                  [NSArray arrayWithObjects:@"Seatle", @"SEA", nil],
                                  [NSArray arrayWithObjects:@"Sydney", @"SYD", nil],
                                  [NSArray arrayWithObjects:@"Brisbane", @"BNE", nil],
                                  [NSArray arrayWithObjects:@"Kuala Lumpur", @"KUL", nil],
                                  [NSArray arrayWithObjects:@"Berlin", @"BER", nil],
                                  [NSArray arrayWithObjects:@"London", @"LHR", nil],
                                  [NSArray arrayWithObjects:@"Madrid", @"MAD", nil],
                                  [NSArray arrayWithObjects:@"Rome", @"ROM", nil],
                                  [NSArray arrayWithObjects:@"Prague", @"PRG", nil],
                                  [NSArray arrayWithObjects:@"Wellington", @"WLG", nil],
                                  [NSArray arrayWithObjects:@"Amsterdam", @"AMS", nil],
                                  [NSArray arrayWithObjects:@"Athens", @"ATH", nil],
                                  [NSArray arrayWithObjects:@"Austin", @"AUS", nil],
                                  [NSArray arrayWithObjects:@"Barcelona", @"BCN", nil],
                                  [NSArray arrayWithObjects:@"Bangkok", @"BKK", nil],
                                  [NSArray arrayWithObjects:@"Baltimore", @"BWI", nil],
                                  [NSArray arrayWithObjects:@"Chicago", @"CHI", nil],
                                  [NSArray arrayWithObjects:@"Colombus", @"CMH", nil],
                                  [NSArray arrayWithObjects:@"Cleveland", @"CLV", nil],
                                  [NSArray arrayWithObjects:@"El Paso", @"ELP", nil],
                                  [NSArray arrayWithObjects:@"Florence", @"FLR", nil],
                                  [NSArray arrayWithObjects:@"Ouagadougou", @"OUA", nil],
                                  [NSArray arrayWithObjects:@"Guatemala", @"GUA", nil],
                                  [NSArray arrayWithObjects:@"Geneva", @"GVA", nil],
                                  [NSArray arrayWithObjects:@"Hong Kong", @"HKG", nil],
                                  [NSArray arrayWithObjects:@"Helsinki", @"HEL", nil],
                                  [NSArray arrayWithObjects:@"Istanbul", @"IST", nil],
                                  [NSArray arrayWithObjects:@"Kiev", @"KBP", nil],
                                  [NSArray arrayWithObjects:@"Lima", @"LIM", nil],
                                  [NSArray arrayWithObjects:@"Miami", @"MIA", nil],
                                  [NSArray arrayWithObjects:@"Munich", @"MUC", nil],
                                  [NSArray arrayWithObjects:@"Reno", @"RNO", nil],
                                  [NSArray arrayWithObjects:@"Ulaanbaatar", @"ULN", nil],
                                  [NSArray arrayWithObjects:@"Zurich", @"ZRH", nil],
                                  [NSArray arrayWithObjects:@"Zagreb", @"ZAG", nil],
                                  [NSArray arrayWithObjects:@"La Paz", @"LAP", nil],
                                  [NSArray arrayWithObjects:@"Darwin", @"DRW", nil],
                                  [NSArray arrayWithObjects:@"Tunis", @"TUN", nil],
                                  [NSArray arrayWithObjects:@"Djibouti", @"JIB", nil],
                                  [NSArray arrayWithObjects:@"Singapore", @"SIN", nil],
                                  [NSArray arrayWithObjects:@"Bamako", @"BKO", nil],
                                  [NSArray arrayWithObjects:@"Marrakesh", @"RAK", nil],
                                  [NSArray arrayWithObjects:@"Casablanca", @"CMN", nil],
                                  [NSArray arrayWithObjects:@"Cotonou", @"COO", nil],
                                  [NSArray arrayWithObjects:@"Abidjan", @"ABJ", nil],
                                  nil];

    [insertAirportData enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        insertAirportQuery.arguments = (NSArray *)object;
        STAssertTrue([database executeQuery:insertAirportQuery withOptions:SQLDatabaseExecutingOptionCacheStatement thenEnumerateRowsUsingBlock:NULL], @"Execute query failed (database = %@).", database);
    }];







//    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS flights(ID INTEGER PRIMARY KEY, flight_number INTEGER, airline TEXT, from_airport TEXT, to_airport TEXT, arrival_time TEXT, remarks TEXT DEFAULT NULL);"], @"Execute statement failed (database = %@).", database);
//
//
//
//    SQLQuery *insertAiportQuery = [SQLQuery queryWithStatement:@"INSERT INTO airports(name, code) VALUES(?, ?);"];
//    NSArray *insertAirportData = [NSArray arrayWithObjects:
//                                  [NSArray arrayWithObjects:@""
//
//
//
//    SQLQuery *insertQuery = [SQLQuery queryWithStatement:@"INSERT INTO flights(flight_number, airline, from_airport, to_airport, arrival_time, remarks) VALUES(?, ?, ?, ?, ?, ?)"];
//    NSArray *insertData = [NSArray arrayWithObjects:
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:5303], @"AeroMexico", @"Atlanta", @"San Francisco", @"6:56 PM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:8888], @"Air China", @"Beijing", @"San Francisco", @"9:09 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:8703], @"Air China", @"Boston", @"San Francisco", @"9:20 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:8705], @"Air China", @"Boston", @"San Francisco", @"11:24 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:8720], @"Air China", @"Buenos Aires", @"San Francisco", @"2:23 PM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:8526], @"Air China", @"Charlotte", @"San Francisco", @"12:25 PM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:8717], @"Air China", @"Honolulu", @"San Francisco", @"7:34 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:8704], @"Air China", @"Los Angeles", @"San Francisco", @"2:55 PM", @"On Time", nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:8710], @"Air China", @"Orlando", @"San Francisco", @"8:58 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:8739], @"Air China", @"Portland", @"San Francisco", @"10:52 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:8741], @"Air China", @"Portland", @"San Francisco", @"11:11 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:8732], @"Air China", @"Minneapolis", @"San Francisco", @"8:01 PM", @"On Time", nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:8734], @"Air China", @"Denver", @"San Francisco", @"11:43 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:8879], @"Air China", @"Denver", @"San Francisco", @"11:33 AM", [NSNull null], nil],
//
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:9027], @"Air France", @"Los Angeles", @"San Francisco", @"6:11 PM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:8400], @"Air France", @"Paris", @"San Francisco", @"2:38 PM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:9400], @"Air France", @"Salt Lake City", @"San Francisco", @"5:56 PM", [NSNull null], nil],
//
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:8879], @"Air New Zealand", @"Auckland", @"San Francisco", @"10:13 AM", [NSNull null], nil],
//
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:317], @"Alaska Airlines", @"Palm Springs", @"San Francisco", @"6:57 PM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:2523], @"Alaska Airlines", @"Portland", @"San Francisco", @"8:40 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:234], @"Alaska Airlines", @"Portland", @"San Francisco", @"12:11 PM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:231], @"Alaska Airlines", @"Puerto Vallarta", @"San Francisco", @"8:57 PM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:304], @"Alaska Airlines", @"Seattle", @"San Francisco", @"8:48 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:220], @"Alaska Airlines", @"Seattle", @"San Francisco", @"11:52 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:312], @"Alaska Airlines", @"Seattle", @"San Francisco", @"3:04 PM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:316], @"Alaska Airlines", @"Seattle", @"San Francisco", @"4:07 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:302], @"Alaska Airlines", @"Seattle", @"San Francisco", @"8:06 AM", [NSNull null], nil],
//
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:2049], @"Delta", @"Atlanta", @"San Francisco", @"10:28 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:2049], @"Delta", @"Atlanta", @"San Francisco", @"10:28 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:2049], @"Delta", @"Atlanta", @"San Francisco", @"10:28 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:2049], @"Delta", @"Atlanta", @"San Francisco", @"10:28 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:2049], @"Delta", @"Atlanta", @"San Francisco", @"10:28 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:2049], @"Delta", @"Atlanta", @"San Francisco", @"10:28 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:2049], @"Delta", @"Atlanta", @"San Francisco", @"10:28 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:2049], @"Delta", @"Atlanta", @"San Francisco", @"10:28 AM", [NSNull null], nil],
//                           [NSArray arrayWithObjects:[NSNumber numberWithInteger:2049], @"Delta", @"Atlanta", @"San Francisco", @"10:28 AM", [NSNull null], nil],
//
//
//
//                           /**
//
//                            AIRLINE	ARRIVING FROM	FLIGHT #	SCH. TIME	EST. TIME	REMARKS	TERMINAL	GATE	DETAILS
//                            Delta Airlines	Atlanta	2049	10:30 AM	10:28 AM	 On Time	1	42	view
//                            Delta Airlines	Atlanta	1680	1:32 PM	3:02 PM	 Now at 3:02 PM	1	40	view
//                            Delta Airlines	Atlanta	1151	4:04 PM	4:04 PM	 On Time	1	40	view
//                            Delta Airlines	Atlanta	1849	7:03 PM	7:03 PM	 On Time	1	47	view
//                            Delta Airlines	Cincinnati	1679	11:06 AM	11:11 AM	 Now at 11:11 AM	1	45B	view
//                            Delta Airlines	Detroit	745	11:09 AM	11:08 AM	 On Time	1	45A	view
//                            Delta Airlines	Detroit	1145	6:09 PM	6:09 PM	 On Time	1	45B	view
//                            Delta Airlines	London/Heathrow	4	7:16 PM	7:16 PM	 On Time	1	45A	view
//                            Delta Airlines	Los Angeles	4708	8:10 AM	8:17 AM	Arrived at 8:11 AM	1	48	view
//                            Delta Airlines	Los Angeles	4771	9:14 AM	10:20 AM	 Now at 10:20 AM	1	48	view
//                            Delta Airlines	Los Angeles	4663	10:14 AM	10:14 AM	Cancelled	1	48	view
//                            Delta Airlines	Los Angeles	4784	1:15 PM	1:15 PM	 On Time	1	48	view
//                            Delta Airlines	Los Angeles	4720	2:15 PM	2:15 PM	 On Time	1	48	view
//                            Delta Airlines	Los Angeles	4678	4:03 PM	4:03 PM	 On Time	1	48	view
//                            Delta Airlines	Los Angeles	4795	5:11 PM	5:11 PM	Cancelled	1	48	view
//                            Delta Airlines	Los Angeles	4780	6:11 PM	6:11 PM	 On Time	1	48	view
//                            Delta Airlines	Los Angeles	4440	8:15 PM	8:15 PM	 On Time	1	44	view
//                            Delta Airlines	Los Angeles	4577	12:15 PM	12:15 PM	Cancelled	1	48	view
//                            Delta Airlines	Minneapolis	2305	11:37 AM	12:39 PM	 Now at 12:39 PM	1	44	view
//                            Delta Airlines	Minneapolis	2105	1:51 PM	2:29 PM	 Now at 2:29 PM	1	45A	view
//                            Delta Airlines	Minneapolis	979	4:53 PM	4:53 PM	 On Time	1	42	view
//                            Delta Airlines	Minneapolis	1505	7:45 PM	7:45 PM	 On Time	1
//                            Delta Airlines	New York/JFK	1865	10:40 AM	10:24 AM	 Now at 10:24 AM	1	47	view
//                            Delta Airlines	New York/JFK	1765	1:32 PM	1:16 PM	 Now at 1:16 PM	1	45B	view
//                            Delta Airlines	New York/JFK	4	7:16 PM	7:16 PM	 On Time	1	45A	view
//                            Delta Airlines	New York/JFK	1565	9:06 PM	9:06 PM	 On Time	1
//                            */
//
//
//                           nil];


//    SQLQuery *insertFlightQuery = [SQLQuery queryWithStatementAndArguments:@"INSERT INTO flights(flight_number, airline, from_airport, to_airport, arrival_time, remarks) VALUES(?, ?, ?, ?, ?, ?)",
//                                   [NSNumber numberWithInteger:5303],
//                                   @"AeroMexico",
//                                   @"ATL",
//                                   @"SFO",
//                                   @"6:56 PM",
//                                   [NSNull null],
//                                   nil];
//
//    STAssertNotNil(insertFlightQuery, @"Query creation failed.");
//    STAssertTrue([database executeQuery:insertFlightQuery withOptions:SQLDatabaseExecutingOptionCacheStatement thenEnumerateRowsUsingBlock:NULL], @"Execute statement failed (database = %@).", database);
//    STAssertTrue([[database lastInsertRowID] isEqualToNumber:[NSNumber numberWithLongLong:1]] == YES, @"Invalid row ID returned.");
//    STAssertTrue([[database lastInsertRowID] isEqualToNumber:[NSNumber numberWithLongLong:1]] == YES, @"Invalid row ID returned.");
//
//    SQLQuery *flightExistsQuery = [SQLQuery queryWithStatement:@"SELECT 1 FROM flights WHERE ID = last_insert_rowid();"];
//    __block BOOL insertedRowExists = NO;
//
//    STAssertNotNil(insertFlightQuery, @"Query creation failed.");
//    STAssertTrue([database executeQuery:flightExistsQuery thenEnumerateRowsUsingBlock:^(SQLRow *row, NSInteger index, BOOL *stop) {
//        insertedRowExists = YES;
//    }], @"Execute statement failed (database = %@).", database);
//
    STAssertTrue([database close], @"Close operation failed (database = %@).", database);
}

- (void)testStringEncoding
{
    NSString *databaseLocalPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"encoding.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;

    [fileManager removeItemAtPath:databaseLocalPath error:&error];
    if ( error != nil && error.code != NSFileNoSuchFileError )
    {
        STAssertNil(error, [error localizedDescription]);
    }

    SQLDatabase *database = [SQLDatabase databaseWithPath:databaseLocalPath];

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
    NSString *databaseLocalPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"data.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;

    [fileManager removeItemAtPath:databaseLocalPath error:&error];
    if ( error != nil && error.code != NSFileNoSuchFileError )
    {
        STAssertNil(error, [error localizedDescription]);
    }

    SQLDatabase *database = [SQLDatabase databaseWithPath:databaseLocalPath];

    STAssertTrue([database open], @"Open operation failed (database = %@).", database);
    STAssertTrue([database executeStatement:@"CREATE TABLE IF NOT EXISTS data(ID INTEGER PRIMARY KEY, description TEXT);"], @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO data(description) VALUES(?);", [NSURL URLWithString:@"http://www.apple.com"], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO data(description) VALUES(?);", [NSData data], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO data(description) VALUES(?);", [NSDate date], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue(([database executeStatementWithArguments:@"INSERT INTO data(description) VALUES(?);", [NSIndexSet indexSetWithIndex:42], nil]), @"Execute statement failed (database = %@).", database);
    STAssertTrue([database close], @"Close operation failed (database = %@).", database);
}

@end
