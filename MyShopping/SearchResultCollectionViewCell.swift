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
    let bagButton = UIButton()
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let lpriceLabel = UILabel()
    let sportTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.accent
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    let difficultyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .systemBlue
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(image)
        contentView.addSubview(bagButton)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(lpriceLabel)
        contentView.addSubview(sportTypeLabel)
        contentView.addSubview(difficultyLabel)
        
        sportTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.top).offset(10)
            make.leading.equalTo(image.snp.leading).offset(10)
            make.height.equalTo(16)
            make.width.greaterThanOrEqualTo(50) // 최소 너비 설정
        }

        difficultyLabel.snp.makeConstraints { make in
            make.top.equalTo(sportTypeLabel.snp.bottom).offset(5)
            make.leading.equalTo(image.snp.leading).offset(10)
            make.height.equalTo(16)
            make.width.greaterThanOrEqualTo(50) // 최소 너비 설정
        }
        
        sportTypeLabel.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        difficultyLabel.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        sportTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.top).offset(10)
            make.leading.equalTo(image.snp.leading).offset(10)
            make.height.equalTo(16)
            make.width.greaterThanOrEqualTo(70) // 더 긴 텍스트를 수용하기 위해 너비 증가
        }
        
        image.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(210)
        }
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        
        bagButton.snp.makeConstraints { make in
            make.bottom.equalTo(image.snp.bottom).inset(15)
            make.trailing.equalTo(image.snp.trailing).inset(15)
            make.width.height.equalTo(30)
        }
        bagButton.layer.cornerRadius = 5
        bagButton.backgroundColor = .white.withAlphaComponent(0.3)
        bagButton.tintColor = UIColor.accent
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.height.equalTo(15)
        }
        mallNameLabel.font = .systemFont(ofSize: 13)
        mallNameLabel.textColor = UIColor.accent
        
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
