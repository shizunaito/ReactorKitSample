//
//  GitHubSearchViewControllerTests.swift
//  ReactorKitSampleTests
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/02/25.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import XCTest
@testable import ReactorKitSample

class GitHubSearchViewControllerTests: XCTestCase {
    var viewController = GitHubSearchViewController()
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "GitHubSearchViewController") as! GitHubSearchViewController
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testState_repos() {
        let reactor = GitHubSeachViewReactor(gitHubService: GitHubService())
        reactor.stub.isEnabled = true
        
        viewController.reactor = reactor
        
        reactor.stub.state.value = GitHubSeachViewReactor.State(quary: "", repos: ["aaa", "bbb"], nextPage: 0, isLoadingNextPage: false)
        
        XCTAssertEqual(viewController.tableView.visibleCells.first?.textLabel?.text, "aaa")
    }
}
