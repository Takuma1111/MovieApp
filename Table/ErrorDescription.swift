//
//  ErrorDescription.swift
//  MovieApp
//
//  Created by 村上拓麻 on 2019/03/01.
//  Copyright © 2019 村上拓麻. All rights reserved.
//

import Foundation

enum error {
    case responseError
    case conectionError
    
}

extension error:LocalizedError{
    var error_description : String?{
        switch self {
        case .responseError:
            return "情報が見つかりませんでした。"
        case .conectionError:
            return "接続できませんでした。"
        }
    }
}
