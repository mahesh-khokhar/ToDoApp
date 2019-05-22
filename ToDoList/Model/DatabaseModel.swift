//
//  DatabaseModel.swift
//  ToDoList
//
//  Created by MK on 21/05/19.
//

let DB_TODO                                 = "TODO.sqlite"

let TBL_TODO_MST                            = "TODO_MST"
let FLD_ROW_ID                              = "ROW_ID"
let FLD_TASK_MESSAGE                        = "TASK_MESSAGE"
let FLD_TASK_TYPE                           = "TASK_TYPE"
let FLD_TASK_DATE                           = "TASK_DATE"


import UIKit

class DatabaseModel: NSObject {
    
    var database: FMDatabase!
    
    fileprivate let fileManager = FileManager.default
    fileprivate var databasePath: String = ""
    
    override init() {
        super.init()
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        databasePath = documentsDirectory.appending("/\(DB_TODO)")
        //        databasePath = Bundle.main.path(forResource: "\(DB_TODO)", ofType: "sqlite")!
    }
    
    func createDatabase() {
        print("DB Path : \(databasePath)")
        if !FileManager.default.fileExists(atPath: databasePath) {
            database = FMDatabase(path: databasePath);
            print("DB Created")
            if database != nil {
                if database.open() {
                    
                    let tblList = "create table \(TBL_TODO_MST) (\(FLD_ROW_ID) integer primary key autoincrement, \(FLD_TASK_MESSAGE) text, \(FLD_TASK_TYPE) text, \(FLD_TASK_DATE) text)"
                    
                    do {
                        try database.executeUpdate(tblList, values: nil)
                        print("\(TBL_TODO_MST) Created")
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    self.closeDatabaseConnection()
                }
                else { print("Could not open database.") }
            }
        }
        else { print("DB Exists"); }
    }
    
    func openDatabaseConnection() -> Bool {
        if FileManager.default.fileExists(atPath: databasePath) {
            database = FMDatabase(path: databasePath)
            if database != nil { if database.open() { return true } }
        }
        return false
    }
    
    func closeDatabaseConnection() { database.close() }
    
    func insertTaskEntry(stMessage: String, stDate: String) {
        let insert_stmt: String = "INSERT INTO \(TBL_TODO_MST) (\(FLD_TASK_MESSAGE), \(FLD_TASK_TYPE), \(FLD_TASK_DATE)) VALUES ('\(stMessage)', 'unmark', '\(stDate)')"
        
        if database.executeStatements(insert_stmt) { print("\(TBL_TODO_MST) - Data Inserted") }
        else {
            print("Failed to insert initial data into the database.")
            print(database.lastError(), database.lastErrorMessage())
        }
    }

    func getAllTasks(isMark: Bool) -> [typeAliasDictionary] {
        var arrResults = [typeAliasDictionary]()
        if self.openDatabaseConnection() {
            do {
                var search_stmt_message: String = ""
                if isMark {
                    search_stmt_message = "SELECT * FROM \(TBL_TODO_MST) WHERE \(FLD_TASK_TYPE) = 'mark' COLLATE NOCASE"
                }
                else {
                    search_stmt_message = "SELECT * FROM \(TBL_TODO_MST) WHERE \(FLD_TASK_TYPE) = 'unmark' COLLATE NOCASE"
                }
                
                let results = try database.executeQuery(search_stmt_message, values: nil)
                while results.next() {
                    var dict = typeAliasDictionary()
                    dict[FLD_ROW_ID] = results.string(forColumn:FLD_ROW_ID) as AnyObject?
                    dict[FLD_TASK_MESSAGE] = results.string(forColumn:FLD_TASK_MESSAGE) as AnyObject?
                    dict[FLD_TASK_DATE] = results.string(forColumn:FLD_TASK_DATE) as AnyObject?
                    arrResults.append(dict)
                }
            }
            catch { print(error.localizedDescription) }
            self.closeDatabaseConnection()
        }
        return arrResults
    }
    
    func deleteTask(stId: String) {
        if self.openDatabaseConnection() {
            let delete_stmt: String = "DELETE FROM \(TBL_TODO_MST) WHERE \(FLD_ROW_ID) = \(stId) COLLATE NOCASE"
            if database.executeStatements(delete_stmt) { print("\(TBL_TODO_MST) - Data Deleted.") }
            else { print(database.lastError(), database.lastErrorMessage()) }
            self.closeDatabaseConnection()
        }
    }
    
    func updateTask(stID: String, stMessage: String) {
        if self.openDatabaseConnection() {
            let update_stmt: String = "UPDATE \(TBL_TODO_MST) SET \(FLD_TASK_MESSAGE) = '\(stMessage)' WHERE \(FLD_ROW_ID) = '\(stID)'"
            
            if database.executeStatements(update_stmt) { print("\(TBL_TODO_MST) - Data Updated") }
            else { print(database.lastError(), database.lastErrorMessage()) }
            self.closeDatabaseConnection()
        }

    }

}
