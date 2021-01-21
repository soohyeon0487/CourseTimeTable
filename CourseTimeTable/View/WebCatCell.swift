//
//  WebCatCell.swift
//  CourseTimeTable
//
//  Created by Soohyeon Lee on 2021/01/19.
//

import UIKit
import SnapKit

class WebCatCell: UICollectionViewCell {
    
    // MARK: - Property
    
    
    // MARK: - UI Property
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.backgroundColor = .init(white: 1, alpha: 0.5)
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
        self.addSubview(self.titleLabel)
        
        self.imageView.snp.makeConstraints({ subView in
            subView.centerX.centerY.equalToSuperview()
            subView.width.height.equalTo(self.frame.height)
        })
        
        self.titleLabel.snp.makeConstraints({ subView in
            subView.height.equalTo(30)
            subView.centerX.bottom.width.equalTo(self.imageView)
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
