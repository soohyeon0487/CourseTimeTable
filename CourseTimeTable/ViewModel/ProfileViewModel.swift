//
//  UserInfoManager.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/15.
//

import RxSwift
import RxCocoa

class ProfileViewModel {
    
    let manager = UserDataManager.shared
    
    // MARK: - Property
    
    let profile = BehaviorRelay(value: User(name: ""))
    
    let isEmptyCurrentUser = BehaviorRelay(value: false)
    
    var userPickerRow = 0
    
    let bag = DisposeBag()
    
    // MARK: - Init
    
    init() {
        currentUserName
            .map({ $0 == "" })
            .bind(to: self.isEmptyCurrentUser)
            .disposed(by: self.bag)
    }
    
    // MARK: - Logic
    
    func changeUser(newUserName: String) {
        
        if newUserName == "" {
            return
        }
        
        Observable.from(userList.value)
            .filter {
                $0.name == newUserName
            }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.profile.accept($0)
            })
            .disposed(by: self.bag)
        
        webCatList.accept(self.manager.selectWebCatData(name: newUserName))
    }
    
    func deleteUser() {
        
        let deletingName = profile.value.name!
        
        self.profile.accept(User(name: ""))
    
        self.manager.deleteUserData(deletingName: deletingName) { result in
            if result {
                print(#function, #line, "SUCCESS : USERLIST DELETE")
            } else {
                print(#function, #line, "ERROR : USERLIST DELETE")
            }
        }
        
        currentUserName.accept("")
        userList.accept(self.manager.selectUserData())
        self.userPickerRow = 0
    }
    
    func changeProfileImage(image: UIImage) {
        
        let name = currentUserName.value
        guard let imageData = image.pngData() else {
            return
        }
        
        self.manager.updateUserData(updatingName: name, newImage: imageData) { result in
            if result {
                print(#function, #line, "SUCCESS : USERLIST DELETE")
            } else {
                print(#function, #line, "ERROR : USERLIST DELETE")
            }
        }
        
        userList.accept(self.manager.selectUserData())
        self.changeUser(newUserName: currentUserName.value)
    }
    
    func choiceUser(completion: @escaping(Bool) -> Void = { _ in }) {
        
        if self.userPickerRow >= userList.value.count {
            return
        }
        
        currentUserName.accept(userList.value[self.userPickerRow].name)
        UserDefaults.standard.setValue(userList.value[self.userPickerRow].name, forKey: UserInfoKey.currentUser)
        UserDefaults.standard.synchronize()
        self.changeUser(newUserName: currentUserName.value)
        
        completion(true)
    }
}
