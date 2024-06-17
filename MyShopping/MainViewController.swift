//
//  MainViewController.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/14/24.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    let searchBar = UISearchBar()
    let separator = UIView()
    
    let noRecentImage = UIImageView()
    let noRecentLabel = UILabel()

    let resentSearchLabel = UILabel()
    let allRemoveButton = UIButton()
    let tableView = UITableView()
    
    var list: [String] = []
    
    var removingIndex = 0
    //keyboard hide
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = .onDrag //keyboard hide
        view.backgroundColor = .white
        navigationItem.title = UserDefaults.standard.string(forKey: "nickname")!+"'s MY SHOPPING"
        navigationItem.backButtonTitle = ""
        view.addSubview(searchBar)
        view.addSubview(separator)
        searchBar.delegate = self

        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(35)
        }
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp_bottomMargin).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        separator.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0)
        
        if UserDefaults.standard.array(forKey: "recentSearch") == nil {
            list = []
        }
        else {
            list = UserDefaults.standard.array(forKey: "recentSearch") as! [String]
        }
        
        if list == [] {
            emptyListConfigureHierarchy()
            emptyListConfigureLayout()
            emptyListConfigureUI()
        }
        else {
            noemptyListConfigureHierarchy()
            noemptyListConfigureLayout()
            noemptyListConfigureUI()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if list == [] {
            emptyListConfigureHierarchy()
            emptyListConfigureLayout()
            emptyListConfigureUI()
        }
        else {
            noemptyListConfigureHierarchy()
            noemptyListConfigureLayout()
            noemptyListConfigureUI()
        }
    }
    func noemptyListConfigureHierarchy() {
        view.addSubview(resentSearchLabel)
        view.addSubview(allRemoveButton)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecentSearchListTableViewCell.self, forCellReuseIdentifier: "RecentSearchListTableViewCell")
    }
    func noemptyListConfigureLayout() {
        resentSearchLabel.snp.makeConstraints { make in
            make.top.equalTo(separator.snp_bottomMargin).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        allRemoveButton.snp.makeConstraints { make in
            make.top.equalTo(separator.snp_bottomMargin).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
    }
    func noemptyListConfigureUI() {
        resentSearchLabel.text = "최근 검색"
        resentSearchLabel.font = .boldSystemFont(ofSize: 14)
        
        allRemoveButton.setTitle("전체 삭제", for: .normal)
        allRemoveButton.setTitleColor(UIColor(red: 239/255, green: 137/255, blue: 71/255, alpha: 1.0), for: .normal)
        allRemoveButton.titleLabel?.font = .systemFont(ofSize: 13)
        allRemoveButton.addTarget(self, action: #selector(allRemoveButtonClicked), for: .touchUpInside)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(resentSearchLabel.snp_bottomMargin).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.separatorStyle = .none
    }
    func emptyListConfigureHierarchy() {
        view.addSubview(noRecentImage)
        view.addSubview(noRecentLabel)
    }
    func emptyListConfigureLayout() {
        noRecentImage.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        noRecentLabel.snp.makeConstraints { make in
            make.top.equalTo(noRecentImage.snp.bottom)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    func emptyListConfigureUI() {
        noRecentImage.image = UIImage(named: "empty")

        noRecentLabel.text = "최근 검색어가 없어요"
        noRecentLabel.font = .boldSystemFont(ofSize: 15)
        noRecentLabel.textAlignment = .center
    }
    @objc func allRemoveButtonClicked() {
        list.removeAll()
        UserDefaults.standard.set(list, forKey: "recentSearch")
        tableView.reloadData()
        viewWillAppear(true) // list가 없으면 최근검색어가 없어요
    }
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchListTableViewCell", for: indexPath) as! RecentSearchListTableViewCell
        cell.recentLabel.text = list.reversed()[indexPath.row] 
        cell.xmarkButton.tag = indexPath.row
        cell.xmarkButton.addTarget(self, action: #selector(xmarkButtonClicked(sender: )), for: .touchUpInside)
        return cell
    }
    @objc func xmarkButtonClicked(sender: UIButton) {
        list.remove(at: (list.count-1) - sender.tag)
        UserDefaults.standard.set(list, forKey: "recentSearch")
        tableView.reloadData()
        if list.isEmpty {
            viewWillAppear(true) // list가 없으면 최근검색어가 없어요
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SearchResultViewController()
        vc.searchQuery = list[(list.count-1) - indexPath.row]
        SearchResultViewController().start = 1 // pagenation
        navigationController?.pushViewController(vc, animated: true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text! = searchBar.text!.trimmingCharacters(in: .whitespaces)
        if searchBar.text!.contains("  ") {
            searchBar.text! = searchBar.text!.replacingOccurrences(of: " ", with: "")
        }
        if searchBar.text != "" {
            if list.contains(searchBar.text!) {
                list.removeAll { $0 == searchBar.text! }
            }
            list.append(searchBar.text!)
            
            tableView.reloadData()
            UserDefaults.standard.set(list, forKey: "recentSearch")
            let vc = SearchResultViewController()
            vc.searchQuery = searchBar.text!
            SearchResultViewController().start = 1 //pagenation
            navigationController?.pushViewController(vc, animated: true)
            
            searchBar.text = ""
        }
       
        
    }
    
}
