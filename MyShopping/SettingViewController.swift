//
//  SettingViewController.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/14/24.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController {
    
    let tableView = UITableView()
    let titles = ["나의 장바구니 목록","자주 묻는 질문","1:1 문의", "알림 설정","탈퇴하기"]
    static var cartList:[String] = []
    static var getKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "SETTING"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        tableView.separatorColor = .black
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData() // TODO: EDIT PROFILE갔다가 뒤로 오면 userDefaults가 저장되는데 이미지는 안바뀌어서 바뀌도록
    }
}
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = ProfileNicknameSettingViewController()
            navigationItem.backButtonTitle = ""
            navigationController?.navigationBar.tintColor = .black
            navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 5{
            
            let alert = UIAlertController(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?", preferredStyle: .alert)

            let delete = UIAlertAction(title: "확인", style: .destructive) { yesAlertClicked in
                if let appDomain = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: appDomain) }
                SettingViewController.cartList.removeAll()

                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let SceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let navigationController = ViewController() //MainViewController()
            
                SceneDelegate?.window?.rootViewController = UINavigationController(rootViewController: navigationController)
                SceneDelegate?.window?.makeKeyAndVisible()
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)

            
            alert.addAction(cancel)
            alert.addAction(delete)
           // alert.addAction(open)
            
            present(alert, animated: true)
        }

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        }
        else {
            return 40
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        if indexPath.row == 0 {
            cell.profileImage.layer.borderColor = UIColor(red: 239/255, green: 137/255, blue: 71/255, alpha: 1.0).cgColor
            cell.profileImage.layer.borderWidth = 3
            cell.profileImage.image = UIImage(named: "profile_"+UserDefaults.standard.string(forKey: "profile")!)
            
            cell.profileLabel.text = UserDefaults.standard.string(forKey: "nickname")
            
            cell.profileDateLabel.text = UserDefaults.standard.string(forKey: "date")!+" 가입"
            
            cell.nextImage.image = UIImage(systemName: "chevron.right")
        }
        else if indexPath.row == 1 {
            cell.textLabel!.text = titles[indexPath.row-1]
            cell.textLabel!.font = .systemFont(ofSize: 14)
            
            cell.bagListLabel2.text = "의 상품"
            
            if UserDefaults.standard.array(forKey: "cartCount") == nil {
                cell.bagListLabel.text = "0개"
            }
            else {
                cell.bagListLabel.text = "\(UserDefaults.standard.array(forKey: "cartCount")!.count)개"

            }
            cell.bagImage.image = UIImage(systemName: "heart.fill")
        }
        else {
            cell.textLabel!.text = titles[indexPath.row-1]
            cell.textLabel!.font = .systemFont(ofSize: 14)
        }
        if !(indexPath.row == 0 || indexPath.row == 5) {
            cell.selectionStyle = .none
        }
        return cell
    }
    
}
