//
//  CoreDataRelationshipsBootcamp.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 31/01/22.
//

import SwiftUI
import CoreData

//Database -> A database is an organized collection of structured information, or data, typically stored electronically in a computer system. The data can then be easily accessed, managed, modified, updated, controlled, and organized.

//What is CoreData?
/*
 
 It is a database that is stored within the iPhone and we can use it to save data to it and this data would persist between sessions, so if a user closes the app and reopens the app this data will save.
 Core Data is for adding an entire database, adding a ton of data rather than user defaults which should be used for small pieces of data.
 
 
 */

/*
 3 entities
 BusinessEntity
 DepartmentEntity
 EmployeeEntity
 */

class CoreDataManager {
    static let instance = CoreDataManager() //instance
    
    let container: NSPersistentContainer //A container that encapsulates the Core Data stack in your app.
    let context: NSManagedObjectContext //An object space to manipulate and track changes to managed objects.
    
    private init() {
        container = NSPersistentContainer(name: "CoreDataContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data \(error)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
            print("Saved Successfully!")
        } catch let error {
            print("Error Saving Core Data \(error.localizedDescription)")
        }
       
    }
}

class CoreDataRelationshipsViewModel: ObservableObject {
    let manager = CoreDataManager.instance
    @Published var businesses: [BusinessEntity] = []
    @Published var departments: [DepartmentEntity] = []
    @Published var employees: [EmployeeEntity] = []
    
    init() {
        getBusinesses()
        getDepartments()
        getEmployees()
    }
    
    //to get on screen
    func getBusinesses() {
        let request = NSFetchRequest<BusinessEntity>(entityName: "BusinessEntity")
        
        //sorting
//        let sort = NSSortDescriptor(keyPath: \BusinessEntity.name, ascending: true)
//        request.sortDescriptors = [sort]
//
//        //filter == predicate
//        let filter = NSPredicate(format: "name == %@", "Apple") //only apple business will be seen
//        request.predicate = filter
        
        do {
            businesses = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching \(error.localizedDescription)")
        }
    }
    
    //to get on screen
    func getDepartments() {
        let request = NSFetchRequest<DepartmentEntity>(entityName: "DepartmentEntity")
        
        do {
            departments = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching \(error.localizedDescription)")
        }
    }
    
    //to get on screen
    func getEmployees() {
        let request = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
        do {
            employees = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching \(error.localizedDescription)")
        }
    }
    
    func getEmployees(forBusiness business: BusinessEntity) {
        let request = NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
        
//        let filter = NSPredicate(format: "business == %@", business)
//        request.predicate = filter
        
        do {
            employees = try manager.context.fetch(request)
        } catch let error {
            print("Error fetching \(error.localizedDescription)")
        }
    }
    
    func updateBusiness() {
        let existingBusiness = businesses[2]
        existingBusiness.addToDepartments(departments[1])
        save()
    }
    
    func addBusiness() {
        let newBusiness = BusinessEntity(context: manager.context)
        newBusiness.name = "Facebook"
        
        //add existing departments to the new business
       // newBusiness.departments = [departments[0], departments[1]] //have both marketing & engineering dept
        
        //add existing employees to the new business
        //newBusiness.employees = [employees[1], employees[2]]
        
        //add new business to existing departments
        //newBusiness.addToDepartments(<#T##value: DepartmentEntity##DepartmentEntity#>)
        
        //add new business to existing employees
        //newBusiness.addToEmployees(<#T##value: EmployeeEntity##EmployeeEntity#>)
        
        save()
    }
    
    func addDepartment() {
        let newDepartment = DepartmentEntity(context: manager.context)
        //newDepartment.name = "Finance"
        //a department could have multiple businesses (we set it like that)
        //newDepartment.businesses = [businesses[0], businesses[1], businesses[2]]
        //newDepartment.employees = [employees[1]]
        newDepartment.addToEmployees(employees[1])
        save()
    }
    
    func addEmployee() {
        let newEmployee = EmployeeEntity(context: manager.context)
        newEmployee.age = 21
        newEmployee.dateJoined = Date() //Today's date
        newEmployee.name = "Rumen"
        //an employee can only have 1 business
        newEmployee.business = businesses[1]
        newEmployee.department = departments[1]
        save()
        
    }
    
    func deleteBusiness() {
        let business = businesses[3]
        manager.context.delete(business)
        save()
    }
    
    func deleteDepartment() {
        let department = departments[3] //finance
        manager.context.delete(department)
        save()
    }
    
    func deleteEmployee() {
        let employee = employees[1]
        manager.context.delete(employee)
        save()
    }
    
    func save() {
        businesses.removeAll()
        departments.removeAll()
        employees.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.manager.save()
            //everytime we press save it reloads the screen
            self.getBusinesses()
            self.getDepartments()
            self.getEmployees()
        }
        
    }
    
}

struct CoreDataRelationshipsBootcamp: View {
    @StateObject var vm = CoreDataRelationshipsViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            
                            Button {
                                vm.deleteDepartment()
                               // vm.getEmployees(forBusiness: vm.businesses[0])
                            } label: {
                                Text("DElete")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding()
                                    .padding(.horizontal)
                                    .background(.blue)
                                    .cornerRadius(10)
                            }
                            
                            
                            Button {
                                vm.addBusiness()
                            } label: {
                                Text("Add To Business")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding()
                                    .padding(.horizontal)
                                    .background(.blue)
                                    .cornerRadius(10)
                            }
                            
                            Button {
                                vm.addDepartment()
                            } label: {
                                Text("Add to Department")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding()
                                    .padding(.horizontal)
                                    .background(.blue)
                                    .cornerRadius(10)
                            }
                            
                            Button {
                                vm.addEmployee()
                            } label: {
                                Text("Add to Employee")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding()
                                    .padding(.horizontal)
                                    .background(.blue)
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(alignment: .top, spacing: 10) {
                            ForEach(vm.businesses) {business in
                                BusinessView(entity: business)
                            }
                        }
                    }
                    
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(alignment: .top, spacing: 10) {
                            ForEach(vm.departments) {department in
                                DepartmentView(entity: department)
                            }
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(alignment: .top, spacing: 10) {
                            ForEach(vm.employees) {employee in
                                EmployeeView(entity: employee)
                            }
                        }
                    }

                }
                .padding()
            }
            .navigationTitle("Relationships")
        }
    }
}

struct CoreDataRelationshipsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataRelationshipsBootcamp()
    }
}

struct BusinessView: View {
    let entity: BusinessEntity
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Name: \(entity.name ?? "")")
                .bold()
            
            //typecasting departments as [DepartmentEntity]
            if let departments = entity.departments?.allObjects as? [DepartmentEntity] {
                Text("Departments:")
                    .bold()
                ForEach(departments) {department in
                    Text(department.name ?? "")
                }
            }
            
            //typecasting employees as [EmployeeEntity]
            if let employees = entity.employees?.allObjects as? [EmployeeEntity] {
                Text("Employees: ")
                    .bold()
                ForEach(employees) {employee in
                    Text(employee.name ?? "")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}



struct DepartmentView: View {
    let entity: DepartmentEntity
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Name: \(entity.name ?? "")")
                .bold()
            
            //typecasting businesses as [BusinessEntity]
            if let businesses = entity.businesses?.allObjects as? [BusinessEntity] {
                Text("Businesses: ")
                    .bold()
                ForEach(businesses) {business in
                    Text(business.name ?? "")
                }
            }
            
            //typecasting employees as [EmployeeEntity]
            if let employees = entity.employees?.allObjects as? [EmployeeEntity] {
                Text("Employees: ")
                    .bold()
                ForEach(employees) {employee in
                    Text(employee.name ?? "")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.green.opacity(0.3))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}


struct EmployeeView: View {
    let entity: EmployeeEntity
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Name: \(entity.name ?? "")")
                .bold()
            
            Text("Age: \(entity.age)")
            Text("Date Joined: \(entity.dateJoined ?? Date())")
            
           Text("Business: ")
                .bold()
            Text(entity.business?.name ?? "")
            
            Text("Department: ")
                .bold()
            Text(entity.department?.name ?? "")
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.mint.opacity(0.3))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
