//
//  ContactListViewModel.swift
//  ContactApp
//
//  Created by Kem on 11/21/22.
//

import Foundation

// We use a class instead of a struct because we know 1VM = 1VC
public final class ContactListViewModel {
    
    let databaseService: DatabaseService
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func retrieveContactList() -> [Contact] {
        
        let allContacts = databaseService.retrieveContactsList() // Retrieve all contacts from databaseService
        let firstNames = allContacts.map { $0.firstName } // Create array of just first names
        let lastNameInitials = allContacts.compactMap({ $0.lastName?.first }) // Create array of just last name initials
        var updatedContacts: [Contact] = [] // Initialize empty array to be populated by edited contacts
        
        for var contact in allContacts {
            let firstNameCount = firstNames.filter({ $0 == contact.firstName }).count
            let uniqueFirstName = firstNameCount == 1 // Only 1 person has this first name
            let similarFirstNames = firstNameCount > 1 // More than 1 person has this first name
            
            if uniqueFirstName {
                contact.lastName = nil // Remove last name
                updatedContacts.append(contact)
            } else if similarFirstNames,
                      let lastNameInitial = contact.lastName?.first,
                      lastNameInitials.filter({ $0 == lastNameInitial }).count == 1 // Check if last name is unique
            {
                updatedContacts.append(Contact(firstName: contact.firstName, lastName: "\(lastNameInitial)")) // Add contact and replace last name with just first initial if yes
            } else {
                updatedContacts.append(contact)
            }
        }
        
        return updatedContacts
    }
}
