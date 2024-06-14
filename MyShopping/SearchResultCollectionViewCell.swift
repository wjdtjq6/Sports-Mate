//
//  SearchResultCollectionViewCell.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/14/24.
//

import UIKit
import SnapKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    let image = UIImageView()
    let backButton = UIButton()
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let lpriceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(image)
        contentView.addSubview(backButton)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(lpriceLabel)
        
        image.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(210)
        }
        image.backgroundColor = .blue
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        
        backButton.snp.makeConstraints { make in
            make.bottom.equalTo(image.snp.bottom).inset(15)
            make.trailing.equalTo(image.snp.trailing).inset(15)
            make.width.height.equalTo(30)
        }
        backButton.layer.cornerRadius = 5
        backButton.backgroundColor = .white
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(15)
        }
        mallNameLabel.font = .systemFont(ofSize: 13)
        mallNameLabel.textColor = UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.height.greaterThanOrEqualTo(15)
        }
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.numberOfLines = 2

        lpriceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(15)

        }
        lpriceLabel.font = .boldSystemFont(ofSize: 14)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
