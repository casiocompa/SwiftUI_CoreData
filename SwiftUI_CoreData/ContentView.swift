//
//  ContentView.swift
//  SwiftUI_CoreData
//
//  Created by Ruslan Kasian on 25.05.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    entity: Card.entity(),
    sortDescriptors: [
      NSSortDescriptor(keyPath: \Card.created, ascending: false),
    ],
    animation: .default)
  private var cards: FetchedResults<Card>
  
  var body: some View {
    NavigationView{
      List {
        ForEach(cards) { card in
          HStack{
            Image(card.cardIsVisa ? "visa" : "mastercard")
            Text("**** **** **** \(String(card.cardNumber!.suffix(4)))")
            NavigationLink(
              destination: DatailView(cardInfo: card)){
              
            }
          }.padding()
        }
        .onDelete(perform: deleteItems)
        
      }
      .navigationTitle("Cards")
      .toolbar {
        ToolbarItemGroup (placement: .navigationBarTrailing) {
          Button(action: addItem) {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
    }
  }
  
  private func addItem() {
    withAnimation {
      let newCard = Card(context: viewContext)
      newCard.cardNumber = random(digits: 16)
      newCard.created = Date()
      newCard.cardIsVisa = Bool.random()
      newCard.bankName = "Bank"
      do {
        try viewContext.save()
      } catch {
        
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
  
  private func random(digits:Int) -> String {
    var number = String()
    for _ in 1...digits {
      number += "\(Int.random(in: 1...9))"
    }
    return number
  }
  
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { cards[$0] }.forEach(viewContext.delete)
      
      do {
        try viewContext.save()
      } catch {
        
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
  }
}


struct DatailView: View {
  var cardInfo : Card
  var body: some View {
    Spacer()
    HStack (alignment:.bottom, spacing: 100) {
      VStack(alignment: .leading, spacing: 60) {
        Text ("\(cardInfo.bankName ?? "Unknown")")
          .font(.system(size: 25))
          .colorInvert()
        Text("**** \(String(cardInfo.cardNumber!.suffix(4)))")
          .font(.system(size: 20))
          .colorInvert()
      
      }
      Image(cardInfo.cardIsVisa ? "visa" : "mastercard")
        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .trailing)
    }
    .padding(15)
    .frame(width: 350, height: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    
    .background(Color(cardInfo.cardIsVisa ? "visa" : "mastercard"))
    .cornerRadius(22)
    
    Spacer()
  }
  
}
