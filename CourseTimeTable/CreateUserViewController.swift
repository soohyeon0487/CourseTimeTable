//
//  CreateUserViewController.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/15.
//

import UIKit
import RxSwift
import RxCocoa

class CreateUserViewController: UIViewController, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    let viewModel = CreateUserViewModel()
    var disposedBag = DisposeBag()
    
    let gradeList = [1, 2, 3, 4]
    let semesterList = ["봄", "여름", "가을", "겨울"]
    
    let backBtn = UIBarButtonItem() //(title: "닫기", style: .plain, target: self, action: #selector(self.close(_:)))
    let saveBtn = UIBarButtonItem() //(barButtonSystemItem: .save, target: self, action: #selector(self.save(_:)))
    
    let nameLabel = UILabel()
    let emailLabel = UILabel()
    let registerLabel = UILabel()
    let gradeLabel = UILabel()
    let semesterLabel = UILabel()
    
    let nameInput = UITextField()
    let emailInput = UITextField()
    let gradePicker = UIPickerView()
    let semesterPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawNavigationBarItem()
        drawInputView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.disposedBag = DisposeBag()
    }
    
    func drawNavigationBarItem() {
        
        self.navigationItem.title = "사용자 등록"
        
        backBtn.title = "닫기"
        backBtn.style = .plain
        backBtn.target = self
        backBtn.action = #selector(self.close(_:))
        
        saveBtn.title = "저장"
        saveBtn.style = .plain
        saveBtn.target = self
        saveBtn.action = #selector(self.save(_:))
        saveBtn.isEnabled = false
        
        self.navigationItem.leftBarButtonItem = backBtn
        self.navigationItem.rightBarButtonItem = saveBtn
    }
    
    @objc func close(_ sender: Any) {
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func save(_ sender: Any) {
        
        self.viewModel.createUser()
        
        let alert = UIAlertController(title: nil, message: "사용자 등록 성공!", preferredStyle: .alert)
        
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.close(self)
        })
        
        alert.addAction(okBtn)
        
        self.present(alert, animated: true)
    }
    
    func drawInputView() {
        
        nameLabel.text = "이름"
        nameLabel.adjustsFontSizeToFitWidth = true
        
        emailLabel.text = "이메일"
        emailLabel.adjustsFontSizeToFitWidth = true
        emailLabel.isHidden = true
        
        registerLabel.text = "학기 정보"
        registerLabel.textAlignment = .center
        registerLabel.adjustsFontSizeToFitWidth = true
        registerLabel.isHidden = true
        
        gradeLabel.text = "학년"
        gradeLabel.textAlignment = .center
        gradeLabel.adjustsFontSizeToFitWidth = true
        gradeLabel.isHidden = true
        
        semesterLabel.text = "학기"
        semesterLabel.textAlignment = .center
        semesterLabel.adjustsFontSizeToFitWidth = true
        semesterLabel.isHidden = true
        
        self.view.addSubview(nameLabel)
        self.view.addSubview(emailLabel)
        self.view.addSubview(registerLabel)
        self.view.addSubview(gradeLabel)
        self.view.addSubview(semesterLabel)
        
        nameLabel.snp.makeConstraints( { subView in
            subView.width.equalTo(100)
            subView.height.equalTo(30)
            subView.top.equalToSuperview().offset(80)
            subView.left.equalToSuperview().offset(40)
        })
        
        emailLabel.snp.makeConstraints( { subView in
            subView.width.equalTo(100)
            subView.height.equalTo(30)
            subView.top.equalTo(nameLabel.snp.bottom).offset(30)
            subView.left.equalToSuperview().offset(40)
        })
        
        registerLabel.snp.makeConstraints( { subView in
            subView.height.equalTo(30)
            subView.top.equalTo(emailLabel.snp.bottom).offset(50)
            subView.centerX.left.right.equalToSuperview().inset(40)
        })
        
        gradeLabel.snp.makeConstraints( { subView in
            subView.height.equalTo(30)
            subView.top.equalTo(registerLabel.snp.bottom).offset(10)
            subView.left.equalToSuperview()
            subView.right.equalTo(registerLabel.snp.centerX)
        })
        
        semesterLabel.snp.makeConstraints( { subView in
            subView.height.equalTo(30)
            subView.top.equalTo(registerLabel.snp.bottom).offset(10)
            subView.left.equalTo(registerLabel.snp.centerX)
            subView.right.equalToSuperview()
        })
        
        nameInput.placeholder = "2자리 이상의 이름을 입력하세요"
        nameInput.adjustsFontSizeToFitWidth = true
        nameInput.autocapitalizationType = .none
        nameInput.autocorrectionType = .no
        nameInput.layer.borderWidth = 0
        
        emailInput.textContentType = .emailAddress
        emailInput.keyboardType = .emailAddress
        emailInput.placeholder = "이메일을 입력하세요"
        emailInput.adjustsFontSizeToFitWidth = true
        emailInput.autocapitalizationType = .none
        emailInput.autocorrectionType = .no
        emailInput.layer.borderWidth = 0
        emailInput.isHidden = true
        
        gradePicker.dataSource = self
        gradePicker.delegate = self
        gradePicker.backgroundColor = .white
        gradePicker.tag = 0
        gradePicker.isHidden = true
        
        semesterPicker.dataSource = self
        semesterPicker.delegate = self
        semesterPicker.backgroundColor = .white
        semesterPicker.tag = 1
        semesterPicker.isHidden = true
        
        self.view.addSubview(nameInput)
        self.view.addSubview(emailInput)
        self.view.addSubview(gradePicker)
        self.view.addSubview(semesterPicker)
        
        nameInput.snp.makeConstraints( { subView in
            subView.left.equalTo(nameLabel.snp.right).offset(10)
            subView.right.equalToSuperview().offset(-30)
            subView.centerY.bottom.equalTo(nameLabel)
        })
        
        emailInput.snp.makeConstraints( { subView in
            subView.left.equalTo(emailLabel.snp.right).offset(10)
            subView.right.equalToSuperview().offset(-30)
            subView.centerY.bottom.equalTo(emailLabel)
        })
        
        gradePicker.snp.makeConstraints( { subView in
            subView.left.equalToSuperview()
            subView.right.equalTo(registerLabel.snp.centerX)
            subView.top.equalTo(gradeLabel.snp.bottom)
        })
        
        semesterPicker.snp.makeConstraints( { subView in
            subView.left.equalTo(registerLabel.snp.centerX)
            subView.right.equalToSuperview()
            subView.top.equalTo(semesterLabel.snp.bottom)
        })
        
        // Bind
        
        self.nameInput.rx.text.orEmpty
            .bind(to: self.viewModel.nameText)
            .disposed(by: self.disposedBag)
        
        self.emailInput.rx.text.orEmpty
            .bind(to: self.viewModel.emailText)
            .disposed(by: self.disposedBag)
        
        self.gradePicker.rx.itemSelected
            .subscribe(onNext: { row, _ in
                self.viewModel.gradeValue.onNext(self.gradeList[row])
            })
            .disposed(by: self.disposedBag)
        
        self.semesterPicker.rx.itemSelected
            .subscribe(onNext: { row, _ in
                self.viewModel.semesterValue.onNext(self.semesterList[row])
            })
            .disposed(by: self.disposedBag)
        
        // 중복 Binding을 한번에 처리 가능한가?
        self.viewModel.isNameValid
            .map({ !$0 })
            .bind(to: self.emailLabel.rx.isHidden)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isNameValid
            .map({ !$0 })
            .bind(to: self.emailInput.rx.isHidden)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isEmailValid
            .map({ !$0 })
            .bind(to: self.registerLabel.rx.isHidden)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isEmailValid
            .map({ !$0 })
            .bind(to: self.gradeLabel.rx.isHidden)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isEmailValid
            .map({ !$0 })
            .bind(to: self.semesterLabel.rx.isHidden)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isEmailValid
            .map({ !$0 })
            .bind(to: self.gradePicker.rx.isHidden)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isEmailValid
            .map({ !$0 })
            .bind(to: self.semesterPicker.rx.isHidden)
            .disposed(by: self.disposedBag)
        
        self.viewModel.isValid
            .bind(to: self.saveBtn.rx.isEnabled)
            .disposed(by: self.disposedBag)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 0 {
            return self.gradeList.count
        } else {
            return self.semesterList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 0 {
            return "\(self.gradeList[row])"
        } else {
            return self.semesterList[row]
        }
    }
}
