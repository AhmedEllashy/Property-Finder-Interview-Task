//
//  App+DI.swift
//  Tahudu
//
//  Created by Ahmad Ellashy on 18/10/2026.
//

final class DIContainer {
    static let shared = DIContainer()
    private init() {}
    
    // Stored as factories so each resolve can create a fresh instance
    private var factories: [String: () -> Any] = [:]
    private var singletons: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, singleton: Bool = false, factory: @escaping () -> T) {
        let key = String(describing: type)
        if singleton {
            singletons[key] = factory()
        } else {
            factories[key] = factory
        }
    }
    
    func resolve<T>(_ type: T.Type = T.self) -> T {
         let key = String(describing: type)
         if let instance = singletons[key] as? T { return instance }
         guard let instance = factories[key]?() as? T else {
             fatalError("\(key) is not registered")
         }
         return instance
     }
}
