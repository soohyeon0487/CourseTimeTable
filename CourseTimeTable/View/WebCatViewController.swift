//
//  WebCatViewController.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/19.
//

import UIKit
import RxSwift
import RxCocoa

private let reuseIdentifier = "WebCatCell"

class WebCatViewController: UICollectionViewController {
    
    // MARK: - Property
    
    let viewModel = WebCatViewModel()
    
    var bag = DisposeBag()
    
    var isSearchMode = false
    
    var isFullAddWebCat = [false, false, false]
    
    // MARK: - UI Property
    
    let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.sizeToFit()
        view.showsCancelButton = true
        view.tintColor = .black
        return view
    }()
    
    let searchBtn: UIBarButtonItem = {
        let view = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
        view.tintColor = .black
        return view
    }()
    
    let showProfileBtn: UIBarButtonItem = {
        let view = UIBarButtonItem()
        view.image = UIImage(systemName: "person.fill")
        view.tintColor = .black
        return view
    }()
    
    let addWebCatBtn: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(systemName: "plus"), for: .normal)
        view.tintColor = .black
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        return view
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    let addWebCatAlertView: UIAlertController = {
        let view = UIAlertController(title: "고양이 추가 분양", message: "이름, 가로, 세로를 입력하세요.", preferredStyle: .alert)
        return view
    }()
    // MARK: - LifeCycle Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        
        self.drawUI()
        self.bindUI()
        self.bindUIForCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isSearchMode = false
        self.viewModel.loadWebCatImage()
    }
    
    // MARK: - Draw UI Function
    
    func drawUI() {
        
        self.collectionView!.register(WebCatCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.drawNavigationBar()
        self.drawAddWebCatBtn()
        self.drawAddWebCatView()
    }
    
    func drawNavigationBar() {
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.tintColor = .black
        
        self.searchBtn.target = self
        self.searchBtn.action = #selector(self.toggleSearchBar(_:))
        
        self.showProfileBtn.target = self
        self.showProfileBtn.action = #selector(self.showProfileView(_:))
        
        self.navigationItem.rightBarButtonItems = [self.searchBtn, self.showProfileBtn]
    }
    
    func drawSearchBar(shouldShow: Bool) {
        
        self.isSearchMode = shouldShow
        
        if shouldShow {
            
            self.searchBar.becomeFirstResponder()
            self.searchBar.delegate = self
            
            self.navigationItem.rightBarButtonItems = nil
            self.navigationItem.titleView = self.searchBar
            
        } else {
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItems = [self.searchBtn, self.showProfileBtn]
            self.navigationItem.rightBarButtonItem?.tintColor = .black
        }
    }
    
    func drawAddWebCatBtn() {
        
        self.addWebCatBtn.addTarget(self, action: #selector(self.showAddWebCatAlertView(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.addWebCatBtn)
        
        self.addWebCatBtn.snp.makeConstraints({ btn in
            btn.width.equalTo(50)
            btn.height.equalTo(50)
            btn.centerX.equalTo(self.view.snp.right).offset(-50)
            btn.centerY.equalTo(self.view.snp.bottom).offset(-50)
        })
    }
    
    func drawAddWebCatView() {
        
        self.addWebCatAlertView.addTextField() { textFieldView in
            textFieldView.tag = 0
            textFieldView.placeholder = "이름"
            textFieldView.addTarget(self, action: #selector(self.checkEmpty(_:)), for: .editingChanged)
        }
        self.addWebCatAlertView.addTextField() { textFieldView in
            textFieldView.tag = 1
            textFieldView.placeholder = "가로 길이"
            textFieldView.keyboardType = .decimalPad
            textFieldView.addTarget(self, action: #selector(self.checkEmpty(_:)), for: .editingChanged)
        }
        self.addWebCatAlertView.addTextField() { textFieldView in
            textFieldView.tag = 2
            textFieldView.placeholder = "세로 길이"
            textFieldView.keyboardType = .decimalPad
            textFieldView.addTarget(self, action: #selector(self.checkEmpty(_:)), for: .editingChanged)
        }
        
        let okBtn = UIAlertAction(title: "분양 ㄱㄱ", style: .default) { _ in
            
            let title = self.addWebCatAlertView.textFields![0].text!
            let width = self.addWebCatAlertView.textFields![1].text!
            let height = self.addWebCatAlertView.textFields![2].text!
            
            let widthInt = Int(width)!
            let heightInt = Int(height)!
            
            let newWebCat = WebCat(title: title, width: widthInt, height: heightInt)
            
            self.viewModel.addWebCat(newWebCat: newWebCat)
        }
        let cancelBtn = UIAlertAction(title: "조금 더 고민..", style: .cancel)
        
        self.addWebCatAlertView.addAction(okBtn)
        self.addWebCatAlertView.addAction(cancelBtn)
    }
    
    // MARK: - Bind UI Function
    
    func bindUI() {
        
        currentUserName
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: bag)
        
        webCatList
            .map { $0.count }
            .map { $0 == 12 }
            .bind(to: self.addWebCatBtn.rx.isHidden)
            .disposed(by: bag)
    }
    
    // MARK: - #Selector Function
    
    @objc func toggleSearchBar(_ sender: Any) {
        self.drawSearchBar(shouldShow: true)
    }
    
    @objc func showProfileView(_ sender: UIBarButtonItem) {
        
        guard let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileView") as? ProfileViewController else {
            return
        }
        
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func showAddWebCatAlertView(_ sender: UIBarButtonItem) {
        
        self.addWebCatAlertView.textFields![0].text = ""
        self.addWebCatAlertView.textFields![1].text = ""
        self.addWebCatAlertView.textFields![2].text = ""
        
        self.addWebCatAlertView.actions[0].isEnabled = false
            
        self.present(self.addWebCatAlertView, animated: true)
    }
    
    @objc func checkEmpty(_ sender: UITextField) {
        
        if sender.text == "" {
            self.isFullAddWebCat[sender.tag] = false
            self.addWebCatAlertView.actions[0].isEnabled = false
            return
        }
        
        self.isFullAddWebCat[sender.tag] = true
        
        if isFullAddWebCat[0] && isFullAddWebCat[1] && isFullAddWebCat[2] {
            self.addWebCatAlertView.actions[0].isEnabled = true
        } else {
            self.addWebCatAlertView.actions[0].isEnabled = false
        }
    }
    
    // MARK: - Load Data
    
    func loadData() {
        self.viewModel.loadUserData()
        self.viewModel.loadWebCatDataByName()
        self.viewModel.loadWebCatImage()
    }
}

// MARK: - Extension

extension WebCatViewController {
    
    func bindUIForCollectionView() {
        
        self.collectionView.dataSource = nil
        
        _ = self.viewModel.filteredWebCatItems
            .bind(to: self.collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: WebCatCell.self)) { index, element, cell in
                
                cell.titleLabel.text = element.title
                cell.imageView.image = element.image
                
                cell.layer.borderWidth = 1
            }
        
        _ = self.collectionView.rx.modelSelected(WebCat.self)
            .subscribe(onNext: { webCat in
                
                self.searchBar.text = ""
                
                let webCatDetailView = WebCatDetailViewController()
                webCatDetailView.webCat = webCat
                
                self.navigationController?.pushViewController(webCatDetailView, animated: true)
            })
    }
}

extension WebCatViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.width - 36) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

extension WebCatViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.drawSearchBar(shouldShow: false)
        
        self.searchBar.text = ""
        
        self.viewModel.reloadItems()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchText = searchText.lowercased()
        
        if searchText == "" || searchBar.text == nil {
            
            self.isSearchMode = false
            
            self.view.endEditing(true)
            
            self.viewModel.reloadItems()
            
        } else {
            
            self.isSearchMode = true
            
            webCatList
                .map {
                    $0.filter { $0.title.lowercased().contains(searchText) }
                }
                .bind(to: self.viewModel.filteredWebCatItems)
        }
    }
}
