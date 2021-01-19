//
//  WebCat.swift
//  
//
//  Created by Soohyeon Lee on 2021/01/19.
//

import Foundation
import UIKit

let BaseURL = "https://placekitten.com/"

class WebCat {
    
    var title: String!
    var width: Int?
    var height: Int?
    var imageUrl: String!
    var image: UIImage?
    
    init(title: String, width: Int, height: Int) {
        self.title = title
        self.width = width
        self.height = height
        self.imageUrl = BaseURL + "\(width)/\(height)"
    }
    
    func setImage(image: UIImage) {
        self.image = image
    }
}