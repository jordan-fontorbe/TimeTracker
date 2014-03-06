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
                // @"Failed to create tables"
            }
            sqlite3_close(_timetrackerDB);
        } else {
            // @"Failed to open/create database"
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
    return nil;
}

- (TTProject *)getProject:(int)identifier
{
    return nil;
}

- (NSArray *)getProjects
{
    return nil;
}

- (NSArray *)getTasks
{
    return nil;
}

- (void)insertTask:(TTTask *)newTask
{
}

- (void)insertTime:(TTTime *)newTime
{
}

- (void)insertProject:(TTProject *)newProject
{
}

- (void)updateTask:(TTTask *)updateTask
{
}
- (void)updateTime:(TTTime *)updateTime
{
}
- (void)updateProject:(TTProject *)updateProject
{
}

- (void)deleteProject:(TTProject *)project
{
}

- (void)deleteTask:(TTTask *)task
{
}

- (void)deleteTime:(TTTime *)time
{
}

- (NSArray *)getTasksFrom:(NSDate *)from To:(NSDate *)to For:(TTProject *)project
{
    return nil;
}

@end
