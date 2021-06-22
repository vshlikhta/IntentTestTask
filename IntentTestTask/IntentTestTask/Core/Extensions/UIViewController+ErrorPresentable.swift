//
//  UIViewController+ErrorPresentable.swift
//  IntentTestTask
//
//  Created by Volodymyr Shlikhta on 22.06.2021.
//

import UIKit

typealias EmptyBlock = () -> Void

protocol ErrorPresentable: AnyObject {
    func show(alert: IntentTestTaskAlert)
    func show(alert: IntentTestTaskAlert, onTap: @escaping EmptyBlock)
    func show(alert: IntentTestTaskAlert, onTap: @escaping (Bool) -> Void)
}

extension UIViewController: ErrorPresentable {
    func show(alert: IntentTestTaskAlert) {
        show(alert: alert, onTap: { })
    }
    
    func show(alert: IntentTestTaskAlert, onTap: @escaping EmptyBlock) {
        let controller = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            controller.dismiss(animated: true, completion: nil)
            onTap()
        }))
        Executor.main.execute {
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func show(alert: IntentTestTaskAlert, onTap: @escaping (Bool) -> Void) {
        let controller = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            controller.dismiss(animated: true, completion: nil)
            onTap(true)
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            controller.dismiss(animated: true, completion: nil)
            onTap(false)
        }))
        Executor.main.execute {
            self.present(controller, animated: true, completion: nil)
        }
        
    }
}
