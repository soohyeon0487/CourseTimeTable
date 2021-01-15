//
//  ProfileViewController.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/15.
//

import UIKit


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let PROFILE_IMAGE_WIDTH: CGFloat = 200
    
    let userInfo = UserInfo()
    
    let profileImageView = UIImageView()
    let userInfoTableView = UITableView()
    
    let removeUserBtn = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.drawNavigationBarItem()
        self.drawProfileImageView()
        self.drawUserInfoTableView()
        self.drawRemoveUserButton()
    }
    
    func drawNavigationBarItem() {
        
        self.navigationItem.title = "사용자 정보"
        
        let createBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showCreateUserView(_:)))
        
        self.navigationItem.rightBarButtonItem = createBtn
    }
    
    @objc func showCreateUserView(_ sender: Any) {
        
        guard let createUserVC = self.storyboard?.instantiateViewController(withIdentifier: "_CreateUserView") else {
            return
        }
        
        createUserVC.modalPresentationStyle = .fullScreen
        
        self.present(createUserVC, animated: true)
    }
    
    
    
    // ProfileView
    func drawProfileImageView() {
        
        self.profileImageView.image = userInfo.profileImage
        self.profileImageView.tintColor = .black
        
        self.profileImageView.layer.cornerRadius = self.PROFILE_IMAGE_WIDTH / 5
        self.profileImageView.layer.borderWidth = 1
        self.profileImageView.layer.masksToBounds = true
        
        self.view.addSubview(profileImageView)
        self.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapProfileImageView(_:))))
        self.profileImageView.isUserInteractionEnabled = true
        
        self.profileImageView.snp.makeConstraints( { subView in
            subView.centerX.equalTo(self.view.snp.centerX)
            subView.top.equalToSuperview().offset(75)
            subView.width.height.equalTo(self.PROFILE_IMAGE_WIDTH)
        })
    }
    
    @objc func tapProfileImageView(_ sender: Any) {
        
        guard self.userInfo.name == "" else {
            print("사용자 등록 필요")
            return
        }
        
        let alert = UIAlertController(title: nil, message: "사진을 가져올 곳을 선택해 주세요", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "카메라", style: .default) { _ in
                self.imgPicker(.camera)
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            alert.addAction(UIAlertAction(title: "저장된 앨범", style: .default) { _ in
                self.imgPicker(.savedPhotosAlbum)
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default) { _ in
                self.imgPicker(.photoLibrary)
            })
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    func imgPicker(_ source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.userInfo.profileImage = img
            self.profileImageView.image = img
        }
        
        picker.dismiss(animated: true)
    }
    
    
    
    
    // UserInfoTableView
    func drawUserInfoTableView() {
        
        self.view.addSubview(userInfoTableView)
        
        userInfoTableView.delegate = self
        userInfoTableView.dataSource = self
        
        self.userInfoTableView.snp.makeConstraints( { subView in
            subView.top.equalTo(self.profileImageView.snp.bottom).offset(50)
            subView.width.centerX.equalToSuperview()
            subView.height.equalTo(150)
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // name
        // email
        // grade + semester
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
        
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "이름"
            cell.detailTextLabel?.text = self.userInfo.name
        case 1:
            cell.textLabel?.text = "이메일"
            cell.detailTextLabel?.text = self.userInfo.email
        case 2:
            cell.textLabel?.text = "학사 정보"
            cell.detailTextLabel?.text = self.userInfo.registerData
        default:
            ()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.userInfo.name == nil {
            print("사용자 등록 필요")
        } else {
            switch indexPath.row {
            case 0:
                print("사용자 전환 창")
            case 1:
                print("이메일 변경 창")
            case 2:
                print("학사 정보 등록 창")
            default:
                ()
            }
        }
    }
    
    func drawRemoveUserButton() {
        
        self.removeUserBtn.setTitle("사용자 정보 삭제", for: .normal)
        self.removeUserBtn.setTitleColor(.red, for: .normal)
        self.removeUserBtn.setTitleColor(.white, for: .selected)
        
        self.removeUserBtn.layer.cornerRadius = 10
        self.removeUserBtn.layer.borderWidth = 1
        self.removeUserBtn.layer.borderColor = UIColor.lightGray.cgColor
        self.removeUserBtn.layer.shadowRadius = 3
        
        self.removeUserBtn.addTarget(self, action: #selector(self.clickedRemoveUserButton(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.removeUserBtn)
        
        self.removeUserBtn.snp.makeConstraints( { subView in
            subView.centerX.width.bottom.equalToSuperview().inset(35)
            subView.height.equalTo(40)
        })
        
        if userInfo.name == nil {
            self.removeUserBtn.isHidden = true
        }
    }
    
    @objc func clickedRemoveUserButton(_ sender: UIButton) {
        
        print("현재 사용자 삭제")
        
    }
}
