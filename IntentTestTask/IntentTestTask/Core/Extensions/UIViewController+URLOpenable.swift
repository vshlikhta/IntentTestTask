//
//  URLOpenable.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 08.06.2021.
//

import UIKit

protocol URLOpenable: AnyObject {
    func open(_ url: String?) throws
}

extension UIViewController: URLOpenable {
    func open(_ urlString: String?) throws {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            throw IntentTestTaskError.Internal.badURL
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
