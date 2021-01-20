//
//  WebCatViewModel.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/19.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class WebCatViewModel {
    
    // MARK: - Property
    
    var bag = DisposeBag()
    
    var webCatItems = [
        WebCat(title: "Test1", width: 100, height: 150),
        WebCat(title: "Test2", width: 250, height: 200),
        WebCat(title: "Test3", width: 300, height: 300)
    ]
    let filteredWebCatItems = BehaviorSubject(value: [WebCat]())
    
    // MARK: - Init
    
    
    // MARK: - Logic
    
    
    private func loadImage(item: WebCat) -> WebCat {
        Service.shared.requestWebCatImage(url: item.imageUrl) {
            item.image = $0
        }
        return item
    }
    
    func resetFilter() {
        
        self.filteredWebCatItems
            .onNext(self.webCatItems)
    }
    
    func loadDataByName(name: String) {
        
        // SQL(name) -> items 입력
        // items -> Image load
        // itemsWithImage -> WebCatItems
        
        print(self.webCatItems)
        
        Observable.just(self.webCatItems)
            .subscribe(onNext: { items in
                
                items.map {
                    if $0.image == nil {
                        self.loadImage(item: $0)
                    }
                }
                
                self.filteredWebCatItems.onNext(items)
            })
            .disposed(by: self.bag)
        
    }
}
