//
//  CoreDataManager.swift
//  UpStock
//
//  Created by 오국원 on 2023/07/31.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    static var `default` = CoreDataManager()
    
    func count(forEntityName: String) -> Int {
        var count = 0
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: forEntityName)
        fetchRequest.resultType = .countResultType
        do {
            count = try context?.count(for: fetchRequest) ?? 0
        } catch {
            print("Error fetching count: \(error)")

        }
        return count
    }
    
    func save<T>(forEntityName: String, value: T) {
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: forEntityName, in: context) else { return }
        
        let mirror = Mirror(reflecting: value)
        
        guard let uniqueValue = mirror.descendant("koreanName") as? String else {
            print("Data does not have 'koreanName'.")
            return
        }
        
        if existEntityWith(uniqueValue: uniqueValue, entityName: forEntityName) { return }
        
        let newData = NSManagedObject(entity: entity, insertInto: context)
        
        mirror.children.forEach { (k, v) in
            guard let k else { return }
            newData.setValue(v, forKey: k)
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    func fetch<T: NSManagedObject>(type: T.Type) -> [T]? {
        guard let context else { return nil }
        var data: [T]?
        do {
            data = try context.fetch(type.fetchRequest()) as? [T]
        } catch {
            print(error.localizedDescription)
        }
        return data
    }
    
    private func existEntityWith(uniqueValue: String, entityName: String) -> Bool {
        guard let context = context else { return false }
        
        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.predicate = NSPredicate(format: "koreanName == %@", uniqueValue)
        
        do {
            let existingData = try context.fetch(request)
            return existingData.count > 0
        } catch {
            print("Failed to fetch data: \(error)")
            return false
        }
    }
}
