//
//  MainTabViewModel.swift
//  News
//
//  Created by Dmitry Vorozhbicki on 28/04/2023.
//

import Foundation
import RealmSwift

final class MainTabViewModel {
    
    init() {
        configureRealmDatabase()
    }
    
    func configureRealmDatabase() {
        let documentDirectory = try? FileManager.default.url(for: .documentDirectory,
                                                             in: .userDomainMask,
                                                             appropriateFor: nil,
                                                             create: false)
        let url = documentDirectory?.appendingPathComponent("ichi.realm")
        var config = Realm.Configuration(
            // MARK: - Realm database version to change
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
                migration.deleteData(forType: Object.className())
            })
        config.shouldCompactOnLaunch = { totalBytes, usedBytes in
            let twentyMB = 1000 * 1024 * 1024
            return (totalBytes > twentyMB)
        }
        config.fileURL = url
        Realm.Configuration.defaultConfiguration = config
        NSLog("Realm path: \(url?.absoluteString ?? "")")
    }
}
