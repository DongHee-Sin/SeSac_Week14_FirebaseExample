//
//  Todo.swift
//  SeSacFirebaseExample
//
//  Created by 신동희 on 2022/10/13.
//

import Foundation
import RealmSwift


class Todo: Object {
    
    @Persisted var title: String
    @Persisted var importance: Int
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    @Persisted var detail: List<DetailTodo>  // 데이터가 없다면 빈 배열이 되므로 Optional이 아니어도 된다.
    
    @Persisted var memo: Memo?  // Embeded Object는 항상 Optional!!
    
    convenience init(title: String, importance: Int) {
        self.init()
        self.title = title
        self.importance = importance
    }
    
}



class Memo: EmbeddedObject {
    @Persisted var content: String
    @Persisted var date: Date
}



class DetailTodo: Object {
    
    @Persisted var detailTitle: String
    @Persisted var favorite: Bool
    @Persisted var deadline: Date
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(detailTitle: String, favorite: Bool) {
        // self.init(지정생성자)에서 기본값을 설정해줌 (따로 명시하지 않았다면)
        self.init()
        self.detailTitle = detailTitle
        self.favorite = favorite
    }
    
}
