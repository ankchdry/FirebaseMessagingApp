//
//  UIImage+Extensions.swift
//  FirebaseMessagingApp
//
//  Created by Ankit Chaudhary on 24/05/20.
//  Copyright © 2020 webdevlopia. All rights reserved.
//

import Foundation
import AlamofireImage
extension UIImageView {
    func setImage(for url: String) {
        guard let url = URL.init(string: url) else { return }
        var urlRequest = URLRequest.init(url: url)
        self.af_setImage(withURLRequest: urlRequest)
    }
}
