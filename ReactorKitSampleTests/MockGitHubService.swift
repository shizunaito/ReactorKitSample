//
//  MockGitHubService.swift
//  ReactorKitSampleTests
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/02/25.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

@testable import ReactorKitSample
import RxSwift
import RxTest

class MockGitHubService: GitHubServiceType {
    func serach(query: String?, page: Int) -> Observable<(repos: [String], nextPage: Int?)> {
        let emptyResult: ([String], Int?) = ([], nil)
        guard let query = query else {
            return Observable.just(emptyResult)
        }
        let result: ([String], Int?) = ([query], page + 1)
        return Observable.just(result)
    }
}
