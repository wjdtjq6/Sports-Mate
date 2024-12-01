//
//  SettingViewController+Extension.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/24/24.
//

import UIKit
import RealmSwift

extension UIViewController {
    func showAlert(title: String, message: String, ok:String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let delete = UIAlertAction(title: ok, style: .destructive) { _ in
            completionHandler()
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true)
    }
}
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = ProfileNicknameSettingViewController()
            navigationItem.backButtonTitle = ""
            navigationController?.navigationBar.tintColor = UIColor.accent
            navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 5{
            showAlert(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?", ok: "확인") {
                if let appDomain = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: appDomain) }
                SettingViewController.cartList.removeAll()
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let SceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let navigationController = ViewController()
                
                SceneDelegate?.window?.rootViewController = UINavigationController(rootViewController: navigationController)
                SceneDelegate?.window?.makeKeyAndVisible()
            }
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
            cell.profileImage.layer.borderColor = UIColor.accent.cgColor
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
            
//            if UserDefaults.standard.array(forKey: "cartCount") == nil {
//                cell.bagListLabel.text = "0개"
//            }
//            else {
                cell.bagListLabel.text = "\(UserDefaults.standard.array(forKey: "cartCount")?.count ?? 0)개"
                
           // }
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
