//
//  DatabaseService.swift
//  ContactApp
//
//  Created by Kem on 11/21/22.
//

import Foundation

final class DatabaseService {
    
    let names: [String]
    
    init(names: [String]) {
        self.names = names
    }
    
    public func getContactsList() -> [String] {
        return self.names
    }
}
