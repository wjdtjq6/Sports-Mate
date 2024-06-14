//
//  ProfileImageSettingCollectionViewCell.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/13/24.
//

import UIKit
import SnapKit

class ProfileImageSettingCollectionViewCell: UICollectionViewCell {
    
    let profileImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(profileImage)
        profileImage.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 35
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 0.5).cgColor
        profileImage.alpha = 0.5

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
