//
//  UserDataManager.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/20.
//

import RxSwift
import RxCocoa
import RealmSwift

//class

let currentUserName = BehaviorRelay(value: "")

let userList = BehaviorRelay(value: [User]())

class UserData: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    @objc dynamic var grade = 0
    @objc dynamic var semester = 0
    @objc dynamic var image = Data()
    
    override static func primaryKey() -> String? {
        return "name"
    }
}

class WebCatData: Object {
    
    @objc dynamic var uuid = UUID().uuidString
    @objc dynamic var userName = ""
    @objc dynamic var title = ""
    @objc dynamic var width = 0
    @objc dynamic var height = 0
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}

class UserDataManager {
    
    // MARK: - Singleton
    
    static let shared = UserDataManager()
    
    // MARK: - Property
    
    var realm: Realm!
    
    // MARK: - Init
    
    init() {
        
        print(getDocumentsDirectory())
        
        do {
            realm = try Realm()
        } catch {
            print("ERROR : Realm - \(error.localizedDescription)")
        }
        
        currentUserName.accept(UserDefaults.standard.string(forKey: UserInfoKey.currentUser) ?? "")
    }
    
    // MARK: - Method
    
    func insertUserData(newUser: User, completion: @escaping (Bool) -> Void = { _ in }) {
        
        let newUserData = UserData()
        
        newUserData.name = newUser.name
        newUserData.email = newUser.email!
        newUserData.grade = newUser.grade!
        newUserData.semester = newUser.semester!
        
        do {
            try realm.write {
                realm.add(newUserData)
            }
        } catch {
            completion(false)
        }
        
        completion(true)
    }
    
    func selectUserData(completion: @escaping (Bool) -> Void = { _ in }) -> [User] {
        
        let userData = realm.objects(UserData.self).sorted(byKeyPath: "name", ascending: true)
        
        var newUserList = [User]()
        
        userData.forEach {
            let newUser = User(name: $0.name)
            newUser.email = $0.email
            newUser.grade = $0.grade
            newUser.semester = $0.semester
            
            if $0.image.count == 0 {
                newUser.image = UIImage(systemName: "person.fill")
            } else {
                newUser.image = UIImage(data:$0.image)
            }
            
            newUserList.append(newUser)
        }
        
        completion(true)
        
        return newUserList
    }
    
    func updateUserData(updatingName: String, newImage: Data, completion: @escaping (Bool) -> Void = { _ in }) {
        
        let updatingUserData = realm.objects(UserData.self).filter("name CONTAINS[cd] %@", updatingName).first
        
        do {
            try realm.write {
                updatingUserData?.image = newImage
            }
        } catch {
            completion(false)
        }
        
        completion(true)
    }
    
    func deleteUserData(deletingName: String, completion: @escaping (Bool) -> Void = { _ in }) {
        
        let deletingUserData = realm.objects(UserData.self).filter("name CONTAINS[cd] %@", deletingName)
        
        let deletingWebCatData = realm.objects(WebCatData.self).filter("userName CONTAINS[cd] %@", deletingName)
        
        do {
            try realm.write {
                realm.delete(deletingUserData)
                realm.delete(deletingWebCatData)
            }
        } catch {
            completion(false)
        }
        
        completion(true)
    }
    
    func selectWebCatData(name: String = "", completion: @escaping (Bool) -> Void = { _ in }) -> [WebCat] {
        
        let webCatData = realm.objects(WebCatData.self).filter("userName CONTAINS[cd] %@", currentUserName.value)
        
        var newWebCatList = [WebCat]()
        
        webCatData.forEach {
            newWebCatList.append(WebCat.init(title: $0.title, width: $0.width, height: $0.height))
        }
        
        completion(true)
        
        return newWebCatList
    }
    
    func insertWebCatData(webCat: WebCat, completion: @escaping (Bool) -> Void = { _ in }) {
        
        let newWebCatData = WebCatData()
    
        newWebCatData.userName = currentUserName.value
        newWebCatData.title = webCat.title
        newWebCatData.width = webCat.width!
        newWebCatData.height = webCat.height!
        
        do {
            try realm.write {
                realm.add(newWebCatData)
            }
        } catch {
            completion(false)
        }
        
        completion(true)
    }
    
    func deleteWebCatData(webCatUUID: UUID, completion: @escaping (Bool) -> Void = { _ in }) {
        
        let webCatData = realm.objects(WebCatData.self).filter("uuid CONTAINS[cd] %@", webCatUUID)
        
        do {
            try realm.write {
                realm.delete(webCatData)
            }
        } catch {
            completion(false)
        }
        
        completion(true)
    }
    
    // MARK: - ETC
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
