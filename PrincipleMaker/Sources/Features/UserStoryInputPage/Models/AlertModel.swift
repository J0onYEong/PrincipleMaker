//
//  AlertModel.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/16/25.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let actions: [AlertAction]
}

extension AlertModel {
    struct AlertAction {
        let title: String
        let style: UIAlertAction.Style
        let completion: (() -> Void)?
        
        init(title: String, style: UIAlertAction.Style, completion: (() -> Void)? = nil) {
            self.title = title
            self.style = style
            self.completion = completion
        }
    }
}
