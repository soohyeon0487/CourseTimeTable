//
//  WebCatViewModel.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/19.
//

import RxSwift
import RxCocoa

class WebCatViewModel {
    
    let manager = UserDataManager.shared
    
    // MARK: - Property
    
    var bag = DisposeBag()
    
    var webCatItems = [WebCat]()
    
    let filteredWebCatItems = BehaviorRelay(value: [WebCat]())
    
    let isEmptyCurrentUser = BehaviorRelay(value: false)
    
    var lastUserName = ""
    
    // MARK: - Init
    
    init() {
        currentUserName
            .map({ $0 == "" })
            .bind(to: self.isEmptyCurrentUser)
            .disposed(by: self.bag)
    }
    
    // MARK: - Logic
    
    private func loadImage(item: WebCat) {
        Service.shared.requestWebCatImage(url: item.imageUrl) {
            item.image = $0
        }
    }
    
    func reLoadItems() {
        self.filteredWebCatItems
            .accept(self.webCatItems)
    }
    
    func loadUserData() {
        userList.accept(manager.selectUserData() {result in
            if result {
                print(#function, #line, "SUCCESS : USERLIST SELECT")
            } else {
                print(#function, #line, "ERROR : USERLIST SELECT")
            }
        })
    }
    
    func loadWebCatDataByName() {
        
        let name = currentUserName.value
        
        if self.lastUserName == name {
            return
        }
        
        self.lastUserName = name
        
        if self.isEmptyCurrentUser.value {
            self.filteredWebCatItems.accept([])
            return
        }
        
        self.webCatItems = self.manager.selectWebCatData(name: name) { result in
            if result {
                print(#function, #line, "SUCCESS : WEBCAT SELECT")
            } else {
                print(#function, #line, "ERROR : WEBCAT SELECT")
            }
        }
        
        Observable.just(self.webCatItems)
            .subscribe(onNext: { items in
                
                _ = items.map {
                    if $0.image == nil {
                        self.loadImage(item: $0)
                    }
                }
                
                self.filteredWebCatItems.accept(items)
            })
            .disposed(by: self.bag)
        
    }
}
