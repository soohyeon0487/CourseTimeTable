//
//  createUserViewModel.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/16.
//

import RxSwift
import RxCocoa

class CreateUserViewModel {
    
    // MARK: - Property
    
    var appDelegate: AppDelegate? = nil
    
    let profile = BehaviorSubject(value: Profile(name: ""))
    
    let bag = DisposeBag()
    
    // input
    let nameText = BehaviorSubject(value: "")
    let emailText = BehaviorSubject(value: "")
    let gradeValue = BehaviorSubject(value: 1)
    let semesterValue = BehaviorSubject(value: 0)
    
    // output
    let isNameValid = BehaviorSubject(value: false)
    let isEmailValid = BehaviorSubject(value: false)
    let isValid = BehaviorSubject(value: false)
    
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
    
    func createUser(completion: @escaping() -> ()) {
        
        // 이름으로 생성된 plist 파일에 저장
        var customPlist = ""
        
        self.nameText
            .subscribe(onNext: {
                customPlist = "\($0).plist"
                self.appDelegate?.userNameList.append($0)
                UserDefaults.standard.setValue($0, forKey: UserInfoKey.currentUser)
                UserDefaults.standard.setValue(self.appDelegate?.userNameList, forKey: UserInfoKey.userList)
                UserDefaults.standard.synchronize()
            })
            .disposed(by: self.bag)
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let path = paths[0] as NSString
        let filePath = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: filePath) ?? NSMutableDictionary()
        
        self.nameText
            .subscribe(onNext: {
                data.setValue($0, forKey: UserInfoKey.name)
            })
            .disposed(by: self.bag)
        
        self.emailText
            .subscribe(onNext: {
                data.setValue($0, forKey: UserInfoKey.email)
            })
            .disposed(by: self.bag)
        
        self.gradeValue
            .subscribe(onNext: {
                data.setValue($0, forKey: UserInfoKey.grade)
            })
            .disposed(by: self.bag)
        
        self.semesterValue
            .subscribe(onNext: {
                data.setValue($0, forKey: UserInfoKey.semester)
            })
            .disposed(by: self.bag)
        
        data.write(toFile: filePath, atomically: true)
        
        completion()
    }
}
