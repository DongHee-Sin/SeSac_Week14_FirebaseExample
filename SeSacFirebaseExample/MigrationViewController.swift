//
//  MigrationViewController.swift
//  SeSacFirebaseExample
//
//  Created by 신동희 on 2022/10/13.
//

import UIKit
import RealmSwift


class MigrationViewController: UIViewController {

    let localRealm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addData()
    }
    
    
    func addData() {
        
        // 1. fileURL
        let fileURL = localRealm.configuration.fileURL
        print("FileURL: \(fileURL)")
        
        
        // 2. SchemaVersion : 현재 사용중인 데이터 스키마 버전을 확인 가능
        do {
            let version = try schemaVersionAtURL(fileURL!)
            print("Version: \(version)")
        }
        catch {
            print(error)
        }
        
        
        // 3. TEST
        for i in 1...100 {
            let task = Todo(title: "고래밥의 할일 \(i)", importance: Int.random(in: 1...5))

            try! localRealm.write {
                localRealm.add(task)
            }
        }
        
    }
}
