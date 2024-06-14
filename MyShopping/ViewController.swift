//
//  ViewController.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/13/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let appName = UILabel()
    let appImage = UIImageView()
    let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
        view.addSubview(appName)
        view.addSubview(appImage)
        view.addSubview(startButton)
        
        appName.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(70)
        }
        appName.text = "My Shopping"
        appName.textAlignment = .center
        appName.textColor = UIColor(red: 239/255, green: 137/255, blue: 71/255, alpha: 1.0)
        appName.font = .boldSystemFont(ofSize: 40)
        
        appImage.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.height.equalTo(370)
            make.width.equalTo(300)
        }
        appImage.image = UIImage(named: "launch")
        appImage.contentMode = .scaleAspectFill
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(appImage.snp.bottom).offset(120)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(60)
        }
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = UIColor(red: 239/255, green: 137/255, blue: 71/255, alpha: 1.0)
        startButton.layer.cornerRadius = 30
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }

    @objc func startButtonClicked() {
        let vc = ProfileNicknameSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
        UserDefaults.standard.set(nil, forKey: "nickname")
        UserDefaults.standard.set(nil, forKey: "profile")
        UserDefaults.standard.set(nil, forKey: "recentSearch")
    }
}

