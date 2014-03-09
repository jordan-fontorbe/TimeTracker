//
//  TimeTrackerDatabaseCoreData.m
//  TimeTracker
//
//  Created by Jérémy Morosi on 06/03/2014.
//  Copyright (c) 2014 Jojeredamyn. All rights reserved.
//

#import "TTDatabaseCoreData.h"
#import "TTProject.h"
#import "TTTask.h"
#import "TTTime.h"

@implementation TTDatabaseCoreData

- (void)createDatabase
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"timetracker.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS PROJECT (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT); CREATE TABLE IF NOT EXISTS TASK (ID INTEGER PRIMARY KEY AUTOINCREMENT, ID_PROJECT INTEGER); CREATE TABLE IF NOT EXISTS TIME (ID INTEGER PRIMARY KEY AUTOINCREMENT, ID_TASK INTEGER, START DATETIME, END DATETIME);";
            
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

- (TTTask *)getTask:(int)identifier
{
    TTTask *res = nil;
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT id, id_project, name FROM tasks WHERE id=%d", identifier];
        
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
                res = [[TTTime alloc] init];
                [res setIdentifier: sqlite3_column_int(statement, 0)];
                [res setIdTask: sqlite3_column_int(statement, 1)];
                double dTime = sqlite3_column_double(statement, 2);
                [res setStart:[NSDate dateWithTimeIntervalSince1970:dTime]];
                dTime = sqlite3_column_double(statement, 3);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
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

- (NSArray *)getTasks
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
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
                [res addObject:myTask];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
    
    return res;
}

- (void)insertTask:(TTTask *)newTask
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO task(id_project, name) VALUES (\"%d\", \"%@\")", [newTask idProject], [newTask name]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Insert Task : OK");
            }
            else {
                NSLog(@"Insert Task : KO");
            }
            sqlite3_reset(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
}

- (void)insertTime:(TTTime *)newTime
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *startString = [format stringFromDate:[newTime start]];
        NSString *endString = [format stringFromDate:[newTime end]];
        NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO time(id_task, start, end) VALUES (\"%d\", \"%@\", \"%@\")", [newTime idTask], startString, endString];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Insert Time : OK");
            }
            else {
                NSLog(@"Insert Time : KO");
            }
            sqlite3_reset(statement);
        }
        sqlite3_close(_timetrackerDB);
    }
}

- (void)insertProject:(TTProject *)newProject
{
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO project(name) VALUES (\"%@\")", [newProject name]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Insert Project : OK");
            }
            else {
                NSLog(@"Insert Project : KO");
            }
            sqlite3_reset(statement);
        }
        sqlite3_close(_timetrackerDB);
    }

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
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *startString = [format stringFromDate:[updateTime start]];
        NSString *endString = [format stringFromDate:[updateTime end]];
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
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM project WHERE id = %d", [project identifier]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
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
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM task WHERE id = %d", [task identifier]];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_timetrackerDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
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

- (NSArray *)getTasksFrom:(NSDate *)from To:(NSDate *)to For:(TTProject *)project
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_timetrackerDB) == SQLITE_OK)
    {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *startString = [format stringFromDate:from];
        NSString *endString = [format stringFromDate:to];
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ta.id, ta.id_project, ta.name FROM task ta INNER JOIN time ti ON ti.id_task = ta.id WHERE ta.id_project = %d AND ti.start >= \"%@\" AND ti.end >= \"%@\"", [project identifier], startString, endString];
        
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

@end
