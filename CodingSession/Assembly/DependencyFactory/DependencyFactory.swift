class DependencyFactory {
    enum Lifecycle {
        case shared
        case scoped
    }
    
    enum DependencyError: Error {
        case notFound(String)
            
        var errorDescription: String? {
            switch self {
            case .notFound(let name):
                return "Dependency with name '\(name)' was not found."
            }
        }
    }
    
    struct InstanceKey : Hashable, CustomStringConvertible {
        let lifecycle: Lifecycle
        let name: String
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(lifecycle.hashValue)
            hasher.combine(name)
        }
        
        var description: String {
            return "\(lifecycle)(\(name))"
        }

        static func ==(lhs: InstanceKey, rhs: InstanceKey) -> Bool {
            return (lhs.lifecycle == rhs.lifecycle) && (lhs.name == rhs.name)
        }
    }
    
    private var sharedInstances: [String:Any] = [:]
    private var scopedInstances: [String:Any] = [:]
    private var instanceStack: [InstanceKey] = []
    private var configureStack: [() -> ()] = []
    
    init() { }
    
    final func removeShared(name: String) {
        sharedInstances[name] = nil
    }
    
    @discardableResult
    final func shared<T>(name: String = #function, factory: () -> T, configure: ((T) -> Void)? = nil) -> T {
        return shared(name: name, factory(), configure: configure)
    }
    
    @discardableResult
    final func shared<T>(name: String = #function, _ factory: @autoclosure () -> T, configure: ((T) -> Void)? = nil) -> T {
        if let instance = sharedInstances[name] as? T {
            return instance
        }
        
        return inject(
            lifecycle: .shared,
            name: name,
            factory: factory,
            configure: configure
        )
    }
    
    @discardableResult
    final func scoped<T>(name: String = #function, factory: () -> T, configure: ((T) -> Void)? = nil) -> T {
        return scoped(name: name, factory(), configure: configure)
    }
    
    @discardableResult
    final func scoped<T>(name: String = #function, _ factory: @autoclosure () -> T, configure: ((T) -> Void)? = nil) -> T {
        if let instance = scopedInstances[name] as? T {
            return instance
        }
        
        return inject(
            lifecycle: .scoped,
            name: name,
            factory: factory,
            configure: configure
        )
    }
    
    final private func inject<T>(lifecycle: Lifecycle, name: String, factory: () -> T, configure: ((T) -> Void)?) -> T {
        let key = InstanceKey(lifecycle: lifecycle, name: name)
        
        if instanceStack.contains(key) {
            print("Circular dependency from one of \(instanceStack) to \(key) in initializer")
        }
        
        instanceStack.append(key)
        let instance = factory()
        instanceStack.removeLast()
        
        switch lifecycle {
        case .shared:
            sharedInstances[name] = instance
        case .scoped:
            scopedInstances[name] = instance
        }
        
        if let configure = configure {
            configureStack.append({configure(instance)})
        }
        
        return instance
    }
    
}
