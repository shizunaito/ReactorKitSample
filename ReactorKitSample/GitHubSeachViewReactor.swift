//
//  GitHubSeachViewReactor.swift
//  ReactorKitSample
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/02/21.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class GitHubSeachViewReactor: Reactor {
    enum Action {
        case updateQuery(String?)
        case loadNextPage
    }
    
    enum Mutation {
        case setQuery(String?)
        case setRepos([String], nextPage: Int?)
        case appendRepos([String], nextPage: Int?)
        case setLoadingNextPage(Bool)
    }
    
    struct State {
        var quary: String?
        var repos: [String] = []
        var nextPage: Int?
        var isLoadingNextPage = false
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateQuery(let query):
            return Observable.concat([
                Observable.just(Mutation.setQuery(query)),
                self.serach(query: query, page: 1)
                    .takeUntil(self.action.filter(isUpdateQueryAction))
                    .map { Mutation.setRepos($0, nextPage: $1) }
            ])
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() }
            guard let page = self.currentState.nextPage else { return Observable.empty() }
            return Observable.concat([
                    Observable.just(Mutation.setLoadingNextPage(true)),
                    self.serach(query: self.currentState.quary, page: page)
                        .takeUntil(self.action.filter(isUpdateQueryAction))
                        .map { Mutation.appendRepos($0, nextPage: $1) },
                    Observable.just(Mutation.setLoadingNextPage(false))
                ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setQuery(query):
            var newState = state
            newState.quary = query
            return newState
        case let .setRepos(repos, nextPage):
            var newState = state
            newState.repos = repos
            newState.nextPage = nextPage
            return newState
        case let .appendRepos(repos, nextPage):
            var newState = state
            newState.repos.append(contentsOf: repos)
            newState.nextPage = nextPage
            return newState
        case let .setLoadingNextPage(isLoadingNextPage):
            var newState = state
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
        }
    }
    
    private func url(for query: String?, page: Int) -> URL? {
        guard let query = query, !query.isEmpty else { return nil }
        return URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page)")
    }
    
    private func serach(query: String?, page: Int) -> Observable<(repos: [String], nextPage: Int?)> {
        let emptyResult: ([String], Int?) = ([], nil)
        guard let url = self.url(for: query, page: page) else { return Observable.just(emptyResult) }
        return URLSession.shared.rx.json(url: url)
            .map { json -> ([String], Int?) in
                guard let dict = json as? [String : Any] else { return emptyResult }
                guard let items = dict["items"] as? [[String : Any]] else { return emptyResult }
                let repos = items.flatMap { $0["full_name"] as? String}
                let nextPage = repos.isEmpty ? nil : page + 1
                return(repos, nextPage)
            }
            .do(onError: { error in
                if case let .some(.httpRequestFailed(response, _)) = error as? RxCocoaURLError, response.statusCode == 403 {
                    print("warning")
                }
            })
            .catchErrorJustReturn(emptyResult)
    }
    
    private func isUpdateQueryAction(_ action: Action) -> Bool {
        if case .updateQuery = action {
            return true
        } else {
            return false
        }
    }
}
