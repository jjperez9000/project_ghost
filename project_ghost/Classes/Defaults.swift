//
//  Defaults.swift
//  project_wingman
//
//  Created by John Perez on 4/2/23.
//

import Foundation

class Defaults: ObservableObject {
    static let shared = Defaults()
    
    private let defaults = UserDefaults.standard
    
    func set<T>(_ value: T, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    func get<T>(forKey key: String) -> T? {
        return defaults.object(forKey: key) as? T
    }
    
    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}
