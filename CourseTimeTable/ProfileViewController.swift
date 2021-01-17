//
//  ProfileViewController.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/15.
//

import UIKit
import RxSwift
import RxCocoa


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let viewModel = ProfileViewModel()
    var disposedBag = DisposeBag()
    var appDelegate: AppDelegate? = nil
    
    let PROFILE_IMAGE_WIDTH: CGFloat = 200
    
    let profileImageView = UIImageView()
    
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let registerLabel = UILabel()
    
    let noNameLabel = UITextField()
    let nameValue = UITextField()
    let emailValue = UILabel()
    let gradeValue = UILabel()
    let semesterValue = UILabel()
    
    let userPicker = UIPickerView()
    
    let removeUserBtn = UIButton(type: .system)
    
    let namePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        self.drawNavigationBarItem()
        self.drawProfileImageView()
        self.drawUserInfoView()
        self.drawUserPickerView()
        self.drawRemoveUserButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.changeUser(name:UserDefaults.standard.string(forKey: UserInfoKey.currentUser) ?? "")
        
        self.drawProfileImageView()
        self.drawUserInfoView()
        self.drawUserPickerView()
        self.drawRemoveUserButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.disposedBag = DisposeBag()
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
        
        self.profileImageView.tintColor = .black
        
        self.profileImageView.layer.cornerRadius = self.PROFILE_IMAGE_WIDTH / 5
        self.profileImageView.layer.borderWidth = 1
        self.profileImageView.layer.masksToBounds = true
        
        self.view.addSubview(profileImageView)
        self.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePickerView(_:))))
        
        
        self.profileImageView.snp.makeConstraints( { subView in
            subView.centerX.equalTo(self.view.snp.centerX)
            subView.top.equalToSuperview().offset(75)
            subView.width.height.equalTo(self.PROFILE_IMAGE_WIDTH)
        })
        
        self.viewModel.profileImage
            .bind(to: self.profileImageView.rx.image)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isEmptyName
            .map({!$0})
            .bind(to: self.profileImageView.rx.isUserInteractionEnabled)
            .disposed(by: self.disposedBag)
    }
    
    @objc func showImagePickerView(_ sender: Any) {
        
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
            
            self.viewModel.changeProfileImage(image: img)
        }
        
        picker.dismiss(animated: true)
    }
    
    // UserInfoTableView
    func drawUserInfoView() {
        
        let userInfoView = UIView()
        
        self.view.addSubview(userInfoView)
        
        userInfoView.snp.makeConstraints( { subView in
            subView.top.equalTo(self.profileImageView.snp.bottom).offset(50)
            subView.width.centerX.equalToSuperview()
            subView.height.equalTo(150)
        })
        
        self.noNameLabel.text = "사용자를 등록 혹은 선택해주세요"
        self.noNameLabel.textAlignment = .center
        self.noNameLabel.inputView = self.userPicker
        self.noNameLabel.adjustsFontSizeToFitWidth = true
        self.noNameLabel.layer.borderWidth = 1
        
        self.nameLabel.text = "이름"
        self.nameLabel.textAlignment = .center
        self.nameLabel.adjustsFontSizeToFitWidth = true
        
        self.emailLabel.text = "이메일"
        self.emailLabel.textAlignment = .center
        self.emailLabel.adjustsFontSizeToFitWidth = true
        
        self.registerLabel.text = "학기 정보"
        self.registerLabel.textAlignment = .center
        self.registerLabel.adjustsFontSizeToFitWidth = true
        
        userInfoView.addSubview(self.noNameLabel)
        userInfoView.addSubview(self.nameLabel)
        userInfoView.addSubview(self.emailLabel)
        userInfoView.addSubview(self.registerLabel)
        
        self.noNameLabel.snp.makeConstraints( { subView in
            subView.height.equalTo(50)
            subView.top.left.right.equalToSuperview().inset(40)
        })
        
        self.nameLabel.snp.makeConstraints( { subView in
            subView.width.equalTo(100)
            subView.height.equalTo(30)
            subView.top.equalToSuperview().offset(40)
            subView.left.equalToSuperview().offset(30)
        })
        
        self.emailLabel.snp.makeConstraints( { subView in
            subView.width.equalTo(100)
            subView.height.equalTo(30)
            subView.top.equalTo(nameLabel.snp.bottom).offset(30)
            subView.left.equalToSuperview().offset(30)
        })
        
        self.registerLabel.snp.makeConstraints( { subView in
            subView.width.equalTo(100)
            subView.height.equalTo(30)
            subView.top.equalTo(emailLabel.snp.bottom).offset(30)
            subView.left.equalToSuperview().offset(30)
        })
        
        self.nameValue.textAlignment = .right
        self.nameValue.inputView = self.userPicker
        self.nameValue.adjustsFontSizeToFitWidth = true
        
        self.emailValue.textAlignment = .right
        self.emailValue.adjustsFontSizeToFitWidth = true
        
        self.gradeValue.textAlignment = .right
        self.gradeValue.adjustsFontSizeToFitWidth = true
        
        self.semesterValue.textAlignment = .center
        self.semesterValue.adjustsFontSizeToFitWidth = true
        
        userInfoView.addSubview(self.nameValue)
        userInfoView.addSubview(self.emailValue)
        userInfoView.addSubview(self.gradeValue)
        userInfoView.addSubview(self.semesterValue)
        
        self.nameValue.snp.makeConstraints( { subView in
            subView.height.equalTo(30)
            subView.top.equalToSuperview().offset(40)
            subView.right.equalToSuperview().inset(40)
            subView.left.equalTo(self.nameLabel.snp.right)
        })
        
        self.emailValue.snp.makeConstraints( { subView in
            subView.height.equalTo(30)
            subView.top.equalTo(nameValue.snp.bottom).offset(30)
            subView.right.equalToSuperview().inset(40)
            subView.left.equalTo(self.emailLabel.snp.right)
        })
        
        self.gradeValue.snp.makeConstraints( { subView in
            subView.height.equalTo(30)
            subView.top.equalTo(emailValue.snp.bottom).offset(30)
            subView.left.equalTo(self.registerLabel.snp.right)
            subView.right.equalTo(self.semesterValue.snp.left).offset(-20)
        })
        
        self.semesterValue.snp.makeConstraints( { subView in
            subView.height.equalTo(30)
            subView.width.equalTo(60)
            subView.top.equalTo(emailValue.snp.bottom).offset(30)
            subView.right.equalToSuperview().inset(40)
        })
        
        self.viewModel.name
            .bind(to: self.nameValue.rx.text)
            .disposed(by: self.disposedBag)
        
        self.viewModel.email
            .bind(to: self.emailValue.rx.text)
            .disposed(by: self.disposedBag)
        
        self.viewModel.grade
            .map({"\($0) 학년"})
            .bind(to: self.gradeValue.rx.text)
            .disposed(by: self.disposedBag)
        
        self.viewModel.semester
            .map({"\($0) 학기"})
            .bind(to: self.semesterValue.rx.text)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isEmptyName
            .map({!$0})
            .bind(to: self.noNameLabel.rx.isHidden)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isEmptyName
            .bind(to: self.nameLabel.rx.isHidden)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isEmptyName
            .bind(to: self.nameValue.rx.isHidden)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isEmptyName
            .bind(to: self.emailLabel.rx.isHidden)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isEmptyName
            .bind(to: self.emailValue.rx.isHidden)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isEmptyName
            .bind(to: self.registerLabel.rx.isHidden)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isEmptyName
            .bind(to: self.gradeValue.rx.isHidden)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isEmptyName
            .bind(to: self.semesterValue.rx.isHidden)
            .disposed(by: self.disposedBag)
    }
    
    func drawUserPickerView() {
        
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        toolBar.barTintColor = .lightGray
        
        self.noNameLabel.inputAccessoryView = toolBar
        self.nameValue.inputAccessoryView = toolBar
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem()
        doneBtn.title = "Done"
        doneBtn.target = self
        doneBtn.action = #selector(self.userPickerDone(_:))
        
        toolBar.setItems([flexSpace, doneBtn], animated: true)
        
        userPicker.dataSource = self
        userPicker.delegate = self
        
        userPicker.frame = CGRect(x: 0, y: 200, width: 200, height: 150)
    }
    
    @objc func userPickerDone(_ sender: UIBarButtonItem) {
        
        if appDelegate?.userNameList.count == 0 {
            
            self.view.endEditing(true)
            
            self.showCreateUserView(self)
            
        } else {
            
            let index = self.userPicker.selectedRow(inComponent: 0)
            
            self.view.endEditing(true)
            
            self.viewModel.changeUser(name: self.appDelegate?.userNameList[index] ?? "")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        let count = appDelegate?.userNameList.count
        
        if count == 0 {
            return 1
        } else {
            return appDelegate?.userNameList.count ?? 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let count = appDelegate?.userNameList.count
        
        if count == 0 {
            return "사용자 추가"
        } else {
            return appDelegate?.userNameList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//        let count = appDelegate?.userNameList.count
//
//        if count == 0 {
//            self.showCreateUserView(self)
//        }
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
        
        viewModel.isEmptyName
            .bind(to: self.removeUserBtn.rx.isHidden)
            .disposed(by: self.disposedBag)
    }
    
    @objc func clickedRemoveUserButton(_ sender: UIButton) {
        self.viewModel.deleteUser()
    }
}
