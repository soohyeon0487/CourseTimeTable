//
//  ProfileInfo.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/18.
//

import UIKit

// MARK: - Enum

struct UserInfoKey {
    static let currentUser = "#CurrentUserName"
    static let userList = "#UserList"
    static let name = "#UserName"
    static let email = "#UserEmail"
    static let grade = "#UserGrade"
    static let semester = "#UserSemester"
    static let profileImage = "#UserProfileImage"
}

// MARK: - Class

class Profile {
    
    static let profile = Profile(name: "")
    
    var name: String!
    var email: String?
    var grade: Int?
    var semester: Int?
    var image: UIImage?
    
    init(name: String) {
        self.name = name
        self.image = UIImage(systemName: "person.fill")
    }
    
    func setName(name: String?) {
        if let inputName = name {
            self.name = inputName
        }
    }
    
    func setEmail(email: String?) {
        if let inputEmail = email {
            self.email = inputEmail
        }
    }
    
    func setGrade(grade: Int?) {
        if let inputGrade = grade {
            self.grade = inputGrade
        }
    }
    
    func setSemester(semester: Int?) {
        if let inputSemester = semester {
            self.semester = inputSemester
        }
    }
    
    func setProfile(email: String?, grade: Int?, semester: Int?) {
        
        self.setEmail(email: email)
        
        self.setGrade(grade: grade)
        
        self.setSemester(semester: semester)
    }
    
    func setImage(image: UIImage?) {
        
        guard let inputImage = image else {
            self.image = UIImage(systemName: "person.fill")
            return
        }
        
        self.image = inputImage
    }
    
    func clear() {
        self.name = ""
        self.email = ""
        self.grade = 0
        self.semester = 0
        self.image = UIImage(systemName: "person.fill")
    }
}
