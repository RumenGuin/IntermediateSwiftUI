//
//  CoreDataBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 17/01/22.
//

import SwiftUI
import CoreData
//NS - nextstep
// View -> UI
// Model -> data point
// ViewModel -> manages the data for a view
//Database -> A database is an organized collection of structured information, or data, typically stored electronically in a computer system. The data can then be easily accessed, managed, modified, updated, controlled, and organized.

//What is CoreData?
/*
 
 It is a database that is stored within the iPhone and we can use it to save data to it and this data would persist between sessions, so if a user closes the app and reopens the app this data will save.
 Core Data is for adding an entire database, adding a ton of data rather than user defaults which should be used for small pieces of data.
 
 
 */

class CoreDataViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var saveEntities: [FruitEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "FruitsContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data. \(error)")
            }
        }
        fetchFruits()
    }
    
    func fetchFruits() {
        let request = NSFetchRequest<FruitEntity>(entityName: "FruitEntity")
        do {
            saveEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching \(error)")
        }
    }
    
    func addFruits(text: String) {
        let newFruit = FruitEntity(context: container.viewContext)
        newFruit.name = text
        saveData()
    }
    
    func updateFruit(entity: FruitEntity) {
        let currentName = entity.name ?? ""
        let newName = currentName + "!"
        entity.name = newName
        saveData()
    }
    
    func deleteFruit(indexSet: IndexSet) {
        guard let index = indexSet.first else {return}
        let entity = saveEntities[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchFruits()
        } catch let error {
            print("error saving \(error)")
        }
       
    }
}

struct CoreDataBootcamp: View {
    @StateObject var vm = CoreDataViewModel()
    @State var textFieldText: String = ""
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Add Fruit Here", text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 55)
                    .background(Color.mint.opacity(0.15))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button {
                    guard !textFieldText.isEmpty else {return}
                    vm.addFruits(text: textFieldText)
                    textFieldText = ""
                } label: {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background(.green)
                        .cornerRadius(10)
                }

                List {
                    ForEach(vm.saveEntities) { entity in
                        Text(entity.name ?? "no Name")
                            .onTapGesture {
                                vm.updateFruit(entity: entity)
                            }
                    }
                    .onDelete(perform: vm.deleteFruit)
                        
                    
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Fruits")
        }
    }
}

struct CoreDataBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataBootcamp()
    }
}
