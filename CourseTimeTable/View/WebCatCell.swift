//
//  WebCatCell.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/19.
//

import Foundation
import UIKit

class WebCatCell: UICollectionViewCell {
    
    // MARK: - Property
    
    
    // MARK: - UI Property
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let titleContainerview: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.cellLongPress(_:))))
        
        self.drawUI()
        self.bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Draw UI Function
    
    func drawUI() {
        
        self.addSubview(self.imageView)
        self.addSubview(self.titleContainerview)
        self.titleContainerview.addSubview(self.titleLabel)
        
        self.imageView.snp.makeConstraints({ subView in
            subView.top.left.right.equalToSuperview()
            subView.height.equalTo(self.snp.width)
        })
        
        self.titleContainerview.snp.makeConstraints({ subView in
            subView.bottom.left.right.equalToSuperview()
            subView.top.equalTo(self.imageView.snp.top)
        })
        
        self.titleLabel.snp.makeConstraints({ subView in
            subView.center.width.height.equalToSuperview()
        })
    }
    
    // MARK: - Bind UI Function
    
    func bindUI() {
        
    }
    
    // MARK: - #Selector Function
    
    @objc func cellLongPress(_ sender: Any) {
        print("삭제")
    }
    
}
