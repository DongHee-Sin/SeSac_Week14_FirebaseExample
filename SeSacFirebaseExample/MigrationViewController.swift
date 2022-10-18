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
        
        
        // 3. TEST Data
//        for i in 1...100 {
//            let task = Todo(title: "고래밥의 할일 \(i)", importance: Int.random(in: 1...5))
//
//            try! localRealm.write {
//                localRealm.add(task)
//            }
//        }
//
//
//        for i in 1...10 {
//            let task = DetailTodo(detailTitle: "양파링 \(i)개 사기", favorite: true)
//
//            try! localRealm.write {
//                localRealm.add(task)
//            }
//        }
        
        
        // 특정 Todo 테이블에 DetailToDo 추가
//        guard let task = localRealm.objects(Todo.self).filter("title = '고래밥의 할일 3'").first else { return }
//
//        let detailTask = DetailTodo(detailTitle: "깡깡한 아이스크림 \(Int.random(in: 1...5))개 먹기", favorite: false)
//
//        try! localRealm.write {
//            task.detail.append(detailTask)
//        }
        
        
        // 특정 Todo 테이블 삭제
//        guard let task = localRealm.objects(Todo.self).filter("title = '고래밥의 할일 3'").first else { return }
//
//        try! localRealm.write {
//            localRealm.delete(task.detail)   // ⭐️ 포함관계에 있는 List를 먼저 삭제!!
//            localRealm.delete(task)
//        }
        
        
        
        // 특정 Todo에 메모 추가 (Embeded Object)
//        guard let task = localRealm.objects(Todo.self).filter("title = '고래밥의 할일 6'").first else { return }
//
//        let memo = Memo()
//        memo.content = "CONTENT"
//        memo.date = Date()
//
//        try! localRealm.write {
//            task.memo = memo
//        }
    }
}
