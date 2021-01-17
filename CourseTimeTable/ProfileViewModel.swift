//
//  UserInfoManager.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/15.
//

import UIKit
import RxSwift
import RxCocoa

// UserDefault Key
struct UserInfoKey {
    static let currentUser = "#CurrentUserName"
    static let userList = "#UserList"
    static let name = "#UserName"
    static let email = "#UserEmail"
    static let grade = "#UserGrade"
    static let semester = "#UserSemester"
    static let profileImage = "#UserProfileImage"
}


// UserInfo
class ProfileViewModel {
    
    // input & output
    let name = BehaviorSubject(value: "")
    let email = BehaviorSubject(value: "")
    let grade = BehaviorSubject(value: 1)
    let semester = BehaviorSubject(value: "")
    var profileImage = BehaviorSubject<UIImage?>(value: nil)
    
    // output
    let isEmptyName = BehaviorSubject(value: true)
    let registerString = BehaviorSubject(value: "")
    let profileInfo = BehaviorSubject<[String]>(value:[])
    
    init() {
        
        _ = self.name
            .map({ $0 == "" })
            .bind(to: self.isEmptyName)
        
        _ = Observable.just([self.grade, self.semester])
            .map({
                "\($0[0])학년 \($0[1])학기"
            })
            .bind(to: registerString)
        
    }
    
    func changeUser(name: String = "") {
        
        if name == "" {
            return
        }
        
        let customPlist = "\(name).plist"
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let path = paths[0] as NSString
        let filePath = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: filePath) ?? NSMutableDictionary()
        
        self.name.onNext(name)
        self.email.onNext(data.value(forKey: UserInfoKey.email) as? String ?? "")
        self.grade.onNext(data.value(forKey: UserInfoKey.grade) as? Int ?? 1)
        self.semester.onNext(data.value(forKey: UserInfoKey.semester) as? String ?? "")
        
        if let profileImageData = data.value(forKey: UserInfoKey.profileImage) as? Data {
            self.profileImage.onNext(UIImage(data: profileImageData))
        } else {
            self.profileImage.onNext(UIImage(systemName: "person.fill"))
        }
    }
    
    func deleteUser() {
        
        let name = UserDefaults.standard.string(forKey: UserInfoKey.currentUser) ?? ""
        
        let global = UIApplication.shared.delegate as? AppDelegate
        
        if let index = global?.userNameList.firstIndex(of: name) {
            
            let customPlist = "\(name).plist"
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            
            let path = paths[0] as NSString
            let filePath = path.strings(byAppendingPaths: [customPlist]).first!
            
            let filemanager = FileManager.default
            
            do {
                global?.userNameList.remove(at: index)
                UserDefaults.standard.setValue(global?.userNameList, forKey: UserInfoKey.userList)
                UserDefaults.standard.setValue("", forKey: UserInfoKey.currentUser)
                UserDefaults.standard.synchronize()
                
                self.name.onNext("")
                self.email.onNext("")
                self.grade.onNext(1)
                self.semester.onNext("")
                self.profileImage.onNext(UIImage.init(systemName: "person.fill"))
                
                try filemanager.removeItem(atPath: filePath)
                
                
            } catch {
                print("[Error \(#file):\(#function):\(#line)] 파일 삭제 \n\(filePath)\n\(error.localizedDescription)")
            }
            
            self.name.onNext("")
        }
    }
    
    func changeProfileImage(image: UIImage) {
        
        let name = UserDefaults.standard.string(forKey: UserInfoKey.currentUser) ?? ""
        
        let customPlist = "\(name).plist"
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let path = paths[0] as NSString
        let filePath = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: filePath) ?? NSMutableDictionary()
        
        data.setValue(image.pngData(), forKey: UserInfoKey.profileImage)
        data.write(toFile: filePath, atomically: true)
        
        self.profileImage.onNext(image)
    }
}
