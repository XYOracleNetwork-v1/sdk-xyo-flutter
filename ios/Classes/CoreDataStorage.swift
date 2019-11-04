//
//  CoreDataStorage.swift
//  xyo_ble
//
//  Created by Darren Sutherland on 6/26/19.
//

import Foundation
import CoreData
import Promises
import sdk_core_swift
import sdk_xyobleinterface_swift

enum CoreDataStorageError: Error {
    case noAppDelegate
    case missingEntity
    case failedRead
    case failedWrite
    case failedDelete
}

protocol Managed: class, NSFetchRequestResult {
    static var entityName: String { get }
}

extension Managed where Self: NSManagedObject {
    static var entityName: String {
        return entity().name!

    }
}

final class XyoInteraction: NSManagedObject {
    @NSManaged public var key: Data
    @NSManaged public var value: Data

    @discardableResult static func insert(into context: NSManagedObjectContext, key: [UInt8], value: [UInt8]) -> XyoInteraction {
        let interaction: XyoInteraction = context.insertObject()
        interaction.key = key.data
        interaction.value = value.data
        return interaction
    }
}

// Thread-safe dictionary cache
class InMemoryStorageCache {

    private var cache = [[UInt8]: [UInt8]]()
    private let accessQueue = DispatchQueue(label: "com.xyo.network.XyoInMemoryStorageCache", attributes: .concurrent)

    func remove(at index: [UInt8]) {
        self.accessQueue.async(flags: .barrier) {
            self.cache.removeValue(forKey: index)
        }
    }

    subscript(index: [UInt8]) -> [UInt8]? {
        set {
            self.accessQueue.async(flags: .barrier) {
                self.cache[index] = newValue
            }
        }
        get {
            var value: [UInt8]?
            self.accessQueue.sync {
                value = self.cache[index]
            }
            return value
        }
    }

}

extension XyoInteraction: Managed {}

final public class CoreDataStorage: XyoStorageProvider {
    private var cache = InMemoryStorageCache()

    static let entityName = "Interaction"
    static let containerName = "Xyo"

    enum CoreDataAttributes: String {
        case key
        case value
    }

    public init() {}

    // Loads the core data DB from the framework
    fileprivate lazy var container: NSPersistentContainer = {
        let messageKitBundle = Bundle(for: type(of: self))
        let modelURL = messageKitBundle.url(forResource: CoreDataStorage.containerName, withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)

        let container = NSPersistentContainer(name: CoreDataStorage.containerName, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { (storeDescription, error) in
            if let err = error {
                // TODO do something
            }
        }

        return container
    }()

    public func write(key: [UInt8], value: [UInt8]) throws {
        self.cache[key] = value

        let awaiter = Promise<Any?>.pending()

        self.container.performBackgroundTask { context in
            context.performAndWait {
                if let interactionObj = self.fetch(for: key, context: context) {
                    context.delete(interactionObj)
                    XyoInteraction.insert(into: context, key: key, value: value)
                } else {
                    XyoInteraction.insert(into: context, key: key, value: value)
                }

                context.saveOrRollback()
                awaiter.fulfill(nil)
            }
        }

        _ = try await(awaiter)
    }

    public func read(key: [UInt8]) throws -> [UInt8]? {
        if let data = self.cache[key] { return data }

        let awaiter = Promise<[UInt8]?>.pending()

        self.container.performBackgroundTask { context in
            return context.performAndWait {
                awaiter.fulfill(self.fetch(for: key, context: context)?.value.bytes)
            }
        }

        return try await(awaiter)
    }

    public func delete(key: [UInt8]) throws {
        self.cache.remove(at: key)

        let awaiter = Promise<Any?>.pending()

        self.container.performBackgroundTask { context in
            context.performAndWait {
                if let interactionObj = self.fetch(for: key, context: context) {
                    context.delete(interactionObj)
                    context.saveOrRollback()
                }

                awaiter.fulfill(nil)
            }
        }

        _ = try await(awaiter)
    }

    public func containsKey(key: [UInt8]) throws -> Bool {
        return try self.read(key: key) != nil
    }

}

fileprivate extension CoreDataStorage {

    func fetch(for key: [UInt8], context: NSManagedObjectContext) -> XyoInteraction? {
        let request = NSFetchRequest<XyoInteraction>(entityName: CoreDataStorage.entityName)

        var interactionObj: XyoInteraction?

        do {
            // We can't use a predicate here as far as I can tell, so we filter the results
            let interactions = try context.fetch(request)
            interactionObj = interactions.filter { key == $0.key.bytes }.first
        } catch {
            return nil
        }

        return interactionObj
    }

}

// MARK: Helper extensions
extension NSManagedObjectContext {
    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
            fatalError("Wrong object type")
        }
        return obj
    }

    @discardableResult func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }

    func performAndWait<T>(_ block: () throws -> T) rethrows -> T {
        return try _performAndWaitHelper(
            fn: performAndWait, execute: block, rescue: { throw $0 }
        )
    }

    /// Helper function for convincing the type checker that
    /// the rethrows invariant holds for performAndWait.
    ///
    /// Source: https://github.com/apple/swift/blob/bb157a070ec6534e4b534456d208b03adc07704b/stdlib/public/SDK/Dispatch/Queue.swift#L228-L249
    private func _performAndWaitHelper<T>(
        fn: (() -> Void) -> Void,
        execute work: () throws -> T,
        rescue: ((Error) throws -> (T))) rethrows -> T {
        var result: T?
        var error: Error?
        withoutActuallyEscaping(work) { _work in
            fn {
                do {
                    result = try _work()
                } catch let e {
                    error = e
                }
            }
        }
        if let e = error {
            return try rescue(e)
        } else {
            return result!
        }
    }

}

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}

extension Array where Element == UInt8 {
    var data: Data {
        return Data(bytes: (self))
    }
}
