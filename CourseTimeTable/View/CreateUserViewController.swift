//
//  CreateUserViewController.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/15.
//

import UIKit
import RxSwift
import RxCocoa

class CreateUserViewController: UIViewController {
    
    // MARK: - Property
    
    let viewModel = CreateUserViewModel()
    
    var bag = DisposeBag()
    
    let gradeList = [1, 2, 3, 4]
    let semesterList = ["봄", "여름", "가을", "겨울"]
    
    // MARK: - UI Property
    
    let backBtn: UIBarButtonItem = {
        let view = UIBarButtonItem()
        view.title = "닫기"
        view.style = .plain
        view.tintColor = .black
        return view
    }()
    
    let saveBtn: UIBarButtonItem = {
        let view = UIBarButtonItem()
        view.title = "저장"
        view.style = .plain
        view.isEnabled = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.text = "이름"
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    let emailLabel: UILabel = {
        let view = UILabel()
        view.text = "이메일"
        view.adjustsFontSizeToFitWidth = true
        view.isHidden = true
        return view
    }()
    
    let registerLabel: UILabel = {
        let view = UILabel()
        view.text = "학기 정보"
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.isHidden = true
        return view
    }()
    
    let gradeLabel: UILabel = {
        let view = UILabel()
        view.text = "학년"
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.isHidden = true
        return view
    }()
    
    let semesterLabel: UILabel = {
        let view = UILabel()
        view.text = "학기"
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.isHidden = true
        return view
    }()
    
    let nameInput: UITextField = {
        let view = UITextField()
        view.placeholder = "2자리 이상의 이름을 입력하세요"
        view.adjustsFontSizeToFitWidth = true
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.layer.borderWidth = 0
        return view
    }()
    
    let emailInput: UITextField = {
        let view = UITextField()
        view.textContentType = .emailAddress
        view.keyboardType = .emailAddress
        view.placeholder = "이메일을 입력하세요"
        view.adjustsFontSizeToFitWidth = true
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.layer.borderWidth = 0
        view.isHidden = true
        return view
    }()
    
    let gradePicker: UIPickerView = {
        let view = UIPickerView()
        view.backgroundColor = .white
        view.tag = 0
        view.isHidden = true
        return view
    }()
    
    let semesterPicker: UIPickerView = {
        let view = UIPickerView()
        view.backgroundColor = .white
        view.tag = 1
        view.isHidden = true
        return view
    }()
    
    // MARK: - LifeCycle Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.drawUI()
        self.bindUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.bag = DisposeBag()
    }
    
    // MARK: - Draw UI Function
    
    func drawUI() {
        drawNavigationBarItem()
        drawInputView()
    }
    
    func drawNavigationBarItem() {
        
        self.navigationItem.title = "사용자 등록"
        
        backBtn.target = self
        backBtn.action = #selector(self.close(_:))
        
        saveBtn.target = self
        saveBtn.action = #selector(self.save(_:))
        
        self.navigationItem.leftBarButtonItem = backBtn
        self.navigationItem.rightBarButtonItem = saveBtn
    }
    
    func drawInputView() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
                
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.done(_:)))
        let flexBotton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexBotton, doneButton], animated: false)
                
        nameInput.inputAccessoryView = toolbar
        emailInput.inputAccessoryView = toolbar
        
        self.gradePicker.dataSource = self
        self.gradePicker.delegate = self
        self.semesterPicker.dataSource = self
        self.semesterPicker.delegate = self
        
        let inputView = UIView()
        
        self.view.addSubview(inputView)
        
        let height: CGFloat = view.frame.height/10
        
        inputView.snp.makeConstraints( { subView in
            subView.left.right.equalToSuperview().inset(30)
            subView.top.equalToSuperview().inset(height*1.5)
            subView.bottom.equalToSuperview().inset(height*2)
        })
        
        inputView.addSubview(nameLabel)
        inputView.addSubview(emailLabel)
        inputView.addSubview(registerLabel)
        inputView.addSubview(gradeLabel)
        inputView.addSubview(semesterLabel)
        
        inputView.addSubview(nameInput)
        inputView.addSubview(emailInput)
        inputView.addSubview(gradePicker)
        inputView.addSubview(semesterPicker)
        
        nameLabel.snp.makeConstraints( { subView in
            subView.width.equalTo(100)
            subView.height.equalTo(30)
            subView.top.equalToSuperview()
            subView.left.equalToSuperview()
        })
        
        emailLabel.snp.makeConstraints( { subView in
            subView.width.equalTo(100)
            subView.height.equalTo(30)
            subView.top.equalTo(nameLabel.snp.bottom).offset(30)
            subView.left.equalToSuperview()
        })
        
        registerLabel.snp.makeConstraints( { subView in
            subView.height.equalTo(30)
            subView.top.equalTo(emailLabel.snp.bottom).offset(40)
            subView.centerX.left.right.equalToSuperview()
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
        
        nameInput.snp.makeConstraints( { subView in
            subView.left.equalTo(nameLabel.snp.right).offset(10)
            subView.right.equalToSuperview()
            subView.top.bottom.equalTo(nameLabel)
        })
        
        emailInput.snp.makeConstraints( { subView in
            subView.left.equalTo(emailLabel.snp.right).offset(10)
            subView.right.equalToSuperview().offset(-30)
            subView.top.bottom.equalTo(emailLabel)
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
    }
    // MARK: - Bind UI Function
    
    func bindUI() {
        
        self.nameInput.rx.text.orEmpty
            .bind(to: self.viewModel.nameText)
            .disposed(by: self.bag)
        
        self.emailInput.rx.text.orEmpty
            .bind(to: self.viewModel.emailText)
            .disposed(by: self.bag)
        
        self.gradePicker.rx.itemSelected
            .subscribe(onNext: { row, _ in
                self.viewModel.gradeValue.accept(self.gradeList[row])
            })
            .disposed(by: self.bag)
        
        self.semesterPicker.rx.itemSelected
            .subscribe(onNext: { row, _ in
                self.viewModel.semesterValue.accept(row)
            })
            .disposed(by: self.bag)
        
        self.viewModel.isNameValid
            .map({ !$0 })
            .bind(to: self.emailLabel.rx.isHidden)
            .disposed(by: self.bag)
        
        self.viewModel.isNameValid
            .map({ !$0 })
            .bind(to: self.emailInput.rx.isHidden)
            .disposed(by: self.bag)
        
        self.viewModel.isEmailValid
            .map({ !$0 })
            .bind(to: self.registerLabel.rx.isHidden)
            .disposed(by: self.bag)
        
        self.viewModel.isEmailValid
            .map({ !$0 })
            .bind(to: self.gradeLabel.rx.isHidden)
            .disposed(by: self.bag)
        
        self.viewModel.isEmailValid
            .map({ !$0 })
            .bind(to: self.semesterLabel.rx.isHidden)
            .disposed(by: self.bag)
        
        self.viewModel.isEmailValid
            .map({ !$0 })
            .bind(to: self.gradePicker.rx.isHidden)
            .disposed(by: self.bag)
        
        self.viewModel.isEmailValid
            .map({ !$0 })
            .bind(to: self.semesterPicker.rx.isHidden)
            .disposed(by: self.bag)
        
        self.viewModel.isValid
            .bind(to: self.saveBtn.rx.isEnabled)
            .disposed(by: self.bag)
    }
    
    // MARK: - #Selector Function
    
    @objc func close(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func save(_ sender: Any) {
        
        self.viewModel.createUser() {
            
            let alert = UIAlertController(title: nil, message: "사용자 등록 성공!", preferredStyle: .alert)
            
            let okBtn = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.close(self)
            })
            
            alert.addAction(okBtn)
            
            self.present(alert, animated: true)
        }
    }
        
        @objc func done(_ sender: Any) {
            self.view.endEditing(true)
        }
}

// MARK: - Extension

extension CreateUserViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
