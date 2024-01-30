//
//  CoreDataStackTests.swift
//  MonumentalTests
//
//  Created by Giovanni Gabriel on 26/01/2024.
//

import Foundation
import CoreData
@testable import Monumental

class CoreDataStackTest: CoreDataStack {
    // MARK: - Singleton
    static let sharedTinstance = CoreDataStackTest()

    // MARK: - Proprieties
    private let persistentContainerName = "Monumental"

    // MARK: - Private
    private lazy var persistentContainer: NSPersistentContainer = {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: persistentContainerName)
        let description = container.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
