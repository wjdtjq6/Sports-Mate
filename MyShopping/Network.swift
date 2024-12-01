//
//  Network.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/21/24.
//

import Foundation
import Alamofire
import Toast

struct Shopping: Codable {
    let total: Int
    let start: Int
    let items: [Items]
}
struct Items: Codable {
    let title: String
    let mallName: String
    let image: String
    let lprice: String
    
    let productId: String
    let link: String
    
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
        if title.contains("프로") || title.contains("전문가용") {
            return "전문가용"
        } else if title.contains("중급") {
            return "중급자용"
        }
        return "입문자용"
    }
}

class Network {
    static let shared = Network()
    private init() {} //=> 다른데서 Network().callRequest()를 못함

    /*지속적일 때 static 붙임*/func callRequest(searchQuery: String, sort: String, start: Int, success: @escaping (Shopping) -> Void, failure: @escaping () -> Void) {
        
        let url = "https://openapi.naver.com/v1/search/shop.json?display=30&query=\(searchQuery)&sort=\(sort)&start=\(start)"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": Private.naverId,
            "X-Naver-Client-Secret": Private.naverPassword
        ]
        AF.request(url,headers: header).responseDecodable(of: Shopping.self) { response in
            switch response.result {
            case .success(let value):
                success(value)
            case .failure(let error):
                print(error)
                failure()
            }
        }
    }
}

