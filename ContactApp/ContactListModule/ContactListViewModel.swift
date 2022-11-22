//
//  ContactListViewModel.swift
//  ContactApp
//
//  Created by Kem on 11/21/22.
//

import Foundation
import RxSwift
import RxCocoa

// We use a class instead of a struct because we know 1VM = 1VC
public final class ContactListViewModel {
    
    let databaseService: DatabaseService
    let contacts = BehaviorRelay<[String]>(value: [])
    
    public let disposeBag = DisposeBag()
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    // MARK: - Bind contact names
    func bindContactNames() {
        let editedContacts: [String] = self.getEditedContactList().compactMap({ "\($0.firstName) \($0.lastName ?? "")" })
        self.contacts.accept(editedContacts)
    }
    
    // MARK: - Get contact names
    func getContactNames() -> [String] {
        return self.contacts.value
    }
    
    // MARK: - Edit Contacts
    func getEditedContactList() -> [Contact] {
        let allContacts = sortNamesIntoContacts() // Retrieve and sort all contacts from databaseService
        let firstNames = allContacts.map { $0.firstName } // Create array of just first names
        var updatedContacts: [Contact] = [] // Initialize empty array to be populated by edited contacts
        for var contact in allContacts {
            let firstNameCount = firstNames.filter({ $0 == contact.firstName }).count
            let uniqueFirstName = firstNameCount == 1 // Only 1 person has this first name
            let similarFirstNames = firstNameCount > 1 // More than 1 person has this first name
            
            if uniqueFirstName {
                contact.lastName = nil // Remove last name
                updatedContacts.append(contact)
            } else if let lastNameInitial = contact.lastName?.first, similarFirstNames {
                let simiarFirstNames = allContacts.filter({$0.firstName == contact.firstName}) // Create micro array of similar first names
                let lastNameInitials = simiarFirstNames.compactMap({ $0.lastName?.first }) // Create array of just last name initials
                
                if lastNameInitials.filter({ $0 == lastNameInitial }).count == 1 {
                    updatedContacts.append(Contact(firstName: contact.firstName, lastName: "\(lastNameInitial)")) // Add contact and replace last name with just first initial if yes
                } else {
                    updatedContacts.append(contact) // Just add contact if no
                }
            } else {
                updatedContacts.append(contact)
            }
        }
        return updatedContacts
    }
    
    // MARK: - Get count of contacts
    func getContactListCount() -> Int {
        return self.contacts.value.count
    }
    
    // MARK: - Sort names
    private func sortNamesIntoContacts() -> [Contact] {
        self.databaseService.getContactsList().sorted(by: {$0 < $1}).compactMap({
            let nameComponents = $0.components(separatedBy: " ")
            let firstName = nameComponents.first ?? ""
            let lastName = nameComponents.count > 1 ? nameComponents.last : nil // Check if name has a last name by making sure string count > 1
            return Contact(firstName: firstName, lastName: lastName)
        })
    }
}
