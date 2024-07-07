//
//  RealmModel.swift
//  MyShopping
//
//  Created by t2023-m0032 on 7/7/24.
//

import Foundation
import RealmSwift

class likeList: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var image: String
    @Persisted var mallName: String
    @Persisted var title: String
    @Persisted var lprice: String
    @Persisted var link: String?
    @Persisted var productId: String
    
    convenience init(image: String, mallName: String, title: String, lprice: String, link: String?, productId: String) {
        self.init()
        self.image = image
        self.mallName = mallName
        self.title = title
        self.lprice = lprice
        self.link = link
        self.productId = productId
    }
}
