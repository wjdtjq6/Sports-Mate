//
//  ProfileNicknameSettingViewController.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/13/24.
//

import UIKit
import SnapKit

class ProfileNicknameSettingViewController: UIViewController {
    
    let profileButton = UIButton()
    let profileCamera = UIImageView()
    
    let nicknameTextField = UITextField()
    let separator = UIView()
    let warningLabel = UILabel()
    let completeButton = UIButton()
    
    
    
    let warnings = ["@", "#", "$", "%", "  "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        profileButton.setImage(UIImage(named: "profile_"+UserDefaults.standard.string(forKey: "profile")!), for: .normal)
    }
    func configureHierarchy() {

        view.addSubview(profileButton)
        view.addSubview(profileCamera)
        view.addSubview(nicknameTextField)
        view.addSubview(separator)
        view.addSubview(warningLabel)
        view.addSubview(completeButton)
    }
    func configureLayout() {
        
        navigationItem.backButtonTitle = ""

        profileButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(100)
        }
        profileCamera.snp.makeConstraints { make in
            make.bottom.equalTo(profileButton.snp.bottom).inset(5)
            make.trailing.equalTo(profileButton.snp.trailing).inset(5)
            make.width.height.equalTo(25)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(40)
        }
        separator.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(1)
        }
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(40)
            
        }
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(warningLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(40)
        }
    }
    func configureUI() {
        view.backgroundColor = .white
        
        if UserDefaults.standard.string(forKey: "profile") == nil {
            UserDefaults.standard.set(Int.random(in: 0...11), forKey: "profile")
        }
        profileButton.setImage(UIImage(named: "profile_"+UserDefaults.standard.string(forKey: "profile")!), for: .normal)

        profileButton.clipsToBounds = true
        profileButton.layer.cornerRadius = 50
        profileButton.layer.borderWidth = 3
        profileButton.layer.borderColor = UIColor(red: 239/255, green: 137/255, blue: 71/255, alpha: 1.0).cgColor
        profileButton.addTarget(self, action: #selector(profileButtonClicked), for: .touchUpInside)

        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12)
        profileCamera.image = UIImage(systemName: "camera.fill",withConfiguration: imageConfig)
        profileCamera.backgroundColor = UIColor.accent
        profileCamera.tintColor = .white
        profileCamera.layer.cornerRadius = 12.5
        profileCamera.contentMode = .center
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요 :)"
        nicknameTextField.addTarget(self, action: #selector(nicknameWarning), for: .editingChanged)
        
        separator.backgroundColor = .lightGray
        
        warningLabel.textColor = UIColor.accent
        warningLabel.font = .systemFont(ofSize: 13)
        if UserDefaults.standard.string(forKey: "nickname") != nil {
            navigationItem.title = "EDIT PROFILE"

            let rightBarButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(completeButtonClicked))//pop??
            rightBarButton.setTitleTextAttributes([
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16) ,
                NSAttributedString.Key.foregroundColor : UIColor.accent,
                ], for: .normal)
            navigationItem.rightBarButtonItem = rightBarButton
            
            nicknameTextField.text = UserDefaults.standard.string(forKey: "nickname")
        }
        else {
            navigationItem.title = "PROFILE SETTING"

            completeButton.setTitle("완료", for: .normal)
            completeButton.tintColor = .white
            completeButton.backgroundColor = UIColor.accent
            completeButton.layer.cornerRadius = 20
            completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        }
        
    }
    @objc func completeButtonClicked() {
        if warningLabel.text == "사용할 수 있는 닉네임이에요" {
            UserDefaults.standard.set(nicknameTextField.text, forKey: "nickname")
            UserDefaults.standard.set(true, forKey: "isUser")
            
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let SceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let navigationController = TabBarController()
        
            SceneDelegate?.window?.rootViewController = navigationController
            SceneDelegate?.window?.makeKeyAndVisible()
        }
        
        if UserDefaults.standard.string(forKey: "date") == nil {
            let df = DateFormatter()
            df.dateFormat = "yyyy.MM.dd"
            let str = df.string(from: Date())
            UserDefaults.standard.set(str, forKey: "date")
        }
    }
    @objc func nicknameWarning() {
        if nicknameTextField.text!.contains(warnings[0]) {
            warningLabel.text = "닉네임에 @를 포함할 수 없어요"
        }
        else if nicknameTextField.text!.contains(warnings[1]) {
            warningLabel.text = "닉네임에 #를 포함할 수 없어요"
        }
        else if nicknameTextField.text!.contains(warnings[2]) {
            warningLabel.text = "닉네임에 $를 포함할 수 없어요"
        }
        else if nicknameTextField.text!.contains(warnings[3]) {
            warningLabel.text = "닉네임에 %를 포함할 수 없어요"
        }
        //스페이스바 두번 연속 불가능!
        else if nicknameTextField.text!.contains(warnings[4]) {
            warningLabel.text = "사용할 수 없는 닉네임입니다"
        }
        else if !(nicknameTextField.text!.count >= 2 && nicknameTextField.text!.count < 10) {
            warningLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
        }
        else {
            warningLabel.text = "사용할 수 있는 닉네임이에요"
        }
        for i in 0...9 {
            if nicknameTextField.text!.contains("\(i)") {
                warningLabel.text = "닉네임에 숫자는 포함할 수 없어요"
            }
        }
        //처음,끝 스페이스 불가능!
        var list:[Character] = []
        for i in nicknameTextField.text! {
            list.append(i)
        }
        if list.first == " " || list.last == " " {
            warningLabel.text = "사용할 수 없는 닉네임입니다"
        }
    }
    @objc func profileButtonClicked() {
        let vc = ProfileImageSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
