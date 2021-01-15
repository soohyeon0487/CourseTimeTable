//
//  UserInfoManager.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/15.
//

import UIKit

// UserDefault Key
struct UserInfoKey {
    static let name = "UserName"
    static let email = "UserEmail"
    static let grade = "UserGrade"
    static let semester = "UserSemester"
    static let profileImage = "UserProfileImage"
}


// UserInfo
class UserInfo {
    
    var name: String? {
        get {
            let userDefault = UserDefaults.standard
            return userDefault.string(forKey: UserInfoKey.name)
        }
        set(input) {
            let userDefault = UserDefaults.standard
            userDefault.setValue(input, forKey: UserInfoKey.name)
            userDefault.synchronize()
        }
    }
    
    var email: String? {
        get {
            let userDefault = UserDefaults.standard
            return userDefault.string(forKey: UserInfoKey.email)
        }
        set(input) {
            let userDefault = UserDefaults.standard
            userDefault.setValue(input, forKey: UserInfoKey.email)
            userDefault.synchronize()
        }
    }
    
    var grade: Int? {
        get {
            let userDefault = UserDefaults.standard
            return userDefault.integer(forKey: UserInfoKey.grade)
        }
        set(input) {
            let userDefault = UserDefaults.standard
            userDefault.setValue(input, forKey: UserInfoKey.grade)
            userDefault.synchronize()
        }
    }
    
    var semester: String? {
        get {
            let userDefault = UserDefaults.standard
            return userDefault.string(forKey: UserInfoKey.semester)
        }
        
        set(input) {
            let userDefault = UserDefaults.standard
            userDefault.setValue(input, forKey: UserInfoKey.semester)
            userDefault.synchronize()
        }
    }
    
    var registerData: String? {
        if self.name == nil {
            return ""
        } else {
            return "\(self.grade)학년 \(self.semester)학기"
        }
        
    }
    
    var profileImage: UIImage? {
        get {
            let userDefault = UserDefaults.standard
            
            if let image = userDefault.data(forKey: UserInfoKey.profileImage) {
                return UIImage(data: image)
            }
            return UIImage(systemName: "person.fill")
        }
        set(input) {
            let userDefault = UserDefaults.standard
            userDefault.setValue(input, forKey: UserInfoKey.profileImage)
            userDefault.synchronize()
        }
    }
}
