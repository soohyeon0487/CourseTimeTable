//
//  Service.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/19.
//

import Foundation
import UIKit

class Service {

    static let shared = Service()
    
    func requestWebCatImage(url: String, completion: @escaping(UIImage) -> ()) {
        
        self.requestUrl(with: url) { data in
            
            guard let image = UIImage(data: data) else { return }
            
            completion(image)
        }
    }
    
    private func requestUrl(with urlString: String, completion: @escaping(Data) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Failed to fetch pokemon with error: ", error)
                return
            }
            
            guard let data = data else { return }
            
            completion(data)
            
        }.resume()
    }
}
