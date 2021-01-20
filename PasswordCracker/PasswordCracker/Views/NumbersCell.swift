//
//  NumbersCell.swift
//  PasswordCracker
//
//  Created by iGhibli on 2021/1/20.
//

import UIKit
import SnapKit

class NumbersCell: UICollectionViewCell {
    
    var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8.0
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialRoundedMTBold", size: 32)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bgView)
        bgView.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(5)
            make.bottom.right.equalToSuperview().offset(-5)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("💥💥💥init(coder:) has not been implemented💥💥💥")
    }
    
    static let reuseIdentifier: String = String(describing: self)
}
