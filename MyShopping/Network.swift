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

