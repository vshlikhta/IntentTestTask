//
//  URLResponse+StatusCode.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 11.06.2021.
//

import Foundation

extension URLResponse {
    var statCode: Int? {
        return (self as? HTTPURLResponse)?.statusCode
    }
}
