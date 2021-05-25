//
//  Persistence.swift
//  SwiftUI_CoreData
//
//  Created by Ruslan Kasian on 25.05.2021.
//

import CoreData

struct PersistenceController {
  
  static let shared = PersistenceController()
  
  let container: NSPersistentContainer
  
  init() {
    container = NSPersistentContainer(name: "Data_CoreData")
    container.loadPersistentStores{ (description, error) in
      if let error = error {
        fatalError("Core Data error: \(error.localizedDescription)")
      }
      
    }
  }
  
  func save(completion: @escaping (Error?) -> () = {_ in} ) {
    let context = container.viewContext
    if context.hasChanges {
      do {
        try context.save()
      }catch {
        completion(error)
      }
    }
  }
  
  func delete (_ object: NSManagedObject, completion: @escaping (Error?) -> () = {_ in} ) {
    let context = container.viewContext
    context.delete(object)
    save(completion: completion)
  }
  
}
