//
//  RealmManager.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation
import Realm
import RealmSwift

protocol RealmManagerProtocol: AnyObject {
    func create<T: Object>(_ object: T)
    func create<T: Object>(_ objects: [T])
    func readAllOfType<T: Object>(_ objectType: T.Type) -> Results<T>?
    func getObjectOfType<Element: Object, KeyType>(_ objectType: Element.Type, forPrimaryKey primaryKey: KeyType) -> Element?
    func query<T: Object>(type objectType: T.Type, filter predicate: NSPredicate) -> Results<T>?
    func update<T: Object>(_ object: T, with dictionary: [String: Any])
    func delete<T: Object>(_ object: T)
    func deleteAllOfType<T: Object>(_ objectType: T.Type)
    func clearDatabase()
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
    
    func create<T: Object>(_ objects: [T]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(objects)
            }
        }
        catch (let error) {
            let errorMessage = "Can't write Objects to DB: \(error.localizedDescription)"
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
    
    func getObjectOfType<Element: Object, KeyType>(_ objectType: Element.Type, forPrimaryKey primaryKey: KeyType) -> Element? {
        do {
            let realm = try Realm()
            return realm.object(ofType: objectType.self, forPrimaryKey: primaryKey)
        } catch (let error) {
            let errorMessage = "Can't read Object from DB: \(error.localizedDescription)"
            NSLog(errorMessage)
            return nil
        }
    }
    
    func query<T: Object>(type objectType: T.Type, filter predicate: NSPredicate) -> Results<T>? {
        do {
            let realm = try Realm()
            return realm.objects(objectType.self).filter(predicate)
        } catch (let error) {
            let errorMessage = "Can't read Objects from DB: \(error.localizedDescription)"
            NSLog(errorMessage)
            return nil
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String: Any]) {
        do {
            let realm = try Realm()
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch (let error) {
            let errorMessage = "Can't update Object in DB: \(error.localizedDescription)"
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
    
    func deleteAllOfType<T: Object>(_ objectType: T.Type) {
        do {
            let realm = try Realm()
            let objects = realm.objects(objectType.self)
            try realm.write {
                realm.delete(objects)
            }
        } catch (let error) {
            let errorMessage = "Can't delete Objects type \(objectType.self) from DB: \(error.localizedDescription)"
            NSLog(errorMessage)
        }
    }
    
    func clearDatabase() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch (let error) {
            let errorMessage = "Can't delete Objects from DB: \(error.localizedDescription)"
            NSLog(errorMessage)
        }
    }
}
