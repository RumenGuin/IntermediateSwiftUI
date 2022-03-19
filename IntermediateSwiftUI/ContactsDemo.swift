//
//  ContactsDemo.swift
//  IntermediateSwiftUI
//
//  Created by RUMEN GUIN on 19/03/22.
//

import SwiftUI
import Contacts

struct ContactsDemo: View {
    var body: some View {
        Text("Hello, World!")
            .onAppear {
                Task.init {
                    //await fetchAllContacts()
                    await fetchSpecficContacts()
                }
            }
    }
    
    func fetchSpecficContacts() async{
        //Run this in the background
        
        //Get access to the contacts store
        let store = CNContactStore()
        
        //Keys to Fetch
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        
        //Search criteria
        let predicate = CNContact.predicateForContacts(matchingName: "Kate")
        
        do {
            //Perform fetch
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
            print(contacts)
        } catch {
            //error
        }
        
    }
    
    func fetchAllContacts() async{ //async -> to run it in the background
        //Run this in the background async
        
        //Get access to the Contacts store
        let store = CNContactStore()
        
        //Specify which data keys we want to fetch
                    //[The contact's given name , A phone numbers of a contact.]
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        
        //Create fetch request
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        
        //Call method to fetch all contacts
        do {
            try store.enumerateContacts(with: fetchRequest, usingBlock: { contact, result in
                //do something with the contact
                print(contact.givenName)
                
                for number in contact.phoneNumbers {
    
                    switch number.label {
                        
                    case CNLabelPhoneNumberMobile:
                        print("- Mobile: \(number.value.stringValue)")
                    case CNLabelPhoneNumberMain:
                        print("- Main: \(number.value.stringValue)")
                    default:
                        print("- Other: \(number.value.stringValue)")
                    }
                    
                }
            })
        } catch {
            //if there was an error, handle it here
            print("error")
        }
    }
}

struct ContactsDemo_Previews: PreviewProvider {
    static var previews: some View {
        ContactsDemo()
    }
}
