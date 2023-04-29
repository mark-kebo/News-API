//
//  RealmManager.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation
import Realm
import RealmSwift
import Combine

protocol RealmManagerProtocol: AnyObject {
    func create<T: Object>(_ object: T)
    func delete<T: Object>(_ object: T)
    func readAllOfType<T: Object>(_ objectType: T.Type) -> Results<T>?
}

final class RealmManager: RealmManagerProtocol {
    func create<T: Object>(_ object: T) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object)
            }
        }
        catch (let error) {
            let errorMessage = "Can't write Object to DB: \(error.localizedDescription)"
            NSLog(errorMessage)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(object)
            }
        } catch (let error) {
            let errorMessage = "Can't delete Object in DB: \(error.localizedDescription)"
            NSLog(errorMessage)
        }
    }
    
    func readAllOfType<T: Object>(_ objectType: T.Type) -> Results<T>? {
        do {
            let realm = try Realm()
            return realm.objects(objectType.self)
        } catch (let error) {
            let errorMessage = "Can't read Objects from DB: \(error.localizedDescription)"
            NSLog(errorMessage)
            return nil
        }
    }
}
