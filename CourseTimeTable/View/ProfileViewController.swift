//
//  ProfileViewController.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/15.
//

import UIKit
import RxSwift
import RxCocoa


class ProfileViewController: UIViewController {
    
    // MARK: - Property
    
    let viewModel = ProfileViewModel()
    
    var bag = DisposeBag()
    
    let PROFILE_IMAGE_WIDTH: CGFloat = 200
    
    var isShowUserPickerView = false
    
    // MARK: - UI Property
    
    let profileImageView = UIImageView()
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.text = "이름"
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    let emailLabel: UILabel = {
        let view = UILabel()
        view.text = "이메일"
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    let registerLabel: UILabel = {
        let view = UILabel()
        view.text = "학기 정보"
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    let nameValue: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.adjustsFontSizeToFitWidth = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let emailValue: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    let gradeValue: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    let semesterValue: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    let removeUserBtn: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("사용자 정보 삭제", for: .normal)
        view.setTitleColor(.red, for: .normal)
        view.setTitleColor(.white, for: .selected)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 3
        return view
    }()
    
    let guideView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    let userPickerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "사용자 전환"
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 20)
        return view
    }()
    
    let userPicker = UIPickerView()
    
    let okBtn: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("OK", for: .normal)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    let closeBtn: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Cancel", for: .normal)
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        view.setTitleColor(.white, for: .normal)
        return view
    }()
    
    // MARK: - LifeCycle Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.drawUI()
        self.bindUI()
        self.bindUIForPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.changeUser(name:currentUserNameTest.value)
    }
    
    // MARK: - Draw UI Function
    
    func drawUI() {
        self.drawNavigationBar()
        self.drawProfileImageView()
        self.drawUserInfoView()
        self.drawRemoveUserButton()
        self.drawBlurBackgroundView()
        self.drawUserPickerView()
    }
    
    func drawNavigationBar() {
        
        self.navigationItem.title = "사용자 정보"
        
        let createBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showCreateUserView(_:)))
        
        self.navigationItem.rightBarButtonItem = createBtn
    }
    
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
    }
    
    func drawUserInfoView() {
        
        let userInfoView = UIView()
        
        self.view.addSubview(userInfoView)
        
        userInfoView.snp.makeConstraints( { subView in
            subView.top.equalTo(self.profileImageView.snp.bottom).offset(50)
            subView.width.centerX.equalToSuperview()
            subView.height.equalTo(200)
        })
        
        nameValue.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleUserPickerView(_:))))
        
        userInfoView.addSubview(self.nameLabel)
        userInfoView.addSubview(self.emailLabel)
        userInfoView.addSubview(self.registerLabel)
        
        userInfoView.addSubview(self.nameValue)
        userInfoView.addSubview(self.emailValue)
        userInfoView.addSubview(self.gradeValue)
        userInfoView.addSubview(self.semesterValue)
        
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
        
        self.view.addSubview(guideView)
        
        guideView.snp.makeConstraints( { subView in
            subView.top.equalTo(self.profileImageView.snp.bottom).offset(50)
            subView.width.centerX.equalToSuperview()
            subView.height.equalTo(200)
        })
        
        let guideBtn = UIButton(type: .system)
        guideBtn.setTitle("사용자 등록 / 사용자 선택", for: .normal)
        guideBtn.addTarget(self, action: #selector(self.tabGuide(_:)), for: .touchUpInside)
        guideBtn.layer.borderWidth = 1
        guideBtn.layer.cornerRadius = 10
        
        guideView.addSubview(guideBtn)
        
        guideBtn.snp.makeConstraints({ subView in
            subView.centerX.centerY.equalToSuperview()
            subView.width.equalTo(200)
            subView.height.equalTo(50)
        })
    }
    
    func drawRemoveUserButton() {
        
        self.removeUserBtn.addTarget(self, action: #selector(self.clickedRemoveUserButton(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.removeUserBtn)
        
        self.removeUserBtn.snp.makeConstraints( { subView in
            subView.centerX.width.bottom.equalToSuperview().inset(35)
            subView.height.equalTo(40)
        })
    }
    
    func drawBlurBackgroundView() {
        
        self.visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleUserPickerView(_:))))
        
        self.view.addSubview(self.visualEffectView)
        
        self.visualEffectView.snp.makeConstraints({ subView in
            subView.top.bottom.left.right.equalToSuperview()
        })
    }
    
    func drawUserPickerView() {
        
        self.visualEffectView.contentView.addSubview(self.userPickerView)
        
        self.userPickerView.snp.makeConstraints({ subView in
            subView.centerX.centerY.equalTo(self.visualEffectView)
            subView.width.equalTo(300)
            subView.height.equalTo(300)
        })
        
        self.okBtn.addTarget(self, action: #selector(self.choice(_:)), for: .touchUpInside)
        self.closeBtn.addTarget(self, action: #selector(self.toggleUserPickerView(_:)), for: .touchUpInside)
        
        self.userPickerView.addSubview(self.titleLabel)
        self.userPickerView.addSubview(self.userPicker)
        self.userPickerView.addSubview(self.okBtn)
        self.userPickerView.addSubview(self.closeBtn)
        
        self.titleLabel.snp.makeConstraints({ subView in
            subView.top.equalToSuperview().inset(10)
            subView.left.right.equalToSuperview().inset(20)
            subView.height.equalTo(50)
        })
        
        self.userPicker.snp.makeConstraints({ subView in
            subView.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            subView.left.right.equalToSuperview().inset(20)
            subView.height.equalTo(150)
        })
        
        self.okBtn.snp.makeConstraints({ subView in
            subView.left.bottom.equalToSuperview().inset(20)
            subView.right.equalTo(self.userPickerView.snp.centerX).inset(10)
            subView.height.equalTo(50)
        })
        
        self.closeBtn.snp.makeConstraints({ subView in
            subView.right.bottom.equalToSuperview().inset(20)
            subView.left.equalTo(self.userPickerView.snp.centerX).inset(10)
            subView.height.equalTo(50)
        })
    }
    
    
    // MARK: - Bind UI Function
    
    func bindUI() {
        
        self.viewModel.profile
            .map({ $0.name })
            .bind(to: self.nameValue.rx.text)
            .disposed(by: bag)
        
        self.viewModel.profile
            .map({ $0.email })
            .bind(to: self.emailValue.rx.text)
            .disposed(by: bag)
        
        self.viewModel.profile
            .map({ $0.grade ?? 1 })
            .map({ String($0) + "학년" })
            .bind(to: self.gradeValue.rx.text)
            .disposed(by: bag)
        
        self.viewModel.profile
            .map({ $0.semester })
            .map({
                switch $0 {
                case 0:
                    return "봄"
                case 1:
                    return "여름"
                case 2:
                    return "가을"
                case 3:
                    return "겨울"
                default:
                    return ""
                }
            })
            .map({ $0 + "학기" })
            .bind(to: self.semesterValue.rx.text)
            .disposed(by: bag)
        
        self.viewModel.profile
            .map({ $0.image })
            .bind(to: self.profileImageView.rx.image)
            .disposed(by: self.bag)
        
        self.viewModel.isEmptyCurrentUser
            .map({ !$0 })
            .bind(to: self.profileImageView.rx.isUserInteractionEnabled)
            .disposed(by: self.bag)
        
        self.viewModel.isEmptyCurrentUser
            .map({ !$0 })
            .bind(to: self.guideView.rx.isHidden)
            .disposed(by: self.bag)
        
        self.viewModel.isEmptyCurrentUser
            .bind(to: self.removeUserBtn.rx.isHidden)
            .disposed(by: self.bag)
    }
    
    // MARK: - #Selector Function
    
    @objc func showCreateUserView(_ sender: Any) {
        
        guard let createUserVC = self.storyboard?.instantiateViewController(withIdentifier: "_CreateUserView") else {
            return
        }
        
        createUserVC.modalPresentationStyle = .fullScreen
        
        self.present(createUserVC, animated: true)
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
    
    @objc func tabGuide(_ sender: UIButton) {
        
        if userNameListTest.value.count == 0 {
            self.showCreateUserView(self)
        } else {
            self.toggleUserPickerView(self)
        }
    }
    
    @objc func clickedRemoveUserButton(_ sender: UIButton) {
        self.viewModel.deleteUser()
    }
    
    @objc func choice(_ sender: Any) {
        
        self.viewModel.choiceUser() { result in
            
            self.toggleUserPickerView(self)
            
            if !(result) {
                self.showCreateUserView(self)
            }
        }
    }
    
    @objc func toggleUserPickerView(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.isHidden = self.isShowUserPickerView
            self.visualEffectView.alpha = self.isShowUserPickerView ? 0 : 0.8
        }
        
        self.isShowUserPickerView.toggle()
    }
    
}

// MARK: - Extension

extension ProfileViewController {
    
    func bindUIForPicker() {
        
        self.userPicker.dataSource = nil
        self.userPicker.delegate = nil
        
        _ = self.userPicker.rx.itemSelected
            .subscribe(onNext: { row, _ in
                self.viewModel.userPickerRow.onNext(row)
            })
        
        _ = userNameListTest
            .bind(to: self.userPicker.rx.itemTitles) { _, item in
                print(item)
                return item
            }
        
    }
    
}

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imgPicker(_ source: UIImagePickerController.SourceType) {
        
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.viewModel.changeProfileImage(image: img) {
                //self.bindUI()
            }
        }
        
        picker.dismiss(animated: true)
    }
}
