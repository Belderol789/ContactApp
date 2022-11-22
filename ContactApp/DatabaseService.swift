//
//  DatabaseService.swift
//  ContactApp
//
//  Created by Kem on 11/21/22.
//

import Foundation

final class DatabaseService {
    
    public func retrieveContactsList() -> [Contact] {
        return self.retrieveTestData().compactMap({
            let nameComponents = $0.components(separatedBy: " ")
            let firstName = nameComponents.first ?? ""
            let lastName = nameComponents.count > 1 ? nameComponents.last : nil // Check if name has a last name by making sure string count > 1
            return Contact(firstName: firstName, lastName: lastName)
        })
    }
    
    private func retrieveTestData() -> [String] {
        return TestData.shared.contacts
    }
    
}
