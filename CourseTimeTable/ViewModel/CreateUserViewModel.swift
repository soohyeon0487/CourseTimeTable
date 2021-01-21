//
//  createUserViewModel.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/16.
//

import RxSwift
import RxCocoa

class CreateUserViewModel {
    
    let manager = UserDataManager.shared
    
    // MARK: - Property
    
    var appDelegate: AppDelegate? = nil
    
    let bag = DisposeBag()
    
    // input
    let nameText = BehaviorRelay(value: "")
    let emailText = BehaviorRelay(value: "")
    let gradeValue = BehaviorRelay(value: 1)
    let semesterValue = BehaviorRelay(value: 0)
    
    // output
    let isNameValid = BehaviorSubject(value: false)
    let isEmailValid = BehaviorSubject(value: false)
    let isValid = BehaviorSubject(value: false)
    
    // MARK: - Init
    
    init() {
        
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        _ = self.nameText.distinctUntilChanged()
            .map(self.checkName)
            .bind(to: self.isNameValid)
        
        _ = self.emailText.distinctUntilChanged()
            .map(self.checkEmail)
            .bind(to: self.isEmailValid)
        
        _ = Observable.combineLatest(self.isNameValid, self.isEmailValid) { $0 && $1 }
            .bind(to: self.isValid)
    }
    
    // MARK: - Logic
    
    private func checkName(_ name:String) -> Bool {
        return name.count >= 2
    }
    
    private func checkEmail(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func createUser(completion: @escaping() -> Void = { }) {
        
        let newUser = User(name: self.nameText.value)
        newUser.setProfile(email: self.emailText.value,
                           grade: self.gradeValue.value,
                           semester: self.semesterValue.value)
        
        self.manager.insertUserData(newUser: newUser) { result in
            if result {
                print(#function, #line, "SUCCESS : USERLIST INSERT")
            } else {
                print(#function, #line, "ERROR : USERLIST INSERT")
            }
        }
        
        userList.accept(self.manager.selectUserData())
        currentUserName.accept(newUser.name)
        
        completion()
    }
}
