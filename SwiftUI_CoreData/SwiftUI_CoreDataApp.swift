//
//  SwiftUI_CoreDataApp.swift
//  SwiftUI_CoreData
//
//  Created by Ruslan Kasian on 25.05.2021.
//

import SwiftUI

@main
struct SwiftUI_CoreDataApp: App {
    
  let persistenceController = PersistenceController.shared
  
  @Environment(\.scenePhase) var scenePhase
  
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { (newscenePhase) in
          
          switch newscenePhase {
          case .background:
            print ("Scene is in background")
            persistenceController.save()
          case .inactive:
            print ("Scene is in inactive")
          case .active:
            print ("Scene is in active")
          @unknown default:
            print ("default")
          }
          
          
        }
    }
}
