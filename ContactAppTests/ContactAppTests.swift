//
//  ContactAppTests.swift
//  ContactAppTests
//
//  Created by Kem on 11/21/22.
//

import XCTest
@testable import ContactApp

final class ContactAppTests: XCTestCase {
    
    var sut: DatabaseService!

    override func setUpWithError() throws {
        self.sut = DatabaseService()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        self.sut = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testConvertNamesToContact() {
        let names = ["Chad Boswack", "Brian Xpander", "Denver Lotus", "Andy Savage"]
        
        let contacts = names.compactMap({
            let components = $0.components(separatedBy: " ")
            return Contact(firstName: components.first ?? "", lastName: components.last)
        })
        
        XCTAssertEqual(contacts.first?.firstName, "Chad", "Contact array first value must equal names array first value")
        XCTAssertEqual(contacts.first?.lastName, "Boswack", "Contact array first value must equal names array first value")
    }

    func testAlphabeticalOrder() {
        let names = ["Chad Boswack", "Brian Xpander", "Denver Lotus", "Andy Savage"]
        let alphabeticalNames = names.sorted(by: {$0 < $1})
        
        XCTAssertEqual(alphabeticalNames, ["Andy Savage", "Brian Xpander", "Chad Boswack", "Denver Lotus"], "Names must be sorted alphabetically based on the first name")
    }
    
    
    func testReturnOnlyFirstName() {
        let names = ["Chad Boswack", "Brian Xpander", "Brian Lotus", "Andy Savage"]
        
        let contacts = names.compactMap({
            let components = $0.components(separatedBy: " ")
            return Contact(firstName: components.first ?? "", lastName: components.last)
        })
        let firstNames = contacts.map { $0.firstName }
        var updatedContacts: [Contact] = []
        
        for contact in contacts {
            if firstNames.filter({$0 == contact.firstName}).count == 1 {
                updatedContacts.append(Contact(firstName: contact.firstName))
            } else {
                updatedContacts.append(contact)
            }
        }
        
        XCTAssertEqual(contacts.count, updatedContacts.count, "The array count must still be the same")
        XCTAssertEqual(updatedContacts, [Contact(firstName: "Chad", lastName: nil),
                                         Contact(firstName: "Brian", lastName: "Xpander"),
                                         Contact(firstName: "Brian", lastName: "Lotus"),
                                         Contact(firstName: "Andy", lastName: nil)],
                       "All unique first names must have nil last names")
    }
    
    func testTwoSameFirstNameLastNameInitial() {
        let names = ["Chad Boswack", "Brian Xpander", "Brian Lotus", "Andy Savage"]
        let contacts = names.compactMap({
            let components = $0.components(separatedBy: " ")
            return Contact(firstName: components.first ?? "", lastName: components.last)
        })
        let firstNames = contacts.map { $0.firstName }
        var updatedContacts: [Contact] = []
        
        for contact in contacts {
            
            let firstNameCount = firstNames.filter({$0 == contact.firstName}).count
            
            if firstNameCount == 1 {
                updatedContacts.append(Contact(firstName: contact.firstName))
            } else if firstNameCount > 1 {
                guard let lastNameInitial = contact.lastName?.first else {
                    updatedContacts.append(contact) // Last name is nil
                    return
                }
                updatedContacts.append(Contact(firstName: contact.firstName, lastName: "\(lastNameInitial)"))
            } else {
                updatedContacts.append(contact)
            }
        }
        
        XCTAssertEqual(contacts.count, updatedContacts.count, "The array count must still be the same")
        XCTAssertEqual(updatedContacts, [Contact(firstName: "Chad", lastName: nil),
                                         Contact(firstName: "Brian", lastName: "X"),
                                         Contact(firstName: "Brian", lastName: "L"),
                                         Contact(firstName: "Andy", lastName: nil)],
                       "All unique first names must have nil last names and all same first names must only have initial last name")
    }
    
    func testTwoSameFirstNameAndLastNameInitial() {
        let names = ["Chad Boswack", "Brian Xpander", "Brian Xodus", "Brian Yapsor", "Andy Savage"]
        
        self.measure {
            let contacts = names.compactMap({
                let components = $0.components(separatedBy: " ")
                return Contact(firstName: components.first ?? "", lastName: components.last)
            })
            let firstNames = contacts.map { $0.firstName }
            let lastNameInitials = contacts.compactMap({$0.lastName?.first})
            var updatedContacts: [Contact] = []
            
            for var contact in contacts {
                
                let firstNameCount = firstNames.filter({$0 == contact.firstName}).count
                
                if firstNameCount == 1 {
                    contact.lastName = nil
                    updatedContacts.append(contact)
                } else if firstNameCount > 1 {
                    guard let lastNameInitial = contact.lastName?.first else {
                        updatedContacts.append(contact) // Last name is nil
                        return
                    }
                    if lastNameInitials.filter({$0 == lastNameInitial}).count == 1 {
                        updatedContacts.append(Contact(firstName: contact.firstName, lastName: "\(lastNameInitial)"))
                    } else {
                        updatedContacts.append(contact)
                    }
                } else {
                    updatedContacts.append(contact)
                }
            }
            
            XCTAssertEqual(contacts.count, updatedContacts.count, "The array count must still be the same")
            XCTAssertEqual(updatedContacts, [Contact(firstName: "Chad", lastName: nil),
                                             Contact(firstName: "Brian", lastName: "Xpander"),
                                             Contact(firstName: "Brian", lastName: "Xodus"),
                                             Contact(firstName: "Brian", lastName: "Y"),
                                             Contact(firstName: "Andy", lastName: nil)],
                           "All unique first names must have nil last names and all same first names must only have initial last name")
        }
    }
    
    func testViewModelSortingFunction() {
        
    }
    
}
