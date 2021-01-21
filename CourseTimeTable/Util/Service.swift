//
//  Service.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/19.
//

import UIKit

class Service {
    
    // MARK: - Singleton
    
    static let shared = Service()
    
    // MARK: - Method
    
    func requestWebCatImage(url: String, completion: @escaping(Data) -> Void) {
        
        self.requestUrl(with: url) { data in
            
            if data.count == 0 {
                return
            }
            
            completion(data)
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
