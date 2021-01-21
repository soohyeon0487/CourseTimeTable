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
    
    let filteredWebCatItems = BehaviorRelay(value: [WebCat]())
    
    let isEmptyCurrentUser = BehaviorRelay(value: false)
    
    // MARK: - Init
    
    init() {
        currentUserName
            .map({ $0 == "" })
            .bind(to: self.isEmptyCurrentUser)
            .disposed(by: self.bag)
    }
    
    // MARK: - Logic
    
    func reloadItems() {
        self.filteredWebCatItems
            .accept(webCatList.value)
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
        
        if self.isEmptyCurrentUser.value {
            self.filteredWebCatItems.accept([])
            return
        }
        
        webCatList.accept(self.manager.selectWebCatData(name: currentUserName.value) { result in
            if result {
                print(#function, #line, "SUCCESS : WEBCAT SELECT")
            } else {
                print(#function, #line, "ERROR : WEBCAT SELECT")
            }
        })
        
        self.filteredWebCatItems.accept(webCatList.value)
    }
    
    func loadWebCatImage() {
        
        var newList = [WebCat]()
        
        webCatList.value.forEach { item in
            
            if item.image == nil {
                Service.shared.requestWebCatImage(url: item.imageUrl) { data in
                    item.setImage(imageData: data)
                }
            }
            newList.append(item)
        }
        
        webCatList.accept(newList)
        filteredWebCatItems.accept(newList)
    }
    
    func addWebCat(newWebCat: WebCat) {
        
        self.manager.insertWebCatData(webCat: newWebCat)
        
        var newWebCatList = webCatList.value
        newWebCatList.append(newWebCat)
        webCatList.accept(newWebCatList)
        
        self.loadWebCatImage()
    }
}
