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
    
    let filteredWebCatItems = BehaviorRelay(value: [WebCat]())
    
    let isEmptyCurrentUser = BehaviorRelay(value: false)
    
    var lastUserName = ""
    
    // MARK: - Init
    
    init() {
        currentUserNameTest
            .map({ $0 == "" })
            .bind(to: self.isEmptyCurrentUser)
            .disposed(by: self.bag)
    }
    
    // MARK: - Logic
    
    private func loadImage(item: WebCat) -> WebCat {
        Service.shared.requestWebCatImage(url: item.imageUrl) {
            item.image = $0
        }
        return item
    }
    
    func reLoadItems() {
        self.filteredWebCatItems
            .accept(self.webCatItems)
    }
    
    func loadUserData() {
        currentUserNameTest.accept(UserDefaults.standard.string(forKey: UserInfoKey.currentUser) ?? "")
        userNameListTest.accept(UserDefaults.standard.stringArray(forKey: UserInfoKey.userList) ?? [String]())
    }
    
    func loadWebCatDataByName() {
        // SQL(name) -> items 입력
        // items -> Image load
        // itemsWithImage -> WebCatItems
        
        let name = currentUserNameTest.value
        
        print("lastUserName", self.lastUserName)
        
        print("currentUserNameTest", name)
        
        if self.lastUserName == name {
            return
        }
        
        self.lastUserName = name
        
        print("isEmptyCurrentUser", self.isEmptyCurrentUser.value)
        
        if self.isEmptyCurrentUser.value {
            self.filteredWebCatItems.accept([])
            return
        }
        
        
        
        Observable.just(self.webCatItems)
            .subscribe(onNext: { items in
                
                items.map {
                    if $0.image == nil {
                        self.loadImage(item: $0)
                    }
                }
                
                print(items)
                
                self.filteredWebCatItems.accept(items)
            })
            .disposed(by: self.bag)
        
    }
}
