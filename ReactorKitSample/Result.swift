//
//  Result.swift
//  ReactorKitSample
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/02/25.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

enum Result<T, Error : Swift.Error> {
    case success(T)
    case failure(Error)
    
    init(value: T) {
        self = .success(value)
    }
    
    init(error: Error) {
        self = .failure(error)
    }
}
