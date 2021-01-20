//
//  UserInfoManager.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/15.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewModel {
    
    // MARK: - Property
    
    let profile = BehaviorRelay(value: Profile(name: ""))
    
    let isEmptyCurrentUser = BehaviorRelay(value: false)
    
    let userPickerRow = BehaviorSubject(value: 0)
    
    let bag = DisposeBag()
    
    // MARK: - Init
    
    init() {
        currentUserNameTest
            .map({ $0 == "" })
            .bind(to: self.isEmptyCurrentUser)
            .disposed(by: self.bag)
    }
    
    // MARK: - Logic
    
    func changeUser(name: String) {
        
        if name == "" {
            return
        }
        
        let customPlist = "\(name).plist"
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let path = paths[0] as NSString
        let filePath = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: filePath) ?? NSMutableDictionary()
        
        Observable.just(name)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { newName in
                
                let newProfile = Profile(name: newName)
                
                newProfile.setProfile(
                    email: data.value(forKey: UserInfoKey.email) as? String ?? "",
                    grade: data.value(forKey: UserInfoKey.grade) as? Int ?? 1,
                    semester: data.value(forKey: UserInfoKey.semester) as? Int ?? 1
                )
                
                if let profileImageData = data.value(forKey: UserInfoKey.profileImage) as? Data {
                    newProfile.setImage(image: UIImage(data: profileImageData))
                } else {
                    newProfile.setImage(image: nil)
                }
                
                self.profile.accept(newProfile)
            })
            .disposed(by: self.bag)
    }
    
    func deleteUser() {
        
        print("")
        
        let name = currentUserNameTest.value
        
        if let index = userNameListTest.value.firstIndex(of: name) {
            
            let customPlist = "\(name).plist"
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            
            let path = paths[0] as NSString
            let filePath = path.strings(byAppendingPaths: [customPlist]).first!
            
            let filemanager = FileManager.default
            
            do {
                currentUserNameTest.accept("")
                UserDefaults.standard.setValue(currentUserNameTest.value, forKey: UserInfoKey.currentUser)
                
                var newUserListTest = userNameListTest.value
                newUserListTest.remove(at: index)
                userNameListTest.accept(newUserListTest)
                UserDefaults.standard.setValue(userNameListTest.value, forKey: UserInfoKey.userList)
                UserDefaults.standard.synchronize()
                
                self.profile
                    .subscribe(on: MainScheduler.instance)
                    .subscribe(onNext: { profile in
                        profile.clear()
                    })
                    .disposed(by: self.bag)
                
                try filemanager.removeItem(atPath: filePath)
                
            } catch {
                print("[Error \(#file):\(#function):\(#line)] 파일 삭제 \n\(filePath)\n\(error.localizedDescription)")
            }
            
            
        }
    }
    
    func changeProfileImage(image: UIImage, completion: @escaping() -> Void) {
        
        let name = UserDefaults.standard.string(forKey: UserInfoKey.currentUser) ?? ""
        
        let customPlist = "\(name).plist"
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let path = paths[0] as NSString
        let filePath = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: filePath) ?? NSMutableDictionary()
        
        data.setValue(image.pngData(), forKey: UserInfoKey.profileImage)
        data.write(toFile: filePath, atomically: true)
        
        self.profile
            .subscribe(on: MainScheduler.instance)
            .subscribe( onNext: { profile in
                profile.setImage(image: image)
            })
            .disposed(by: self.bag)
        
        completion()
    }
    
    func choiceUser(completion: @escaping(Bool) -> Void) {
        
        var result = true
        
        self.userPickerRow
            .subscribe(onNext: {
                currentUserNameTest.accept(userNameListTest.value[$0])
                UserDefaults.standard.setValue(userNameListTest.value[$0], forKey: UserInfoKey.currentUser)
                UserDefaults.standard.synchronize()
                self.changeUser(name: currentUserNameTest.value)
            })
            .disposed(by: self.bag)
        
        completion(result)
    }
}
