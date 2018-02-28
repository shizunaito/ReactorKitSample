//
//  GitHubClient.swift
//  ReactorKitSample
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/02/25.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import Foundation

class GitHubClient {
    static func send<Request : GitHubRequest>(request: Request,
                                       completion: @escaping (Result<Request.Response, GitHubClientError>) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let urlRequest = request.buildURLRequest()
        let task = session.dataTask(with: urlRequest) {
            data, response, error in
            
            switch (data, response, error) {
            case (_, _, let error?):
                completion(Result(error: .connectionError(error)))
            case (let data?, let response?, _):
                do {
                    let response = try request.response(from: data, urlResponse: response)
                    completion(Result(value: response))
                } catch let error as GitHubAPIError {
                    completion(Result(error: .apiError(error)))
                } catch {
                    completion(Result(error: .responseParseError(error)))
                }
            default:
                fatalError("Invalid response combination \(data), \(response), \(error).")
            }
        }
        task.resume()
    }
}
