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
    
    let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.sizeToFit()
        view.showsCancelButton = true
        view.tintColor = .black
        return view
    }()
    
    let viewModel = WebCatViewModel()
    
    var bag = DisposeBag()
    
    var isSearchMode = false
    
    var currentUserName = ""
    
    // MARK: - UI Property
    
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
        self.viewModel.loadWebCatDataByName()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.navigationItem.title = ""
    }
    
    // MARK: - Draw UI Function
    
    func drawUI() {
        
        self.collectionView!.register(WebCatCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.drawNavigationBar()
        
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
    
    // MARK: - Bind UI Function
    
    func bindUI() {
        currentUserNameTest
            .bind(to: self.navigationItem.rx.title)
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
    
    // MARK: - Load Data
    
    func loadData() {
        self.viewModel.loadUserData()
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
        
        self.viewModel.loadWebCatDataByName()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchText = searchText.lowercased()
        
        if searchText == "" || searchBar.text == nil {
            
            self.isSearchMode = false
            self.view.endEditing(true)
            
            self.viewModel.loadWebCatDataByName()
            
        } else {
            
            self.isSearchMode = true
            
            print("items filterring")
            
        }
    }
}
