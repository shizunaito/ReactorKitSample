//
//  GitHubService.swift
//  ReactorKitSample
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/02/23.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import RxSwift
import RxCocoa

protocol GitHubServiceType {
    func serach(query: String?, page: Int) -> Observable<(repos: [String], nextPage: Int?)>
}

final class GitHubService: GitHubServiceType {

    private func url(for query: String?, page: Int) -> URL? {
        guard let query = query, !query.isEmpty else { return nil }
        return URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page)")
    }

    func serach(query: String?, page: Int) -> Observable<(repos: [String], nextPage: Int?)> {
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

        /*
        let client = GitHubClient()
        let request = GitHubAPI.SearchRepositories(keyword: "aaa")
        client.send(request: request) { result in
            switch result {
            case let .success(response):
                for item in response.items {
                    print(item.owner.login)
                }
            case let .failure(error):
                print(error)
            }
        }
        */
    }
}
