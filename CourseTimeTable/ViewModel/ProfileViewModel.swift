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
    
    let profile = BehaviorSubject(value: Profile(name: ""))
    
    let bag = DisposeBag()
    
    // MARK: - Logic
    
    func changeUser(name: String = "", completion: @escaping() -> Void) {
        
        if name == "" {
            return
        }
        
        let customPlist = "\(name).plist"
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let path = paths[0] as NSString
        let filePath = path.strings(byAppendingPaths: [customPlist]).first!
        let data = NSMutableDictionary(contentsOfFile: filePath) ?? NSMutableDictionary()
        
        self.profile
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { profile in
                
                profile.setName(name: name)
                profile.setProfile(
                    email: data.value(forKey: UserInfoKey.email) as? String ?? "",
                    grade: data.value(forKey: UserInfoKey.grade) as? Int ?? 1,
                    semester: data.value(forKey: UserInfoKey.semester) as? Int ?? 1
                )
                if let profileImageData = data.value(forKey: UserInfoKey.profileImage) as? Data {
                    profile.setImage(image: UIImage(data: profileImageData))
                } else {
                    profile.setImage(image: nil)
                }
            })
            .disposed(by: self.bag)
        
        completion()
    }
    
    func deleteUser(completion: @escaping() -> Void) {
        
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
                
                try filemanager.removeItem(atPath: filePath)
                
            } catch {
                print("[Error \(#file):\(#function):\(#line)] 파일 삭제 \n\(filePath)\n\(error.localizedDescription)")
            }
            
            self.profile
                .subscribe(on: MainScheduler.instance)
                .subscribe(onNext: { profile in
                    profile.clear()
                })
                .disposed(by: self.bag)
        }
        
        completion()
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
}
