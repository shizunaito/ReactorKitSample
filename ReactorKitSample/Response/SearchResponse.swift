//
//  SearchResponse.swift
//  ReactorKitSample
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/02/25.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

struct SearchResponse<Item : Decodable> : Decodable {
    let totalCount: Int
    let items: [Item]
    
    enum codingKeys : String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}
