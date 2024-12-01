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
    
    func getSportType() -> String {
        let sportTypes = [
            "스케이트보드": ["스케이트보드", "스케이트", "롱보드"],
            "축구": ["축구", "풋살", "축구공"],
            "농구": ["농구", "농구공", "덩크"],
            "야구": ["야구", "베이스볼", "배트"],
            "테니스": ["테니스", "라켓"],
            "수영": ["수영", "수영복", "수영모"],
            "골프": ["골프", "골프공", "골프채"],
            "러닝": ["러닝", "달리기", "마라톤", "조깅"],
            "격투기": ["격투기", "복싱", "킥복싱", "무술", "태권도", "유도"],
            "클라이밍": ["클라이밍", "등반", "암벽"],
            "서핑": ["서핑", "서핑보드", "웻수트"],
            "승마": ["승마", "말", "마술"],
            "요가/필라테스": ["요가", "필라테스", "매트"],
            "크로스핏": ["크로스핏", "웨이트", "크로스"],
            "사이클링": ["사이클", "자전거", "바이크"],
            "스키/스노보드": ["스키", "스노보드", "보드"],
            "스쿠버다이빙": ["스쿠버", "다이빙", "프리다이빙"]
        ]
        
        let lowercaseTitle = title.lowercased()
        
        for (sport, keywords) in sportTypes {
            for keyword in keywords {
                if lowercaseTitle.contains(keyword.lowercased()) {
                    return sport
                }
            }
        }
        return "기타"
    }
    
    func getDifficulty() -> String {
        let lowercaseTitle = title.lowercased()
        
        let expertKeywords = ["프로", "전문가용", "프리미엄", "professional", "pro"]
        let intermediateKeywords = ["중급", "중급자", "intermediate"]
        let beginnerKeywords = ["입문", "초급", "초보", "beginner"]
        
        for keyword in expertKeywords {
            if lowercaseTitle.contains(keyword) {
                return "전문가용"
            }
        }
        
        for keyword in intermediateKeywords {
            if lowercaseTitle.contains(keyword) {
                return "중급자용"
            }
        }
        
        for keyword in beginnerKeywords {
            if lowercaseTitle.contains(keyword) {
                return "입문자용"
            }
        }
        
        return "일반"
    }
    
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
