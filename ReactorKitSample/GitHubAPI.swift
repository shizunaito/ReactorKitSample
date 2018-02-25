//
//  GitHubAPI.swift
//  ReactorKitSample
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/02/25.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import Foundation

final class GitHubAPI {
    struct SearchRepositories : GitHubRequest {
        let keyword: String
        typealias Response = SearchResponse<Repository>
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/search/repositories"
        }
        
        var queryItems: [URLQueryItem] {
            return [URLQueryItem(name: "q", value: "keyword")]
        }
    }
}
