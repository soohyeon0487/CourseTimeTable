//
//  WebCat.swift
//  
//
//  Created by Soohyeon Lee on 2021/01/19.
//

import UIKit

let BaseURL = "https://placekitten.com/"

class WebCat {
    
    // MARK: - Property
    
    var id = UUID()
    var title: String!
    var width: Int?
    var height: Int?
    var imageUrl: String!
    var image: UIImage?
    
    // MARK: - Init
    
    init(title: String, width: Int, height: Int) {
        self.title = title
        self.width = width
        self.height = height
        self.imageUrl = BaseURL + "\(width)/\(height)"
    }
    
    // MARK: - Method
    
    func setImage(imageData: Data) {
        self.image = UIImage(data: imageData)
    }
}
