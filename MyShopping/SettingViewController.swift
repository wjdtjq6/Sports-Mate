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
