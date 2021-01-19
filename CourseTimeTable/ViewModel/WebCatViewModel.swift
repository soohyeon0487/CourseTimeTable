//
//  WebCatViewModel.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/19.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa

class WebCatViewModel {
    
    // MARK: - Property
    
    var bag = DisposeBag()
    
    let webCatItems = BehaviorRelay(value: [WebCat]())
    let filteredWebCatItems = BehaviorRelay(value: [WebCat]())
    
    // MARK: - Init
    
    
    // MARK: - Logic
    
    func resetFilter() {
        self.filteredWebCatItems.accept(self.webCatItems.value)
    }
    
    func loadData() {
        
        let items = [WebCat]()
        
        // SQL -> webCatItems 입력
        
        // WebCatItems -> Image load
//        self.webCatItems
//            .subscribe(onNext: { items in
//                items.map { item in
//                    Service.shared.requestWebCatImage(url: item.imageUrl) { image in
//                        item.image = image
//                    }
//                }
//            })
//            .disposed(by: self.bag)
    }
}
