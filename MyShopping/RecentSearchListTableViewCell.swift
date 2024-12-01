//
//  RecentSearchListTableViewCell.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/14/24.
//

import UIKit
import SnapKit

class RecentSearchListTableViewCell: UITableViewCell {

    let clockImage = UIImageView()
    let recentLabel = UILabel()
    let xmarkButton = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(clockImage)
        contentView.addSubview(recentLabel)
        contentView.addSubview(xmarkButton)

        clockImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(10)
        }
        clockImage.image = UIImage(systemName: "clock")
        clockImage.tintColor = UIColor.accent
        
        recentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(clockImage.snp_trailingMargin).offset(20)
        }
        
        xmarkButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        xmarkButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xmarkButton.tintColor = UIColor.accent
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
