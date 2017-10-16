//
//  BasicAlertController.swift
//  Villa Contessa Phone
//
//  Created by Nimble Chapps on 4/4/17.
//  Copyright © 2017 Nimblechapps. All rights reserved.
//

import UIKit

extension UIAlertController {
    typealias EmptyBlock = (() -> Void)?
    
    func alertControllerWithTitle(_ title: String?, message msg: String?, okButtonTitle okTitle: String, okBlockHandler okBlock:(EmptyBlock), viewController controller:UIViewController?) {
        alertControllerWithTitle(title, message: msg, okButtonTitle: okTitle, okBlockHandler: okBlock, cancelButtonTitle: "", cancelBlockHandler: nil, viewController: controller)
    }
    
    func alertControllerWithTitle(_ title: String?, message msg: String?, okButtonTitle okTitle: String, okBlockHandler okBlock:(EmptyBlock), cancelButtonTitle cancelTitle: String, cancelBlockHandler cancelBlock:(EmptyBlock), viewController controller:UIViewController?) {
        
        let alertController = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction.init(title: okTitle, style: .default) { (UIAlertAction) in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                okBlock!()
            }
        }
        
        if !cancelTitle.isEmpty {
            let cancelAction = UIAlertAction.init(title: cancelTitle, style: .cancel) { (UIAlertAction) in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    cancelBlock!()
                }
            }
            alertController.addAction(cancelAction)
        }
        
        alertController.addAction(okAction)
        
        if controller == nil {
            appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        else {
            controller?.present(alertController, animated: true, completion: nil)
        }
    }
}
