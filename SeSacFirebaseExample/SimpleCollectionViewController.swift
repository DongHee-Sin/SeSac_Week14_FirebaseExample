//
//  SimpleCollectionViewController.swift
//  SeSacFirebaseExample
//
//  Created by 신동희 on 2022/10/18.
//

import UIKit
import RealmSwift


class SimpleCollectionViewController: UICollectionViewController {

    // MARK: - Propertys
    let localRealm = try! Realm()
    var tasks: Results<Todo>!
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Todo>!
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = localRealm.objects(Todo.self)
        
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout
        
        cellRegistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            
            var content = cell.defaultContentConfiguration()
            
            content.image = itemIdentifier.importance < 2 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star.fill")
            content.text = itemIdentifier.title
            content.secondaryText = "\(itemIdentifier.detail.count)개의 세부 항목"
            
            cell.contentConfiguration = content
            
        })
    }
}




// MARK: - CollectionView Methods
extension SimpleCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = tasks[indexPath.item]
        
        // using 매개변수 : Cell 재사용을 위한 클로저 구문 입력
        // item 매개변수 : 재사용 클로저 구문(using)에서 사용할 데이터
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        
        var test: fruit = apple()
        test = melon()
        test = strawberry.good
        
        return cell
    }
    
}




protocol fruit {
    
}

class apple: fruit {
    
}

class banana: fruit {
    
}

enum strawberry: fruit {
    case good
}

struct melon: fruit {
    
}
