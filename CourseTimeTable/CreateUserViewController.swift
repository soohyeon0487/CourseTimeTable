//
//  CreateUserViewController.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/15.
//

import UIKit

class CreateUserViewController: UIViewController, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    let gradeList = [1, 2, 3, 4]
    let semesterList = ["봄", "여름", "가을", "겨울"]
    
    let nameInput = UITextField()
    let emailInput = UITextField()
    let gradePicker = UIPickerView()
    let semesterPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        drawNavigationBarItem()
        drawInputView()
    }
    
    func drawNavigationBarItem() {
        
        self.navigationItem.title = "사용자 등록"
        
        let backBtn = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(self.close(_:)))
        
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.save(_:)))
        
        self.navigationItem.leftBarButtonItem = backBtn
        self.navigationItem.rightBarButtonItem = saveBtn
    }
    
    @objc func close(_ sender: Any) {
        
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func save(_ sender: Any) {
        
        var msg: String = ""
        var nextFocus: UITextField? = nil
        
        if nameInput.text == "" {
            msg = "이름 입력칸을 채워주세요"
            nextFocus = self.nameInput
        } else if emailInput.text == "" {
            msg = "이메일 입력칸을 채워주세요"
            nextFocus = self.emailInput
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: { _ in
            nextFocus?.becomeFirstResponder()
        })
        
        alert.addAction(okBtn)
        
        self.present(alert, animated: true)
    }

    func drawInputView() {
        
        let nameLabel = UILabel()
        nameLabel.text = "이름"
        nameLabel.adjustsFontSizeToFitWidth = true
        
        let emailLabel = UILabel()
        emailLabel.text = "이메일"
        emailLabel.adjustsFontSizeToFitWidth = true
        
        let registerLabel = UILabel()
        registerLabel.text = "학기 정보"
        registerLabel.textAlignment = .center
        registerLabel.adjustsFontSizeToFitWidth = true
        
        let gradeLabel = UILabel()
        gradeLabel.text = "학년"
        gradeLabel.textAlignment = .center
        gradeLabel.adjustsFontSizeToFitWidth = true
        
        let semesterLabel = UILabel()
        semesterLabel.text = "학기"
        semesterLabel.textAlignment = .center
        semesterLabel.adjustsFontSizeToFitWidth = true
        
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
        
        nameInput.placeholder = "이름을 입력하세요"
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
        
        gradePicker.dataSource = self
        gradePicker.delegate = self
        gradePicker.backgroundColor = .white
        gradePicker.tag = 0
        
        semesterPicker.dataSource = self
        semesterPicker.delegate = self
        semesterPicker.backgroundColor = .white
        semesterPicker.tag = 1
        
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
