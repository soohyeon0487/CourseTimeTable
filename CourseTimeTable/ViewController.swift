//
//  ViewController.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let userName: String? = nil
    
    //Test
    let testLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadUserList()
        
        let addBtn = UIBarButtonItem()
        
        let profileBtnImage = UIImage(systemName: "person.fill")
        
        addBtn.image = profileBtnImage
        addBtn.target = self
        addBtn.tintColor = .lightGray
        addBtn.action = #selector(self.showProfileView(_:))
        
        self.navigationItem.rightBarButtonItem = addBtn
        
        // View
        
        let test = UILabel()
        test.text = "100"
        
        /// AddCourseBtn
        self.drawAddCourseBtn()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let name = UserDefaults.standard.string(forKey: UserInfoKey.currentUser) ?? ""
        
        self.navigationItem.title = "\(name != "" ? name : "Guest")님의 강의 시간표"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
    }
    
    func loadUserList() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let userDefault = UserDefaults.standard
        let savedUserList = userDefault.stringArray(forKey: UserInfoKey.userList)
        
        if savedUserList?.count == 0 {
            return
        }
        
        savedUserList.map {
            appDelegate.userNameList.append(contentsOf: $0)
        }
    }
    
    
    func drawAddCourseBtn() {
        
        let addCourseBtn = UIButton(type: .system)
        
        addCourseBtn.setImage(UIImage(systemName: "plus"), for: .normal)
        addCourseBtn.tintColor = .black
        addCourseBtn.backgroundColor = .lightGray
        
        addCourseBtn.layer.cornerRadius = 25
        addCourseBtn.layer.shadowColor = UIColor.black.cgColor
        addCourseBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
        addCourseBtn.layer.shadowRadius = 3
        addCourseBtn.layer.shadowOpacity = 1
        
        addCourseBtn.addTarget(self, action: #selector(self.showAddCourseView(_:)), for: .touchUpInside)
        
        self.view.addSubview(addCourseBtn)
        
        addCourseBtn.snp.makeConstraints({ btn in
            btn.width.equalTo(50)
            btn.height.equalTo(50)
            btn.centerX.equalTo(self.view.snp.right).offset(-50)
            btn.centerY.equalTo(self.view.snp.bottom).offset(-50)
        })
        
    }

    // 프로필 화면
    @objc func showProfileView(_ sender: UIBarButtonItem) {
        
        guard let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileView") as? ProfileViewController else {
            return
        }
        
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    // 수강 과목 추가 화면
    @objc func showAddCourseView(_ sender: UIBarButtonItem) {
        
        guard let addCourseVC = self.storyboard?.instantiateViewController(withIdentifier: "AddCourseView") as? AddCourseViewController else {
            return
        }
        
        self.navigationController?.pushViewController(addCourseVC, animated: true)
    }
}

