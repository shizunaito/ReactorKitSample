//
//  GitHubSeachViewReactorTest.swift
//  GitHubSeachViewReactorTest
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/02/25.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import XCTest
@testable import ReactorKitSample

class GitHubSeachViewReactorTest: XCTestCase {
    
    func testUpdateQuery() {
        let reactor = GitHubSeachViewReactor(gitHubService: MockGitHubService())
        reactor.action.onNext(.updateQuery("aaa"))
        XCTAssertEqual(reactor.currentState.quary, "aaa")
    }
    
    func testLoadNextPage() {
        let reactor = GitHubSeachViewReactor(gitHubService: MockGitHubService())
        reactor.action.onNext(.loadNextPage)
        XCTAssertEqual(reactor.currentState.isLoadingNextPage, false)
    }
}
