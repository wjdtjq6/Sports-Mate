//
//  MainViewController.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/14/24.
//

import UIKit
import SnapKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.titleLabel.text = categories[indexPath.item]
            cell.isSelected = categories[indexPath.item] == selectedCategory
            return cell
    }
    

    let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 30) // width를 80에서 120으로 증가
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
        
        let categories = ["전체", "축구", "농구", "야구", "테니스", "수영", "골프", "러닝", "격투기", "클라이밍", "서핑", "스케이트보드/롱보드", "승마", "요가/필라테스", "크로스핏", "사이클링", "스키/스노보드", "스쿠버다이빙/프리다이빙"]
        var selectedCategory: String = "전체"
    
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
        view.addSubview(searchBar)
        searchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag //keyboard hide
        view.backgroundColor = .white
        navigationItem.title = UserDefaults.standard.string(forKey: "nickname")!+"'s Sports Mate"
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
        setupCategoryCollectionView()

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
    
    func setupCategoryCollectionView() {
        view.addSubview(categoryCollectionView)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
        
        // 기존 separator 위치 조정
        separator.snp.remakeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
    }
    
    // UICollectionViewDelegate 메서드 추가
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        collectionView.reloadData()
        
        // 카테고리가 선택되면 해당 카테고리의 상품을 검색
        if selectedCategory == "전체" {
            searchBar.text = ""  // 전체 선택시 검색어 초기화
        } else {
            searchBar.text = selectedCategory + " 스포츠용품"
            searchBarSearchButtonClicked(searchBar)
        }
    }
    
    func noemptyListConfigureUI() {
        resentSearchLabel.text = "최근 검색"
        resentSearchLabel.font = .boldSystemFont(ofSize: 14)
        
        allRemoveButton.setTitle("전체 삭제", for: .normal)
        allRemoveButton.setTitleColor(UIColor.accent, for: .normal)
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
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true) //선택 시 색변경 막음
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text! = searchBar.text!.trimmingCharacters(in: .whitespaces)
        if searchBar.text != "" {
            let sportKeyword = selectedCategory == "전체" ?
            searchBar.text! + " 스포츠용품" :
            searchBar.text! + " " + selectedCategory

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
                //SearchResultViewController().start = 1 //pagenation
                navigationController?.pushViewController(vc, animated: true)
                
                searchBar.text = ""
            }
        }
    }
}

class CategoryCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ?
                .white :
            UIColor.accent
            titleLabel.textColor = isSelected ? .black : .white
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        layer.cornerRadius = 15
    }
}
