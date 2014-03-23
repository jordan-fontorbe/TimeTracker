//
//  TimeTrackerDatabaseCoreData.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTDatabase.h"
#import "TTProject.h"
#import "TTTask.h"
#import "TTTime.h"
#import "TTDataManager.h"
#import "TTRunningTask.h"

@interface TTDatabase ()

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *timetrackerDB;
@property (nonatomic) NSDateFormatter *format;
- (TTTime *)parseTime:(sqlite3_stmt *)stmt withEnd:(bool)end;

@end

@implementation TTDatabase

static TTDatabase* _sharedTTDatabase = nil;

+(TTDatabase*)instance
{
    @synchronized([TTDatabase class])
    {
        if (!_sharedTTDatabase)
            [[self alloc] init];
        return _sharedTTDatabase;
    }
    return nil;
}

+(id)alloc
{
	@synchronized([TTDatabase class])
	{
		NSAssert(_sharedTTDatabase == nil,
                 @"Attempted to allocate a second instance of a singleton.");
		_sharedTTDatabase = [super alloc];
		return _sharedTTDatabase;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
        NSString *docsDir;
        NSArray *dirPaths;
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        // Build the path to the database file
        _databasePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"timetracker.db"]];
        // Date format.
        _format = [[NSDateFormatter alloc] init];
        [_format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	}
    
	return self;
}

- (void)createDatabase
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS PROJECT (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT); CREATE TABLE IF NOT EXISTS task (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, id_project INTEGER); CREATE TABLE IF NOT EXISTS time (id INTEGER PRIMARY KEY AUTOINCREMENT, id_task INTEGER, start DATETIME, end DATETIME);";
            
            if (sqlite3_exec(_timetrackerDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create tables");
            }
            sqlite3_close(_timetrackerDB);
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
}

- (void)clear
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if([filemgr fileExistsAtPath:_databasePath]) {
        [filemgr removeItemAtPath:_databasePath error:nil];
    }
}

- (TTTime *)parseTime:(sqlite3_stmt *)stmt withEnd:(bool)end
{
    TTTime *t = [[TTTime alloc] init];
    [t setIdentifier: sqlite3_column_int(stmt, 0)];
    [t setIdTask: sqlite3_column_int(stmt, 1)];
    NSString *s = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(stmt, 2)];
    [t setStart:[_format dateFromString:s]];
    if(end) {
        s = [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(stmt, 3)];
        [t setEnd:[_format dateFromString:s]];
    }
    return t;
}

- (TTTask *)getTask:(int)identifier
{
    TTTask *res = nil;
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT id, id_project, name FROM task WHERE id=%d", identifier];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                res = [[TTTask alloc] init];
                [res setIdentifier: sqlite3_column_int(statement, 0)];
                [res setIdProject: sqlite3_column_int(statement, 1)];
                [res setName: [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    return res;
}

- (TTTime *)getTime:(int)identifier
{
    TTTime *res = nil;
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT id, id_task, start, end FROM time WHERE id=%d", identifier];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                res = [self parseTime:statement withEnd:YES];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    return res;
    
}

- (NSArray *)getTimesFor:(int)task
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT id, id_task, start, end FROM time WHERE id_task=%d", task];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                TTTime *time = [self parseTime:statement withEnd:YES];
                [res addObject:time];
            }
            sqlite3_finalize(statement);            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    // Add the running task.
    TTRunningTask *t = [[TTDataManager instance] getRunningTaskFor:task];
    if(t != nil) {
        [res addObject:t];
    }
    return res;
    
}

- (TTProject *)getProject:(int)identifier
{
    TTProject *res = nil;
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT id, name FROM project WHERE id=%d", identifier];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                res = [[TTProject alloc] init];
                [res setIdentifier: sqlite3_column_int(statement, 0)];
                [res setName: [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    return res;
}

- (NSArray *)getProjects
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT id, name FROM project"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                TTProject *myProject = [[TTProject alloc] init];
                [myProject setIdentifier: sqlite3_column_int(statement, 0)];
                [myProject setName: [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]];
                [res addObject:myProject];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    
    return res;
}

- (NSDictionary *)getTasks
{
    NSMutableDictionary *res = [[NSMutableDictionary alloc] init];
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT id, id_project, name FROM task"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                TTTask *myTask = [[TTTask alloc] init];
                [myTask setIdentifier: sqlite3_column_int(statement, 0)];
                [myTask setIdProject: sqlite3_column_int(statement, 1)];
                [myTask setName: [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)]];
                NSNumber *idProject = [NSNumber numberWithInt:[myTask idProject]];
                NSMutableArray *a = [res objectForKey:idProject];
                if (a == nil) {
                    a = [[NSMutableArray alloc] init];
                    [res setObject:a forKey:idProject];
                }
                [a addObject:myTask];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    
    return res;
}

- (int)insertTask:(TTTask *)newTask
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    int insertedId = 0;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO task(id_project, name) VALUES (\"%d\", \"%@\")", [newTask idProject], [newTask name]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                insertedId = sqlite3_last_insert_rowid(_timetrackerDB);
                [newTask setIdentifier:insertedId];
                NSLog(@"Insert Task : OK");
            }
            else {
                NSLog(@"Insert Task : KO");
            }
            sqlite3_reset(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    return insertedId;
}

- (int)insertTime:(TTTime *)newTime
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    int insertedId = 0;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *startString = [_format stringFromDate:[newTime start]];
        NSString *endString = [_format stringFromDate:[newTime end]];
        NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO time(id_task, start, end) VALUES (\"%d\", \"%@\", \"%@\")", [newTime idTask], startString, endString];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                insertedId = sqlite3_last_insert_rowid(_timetrackerDB);
                [newTime setIdentifier:insertedId];
                NSLog(@"Insert Time : OK");
            }
            else {
                NSLog(@"Insert Time : KO");
            }
            sqlite3_reset(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    return insertedId;
}

- (int)insertProject:(TTProject *)newProject
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    int insertedId = 0;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO project(name) VALUES (\"%@\")", [newProject name]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                insertedId = sqlite3_last_insert_rowid(_timetrackerDB);
                [newProject setIdentifier:insertedId];
                NSLog(@"Insert Project : OK");
            }
            else {
                NSLog(@"Insert Project : KO");
            }
            sqlite3_reset(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    return insertedId;
}

- (void)updateTask:(TTTask *)updateTask
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE task SET id_project = %d, name = \"%@\" WHERE id = %d", [updateTask idProject], [updateTask name], [updateTask identifier]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Update Task : OK");
            }
            else {
                NSLog(@"Update Task : KO");
            }
            sqlite3_reset(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    
}
- (void)updateTime:(TTTime *)updateTime
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *startString = [_format stringFromDate:[updateTime start]];
        NSString *endString = [updateTime end] == nil ? nil : [_format stringFromDate:[updateTime end]];
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE time SET id_task = %d, start = \"%@\", end = \"%@\" WHERE id = %d", [updateTime idTask], startString, endString, [updateTime identifier]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Update Time : OK");
            }
            else {
                NSLog(@"Update Time : KO");
            }
            sqlite3_reset(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
}
- (void)updateProject:(TTProject *)updateProject
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE project SET name = \"%@\" WHERE id = %d", [updateProject name], [updateProject identifier]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Update Project : OK");
            }
            else {
                NSLog(@"Update Project : KO");
            }
            sqlite3_reset(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
}

- (void)deleteProject:(TTProject *)project
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM time WHERE id_task IN (SELECT id FROM task WHERE id_project = %d); DELETE FROM task WHERE id_project = %d ; DELETE FROM project WHERE id = %d", [project identifier], [project identifier],[project identifier]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        while (strlen(query_stmt) > 0 && sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, &query_stmt) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Delete Project : OK");
            }
            else {
                NSLog(@"Delete Project : KO");
            }
            sqlite3_reset(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
}

- (void)deleteTask:(TTTask *)task
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM time WHERE id_task = %d ; DELETE FROM task WHERE id = %d", [task identifier], [task identifier]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        while (strlen(query_stmt) > 0 && sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, &query_stmt) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Delete Task : OK");
            }
            else {
                NSLog(@"Delete Task : KO");
            }
            sqlite3_reset(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    
}

- (void)deleteTime:(TTTime *)time
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM time WHERE id = %d", [time identifier]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Delete Time : OK");
            }
            else {
                NSLog(@"Delete Time : KO");
            }
            sqlite3_reset(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    
}

- (NSArray *)getTasksFor:(int)project
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT id, id_project, name FROM task WHERE id_project = %d", project];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                TTTask *myTask = [[TTTask alloc] init];
                [myTask setIdentifier: sqlite3_column_int(statement, 0)];
                [myTask setIdProject: sqlite3_column_int(statement, 1)];
                [myTask setName: [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)]];
                [res addObject:myTask];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    return res;
}

- (NSArray *)getTasksFrom:(NSDate *)from To:(NSDate *)to For:(int)project
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *startString = [_format stringFromDate:from];
        NSString *endString = [_format stringFromDate:to];
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ta.id, ta.id_project, ta.name FROM task ta INNER JOIN time ti ON ti.id_task = ta.id WHERE ta.id_project = %d AND ti.start >= \"%@\" AND ti.end >= \"%@\"", project, startString, endString];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                TTTask *myTask = [[TTTask alloc] init];
                [myTask setIdentifier: sqlite3_column_int(statement, 0)];
                [myTask setIdProject: sqlite3_column_int(statement, 1)];
                [myTask setName: [[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)]];
                [res addObject:myTask];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    
    return res;
}

- (NSString *)getTotalTimeStringFormatted
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    NSDate *date = nil;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT (julianday(SUM(julianday(ti.end) - julianday(ti.start)))) * 86400.0 FROM time ti "];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                double dTime = sqlite3_column_double(statement, 0);
                date = [NSDate dateWithTimeIntervalSince1970:dTime];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    
    if (date != nil){
        // Add running times.
        NSArray *a = [self getRunningTimes];
        for(TTTime *t in a) {
            date = [[NSCalendar currentCalendar] dateByAddingComponents:[t durationComponentsFromStartToNow] toDate:date options:0];
        }
        NSUInteger seconds = (NSUInteger)round([date timeIntervalSince1970]);
        return [NSString stringWithFormat:@"%02u:%02u", seconds / 3600, (seconds / 60) % 60];
    }
    else {
        return @"00:00";
    }
    
}

- (NSString *)getTotalProjectTimeStringFormatted:(NSInteger) idProject
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    NSDate *date = nil;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT (julianday(SUM(julianday(ti.end) - julianday(ti.start)))) * 86400.0 FROM time ti JOIN task ta ON ta.id = ti.id_task WHERE ta.id_project = %d", idProject];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                double dTime = sqlite3_column_double(statement, 0);
                date = [NSDate dateWithTimeIntervalSince1970:dTime];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    
    if (date != nil){
        // Add running times.
        NSArray *a = [self getRunningTimesFor:idProject];
        for(TTTime *t in a) {
            date = [[NSCalendar currentCalendar] dateByAddingComponents:[t durationComponentsFromStartToNow] toDate:date options:0];
        }
        NSUInteger seconds = (NSUInteger)round([date timeIntervalSince1970]);
        return [NSString stringWithFormat:@"%02u:%02u", seconds / 3600, (seconds / 60) % 60];
    }
    else {
        return @"00:00";
    }
}

- (NSString *)getTotalTaskTimeStringFormatted:(NSInteger) idTask
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    NSDate *date = nil;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT (julianday(SUM(julianday(ti.end) - julianday(ti.start)))) * 86400.0 FROM time ti WHERE ti.id_task = %d", idTask];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                double dTime = sqlite3_column_double(statement, 0);
                date = [NSDate dateWithTimeIntervalSince1970:dTime];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    
    if (date != nil){
        // Add the running task.
        TTRunningTask *t = [[TTDataManager instance] getRunningTaskFor:idTask];
        if(t != nil) {
            date = [[NSCalendar currentCalendar] dateByAddingComponents:[t durationComponentsFromStartToNow] toDate:date options:0];
        }
        // Convert to string.
        NSUInteger seconds = (NSUInteger)round([date timeIntervalSince1970]);
        return [NSString stringWithFormat:@"%02u:%02u", seconds / 3600, (seconds / 60) % 60];
    }
    else {
        return @"00:00";
    }
}

- (NSArray *)getRunningTimes
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    NSMutableArray *a = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT id, id_task, start FROM time WHERE end = '(null)'"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                TTTime *t = [self parseTime:statement withEnd:NO];
                [a addObject:t];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    
    return a;
}

- (NSArray *)getRunningTimesFor:(int)project
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    NSMutableArray *a = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ti.id, ti.id_task, ti.start FROM time ti JOIN task ta ON ta.id = ti.id_task WHERE ta.id_project = %d AND ti.end = '(null)'", project];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                TTTime *t = [self parseTime:statement withEnd:NO];
                [a addObject:t];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    
    return a;
}

- (TTTime *)getRunningTimeFor:(int)task
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    TTTime *t = nil;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT id, id_task, start FROM time WHERE id_task = %d AND end = '(null)' LIMIT 0, 1", task];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                t = [self parseTime:statement withEnd:NO];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    
    return t;
}

- (bool)isTaskRunning:(int)task
{
    return [self getRunningTimeFor:task] != nil;
}

- (void)runTask:(int)task
{
    TTTime *t = [self getRunningTimeFor:task];
    if(t) {
        [t setEnd:[NSDate date]];
        [self updateTime:t];
    } else {
        [self insertTime:[[TTTime alloc] initWithStart:[NSDate date] end:nil task:task]];
    }
}

- (NSString *)getAllTimesCSVFormat;
{
    NSString *res = @"Project;Task;Start;End";
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT p.name, ta.name, ti.start, ti.end FROM time ti JOIN task ta ON ti.id_task = ta.id LEFT OUTER JOIN project p ON p.id = ta.id_project "];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                res = [res stringByAppendingString:@"\n\r"];
                char *projectName = sqlite3_column_text(statement, 0);
                if (projectName == nil) {
                    res = [res stringByAppendingString:@"Single Tasks"];
                }
                else {
                    res = [res stringByAppendingString:[[NSString alloc]initWithUTF8String:(const char *) projectName]];
                }
                
                res = [res stringByAppendingString:@";"];
                res = [res stringByAppendingString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]];
                res = [res stringByAppendingString:@";"];
                res = [res stringByAppendingString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)]];
                res = [res stringByAppendingString:@";"];
                res = [res stringByAppendingString:[[NSString alloc]initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    return res;

}

@end
