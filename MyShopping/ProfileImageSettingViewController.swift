//
//  ProfileImageSettingViewController.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/13/24.
//

import UIKit
import SnapKit

var list = 0

class ProfileImageSettingViewController: UIViewController {
    
    let profileImage = UIImageView()
    let cameraImage = UIImageView()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 100
        layout.itemSize = .init(width: width/4, height: width/4)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = .zero
        
        return layout
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    func configureHierarchy() {
        view.addSubview(profileImage)
        view.addSubview(cameraImage)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProfileImageSettingCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileImageSettingCollectionViewCell")
    }
    func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(100)
        }
        
        cameraImage.snp.makeConstraints { make in
            make.bottom.equalTo(profileImage.snp.bottom).inset(5)
            make.trailing.equalTo(profileImage.snp.trailing).inset(5)
            make.width.height.equalTo(25)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "PROFILE SETTING"
        navigationItem.backButtonTitle = ""
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 50
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor(red: 239/255, green: 137/255, blue: 71/255, alpha: 1.0).cgColor
        if UserDefaults.standard.string(forKey: "profile") == nil {
            profileImage.image = UIImage(named: "profiled_"+"\(Int.random(in: 0...11))")
        }
        else {
            profileImage.image = UIImage(named: "profile_"+UserDefaults.standard.string(forKey: "profile")!)
        }
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12)
        cameraImage.image = UIImage(systemName: "camera.fill",withConfiguration: imageConfig)
        cameraImage.backgroundColor = UIColor(red: 239/255, green: 137/255, blue: 71/255, alpha: 1.0)
        cameraImage.tintColor = .white
        cameraImage.layer.cornerRadius = 12.5
        cameraImage.contentMode = .center
    }
}
extension ProfileImageSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageSettingCollectionViewCell", for: indexPath) as! ProfileImageSettingCollectionViewCell
        let profileNumber = UserDefaults.standard.string(forKey: "profile")
        let profileImage = UIImage(named: "profile_"+"\(indexPath.item)")
        
        
        cell.profileImage.image = profileImage
        if profileNumber != nil && Int(profileNumber!) == indexPath.item {
            cell.profileImage.layer.borderWidth = 3
            cell.profileImage.layer.borderColor = UIColor(red: 239/255, green: 137/255, blue: 71/255, alpha: 1.0).cgColor
            cell.profileImage.alpha = 1
        }
        else {
            cell.profileImage.layer.borderWidth = 1
            cell.profileImage.layer.borderColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 0.5).cgColor
            cell.profileImage.alpha = 0.5
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.item, forKey: "profile")
        collectionView.reloadData()
        profileImage.image = UIImage(named: "profile_"+UserDefaults.standard.string(forKey: "profile")!)
    }    
}
