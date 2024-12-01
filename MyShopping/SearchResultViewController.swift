//
//  SearchResultViewController.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/14/24.
//

import UIKit
import SnapKit
import Kingfisher
import Toast
import RealmSwift

class SearchResultViewController: UIViewController {
    var list = [Items]()
    var list2: Results<likeList>!
    var totalCount = 0
    var start = 1
    var searchQuery = ""
    var sort = "sim"
    
    var cart: [Bool] = []
    
    let resultLabel = UILabel()
    let simButton = UIButton()
    let dateButton = UIButton()
    let ascButton = UIButton()
    let dscButton = UIButton()
    //create 1.Realm 위치 찾기
    let realm = try! Realm()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 30
        layout.itemSize = .init(width: width/2, height: width/1.3)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = .zero
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list2 = realm.objects(likeList.self)

        view.backgroundColor = .white

        navigationItem.title = searchQuery
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = UIColor.accent
        
        view.addSubview(resultLabel)
        view.addSubview(simButton)
        view.addSubview(dateButton)
        view.addSubview(ascButton)
        view.addSubview(dscButton)
        Network.shared.callRequest(searchQuery: searchQuery, sort: sort, start: start, success: { value in
            
            if self.start == 1 {
                self.list = value.items
            }
            else {
                self.list.append(contentsOf: value.items)
            }
            self.collectionView.reloadData()//escaping closure recomment!

            if self.start == 1 && !self.list.isEmpty { //검색어 없을때 && !list.isEmpty만 추가해서 해결!!!!
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
            self.totalCount = value.total
            self.resultLabel.text = "\(self.totalCount.formatted())개의 검색결과"
        
           
        }, failure: {
            self.view.makeToast("네트워크 연결이 끊어졌습니다. 인터넷 연결을 확인해주세요.")
            }
        )
        
        notCollectionView()
        yesCollectionView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //장바구니 껐다 켜서 좋아요 눌렀을 때 다시 0부터 시작의 해결 방법!!
        if UserDefaults.standard.array(forKey: "cartCount") != nil {
            SettingViewController.cartList = UserDefaults.standard.array(forKey: "cartCount") as! [String]
        }
        collectionView.reloadData()
    }
    func yesCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        
        collectionView.prefetchDataSource = self // pagenation
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(simButton.snp_bottomMargin).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    func notCollectionView() {
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(40)
        }
        resultLabel.textColor = UIColor.accent
        resultLabel.font = .boldSystemFont(ofSize: 14)
        
        simButton.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(5)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        simButton.setTitle("정확도", for: .normal)
        simButton.setTitleColor(.white, for: .normal)
        simButton.backgroundColor = UIColor.accent
        simButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        simButton.layer.borderColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0).cgColor
        simButton.layer.borderWidth = 1
        simButton.layer.cornerRadius = 15
        
        dateButton.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(5)
            make.leading.equalTo(simButton.snp.trailing).offset(5)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        dateButton.setTitle("날짜순", for: .normal)
        dateButton.setTitleColor(UIColor.accent, for: .normal)
        dateButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        dateButton.layer.borderColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0).cgColor
        dateButton.layer.borderWidth = 1
        dateButton.layer.cornerRadius = 15
        
        ascButton.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(5)
            make.leading.equalTo(dateButton.snp.trailing).offset(5)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        ascButton.setTitle("가격높은순", for: .normal)
        ascButton.setTitleColor(UIColor.accent, for: .normal)
        ascButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        ascButton.layer.borderColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0).cgColor
        ascButton.layer.borderWidth = 1
        ascButton.layer.cornerRadius = 15
        
        dscButton.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(5)
            make.leading.equalTo(ascButton.snp.trailing).offset(5)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        dscButton.setTitle("가격낮은순", for: .normal)
        dscButton.setTitleColor(UIColor.accent, for: .normal)
        dscButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        dscButton.layer.borderColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0).cgColor
        dscButton.layer.borderWidth = 1
        dscButton.layer.cornerRadius = 15
        
        simButton.addTarget(self, action: #selector(sim), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(date), for: .touchUpInside)
        ascButton.addTarget(self, action: #selector(asc), for: .touchUpInside)
        dscButton.addTarget(self, action: #selector(dsc), for: .touchUpInside)
    }
    @objc func sim() {
        start = 1
        simButton.setTitleColor(.white, for: .normal)
        simButton.backgroundColor = UIColor.accent
        
        dateButton.backgroundColor = .white
        dateButton.setTitleColor(UIColor.accent, for: .normal)
        
        ascButton.backgroundColor = .white
        ascButton.setTitleColor(UIColor.accent, for: .normal)
        
        dscButton.backgroundColor = .white
        dscButton.setTitleColor(UIColor.accent, for: .normal)
        
        Network.shared.callRequest(searchQuery: searchQuery, sort: "sim", start: 1, success: { value in
            if self.start == 1 {
                self.list = value.items
            }
            else {
                self.list.append(contentsOf: value.items)
            }
            self.collectionView.reloadData()//escaping closure recomment!

            if self.start == 1 && !self.list.isEmpty { //검색어 없을때 && !list.isEmpty만 추가해서 해결!!!!
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
            self.totalCount = value.total
            self.resultLabel.text = "\(self.totalCount.formatted())개의 검색결과"
        }, failure: {
            self.view.makeToast("네트워크 연결이 끊어졌습니다. 인터넷 연결을 확인해주세요.")
            }
        )
        
        collectionView.reloadData()
    }
    @objc func date() {
        start = 1

        dateButton.setTitleColor(.white, for: .normal)
        dateButton.backgroundColor = UIColor.accent
        
        ascButton.backgroundColor = .white
        ascButton.setTitleColor(UIColor.accent, for: .normal)
        
        dscButton.backgroundColor = .white
        dscButton.setTitleColor(UIColor.accent, for: .normal)
        
        simButton.backgroundColor = .white
        simButton.setTitleColor(UIColor.accent, for: .normal)
        
        Network.shared.callRequest(searchQuery: searchQuery, sort: "date", start: 1, success: { value in
            if self.start == 1 {
                self.list = value.items
            }
            else {
                self.list.append(contentsOf: value.items)
            }
            self.collectionView.reloadData()//escaping closure recomment!

            if self.start == 1 && !self.list.isEmpty { //검색어 없을때 && !list.isEmpty만 추가해서 해결!!!!
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
            self.totalCount = value.total
            self.resultLabel.text = "\(self.totalCount.formatted())개의 검색결과"
        }, failure: {
            self.view.makeToast("네트워크 연결이 끊어졌습니다. 인터넷 연결을 확인해주세요.")
            }
        )
        collectionView.reloadData()
    }
    @objc func asc() {
        start = 1

        ascButton.setTitleColor(.white, for: .normal)
        ascButton.backgroundColor = UIColor.accent
        
        dateButton.backgroundColor = .white
        dateButton.setTitleColor(UIColor.accent, for: .normal)
        
        dscButton.backgroundColor = .white
        dscButton.setTitleColor(UIColor.accent, for: .normal)
        
        simButton.backgroundColor = .white
        simButton.setTitleColor(UIColor.accent, for: .normal)
        
        Network.shared.callRequest(searchQuery: searchQuery, sort: "dsc", start: 1, success: { value in
            if self.start == 1 {
                self.list = value.items
            }
            else {
                self.list.append(contentsOf: value.items)
            }
            self.collectionView.reloadData()//escaping closure recomment!

            if self.start == 1 && !self.list.isEmpty { //검색어 없을때 && !list.isEmpty만 추가해서 해결!!!!
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
            self.totalCount = value.total
            self.resultLabel.text = "\(self.totalCount.formatted())개의 검색결과"
        }, failure: {
            self.view.makeToast("네트워크 연결이 끊어졌습니다. 인터넷 연결을 확인해주세요.")
            }
        )
        collectionView.reloadData()
    }
    @objc func dsc() {
        start = 1

        dscButton.setTitleColor(.white, for: .normal)
        dscButton.backgroundColor = UIColor.accent
        
        dateButton.backgroundColor = .white
        dateButton.setTitleColor(UIColor.accent, for: .normal)
        
        ascButton.backgroundColor = .white
        ascButton.setTitleColor(UIColor.accent, for: .normal)
        
        simButton.backgroundColor = .white
        simButton.setTitleColor(UIColor.accent, for: .normal)
        
        Network.shared.callRequest(searchQuery: searchQuery, sort: "asc", start: 1, success: { value in
            if self.start == 1 {
                self.list = value.items
            }
            else {
                self.list.append(contentsOf: value.items)
            }
            self.collectionView.reloadData()//escaping closure recomment!

            if self.start == 1 && !self.list.isEmpty { //검색어 없을때 && !list.isEmpty만 추가해서 해결!!!!
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
            self.totalCount = value.total
            self.resultLabel.text = "\(self.totalCount.formatted())개의 검색결과"
        }, failure: {
            self.view.makeToast("네트워크 연결이 끊어졌습니다. 인터넷 연결을 확인해주세요.")
            }
        )
        collectionView.reloadData()
    }
}
extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for i in indexPaths {
            if i.row == list.count-2 && start+30 <= totalCount {
                start += 30
                Network.shared.callRequest(searchQuery: searchQuery, sort: sort, start: start, success: { value in
                    
                    if self.start == 1 {
                        self.list = value.items
                    }
                    else {
                        self.list.append(contentsOf: value.items)
                    }
                    self.collectionView.reloadData()//escaping closure recomment!

                    if self.start == 1 && !self.list.isEmpty { //검색어 없을때 && !list.isEmpty만 추가해서 해결!!!!
                        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                    }
                    self.totalCount = value.total
                    self.resultLabel.text = "\(self.totalCount.formatted())개의 검색결과"
                }, failure: {
                    self.view.makeToast("네트워크 연결이 끊어졌습니다. 인터넷 연결을 확인해주세요.")
                    }
                )
            }
        }
    }
}
extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductsDetailViewController()
        vc.link = list[indexPath.item].link
        vc.getKey = list[indexPath.item].productId // 장바구니 기능
        vc.data = likeList(image: list[indexPath.item].image, mallName: list[indexPath.item].mallName, title: list[indexPath.item].title, lprice: list[indexPath.item].lprice, link: list[indexPath.item].link, productId: list[indexPath.item].productId)// link,title,productId뿐만 아니라 다 보내줘야 Realm에 저장됨
        SettingViewController.getKey = list[indexPath.item].productId
        
        let updatedTitle = list[indexPath.item].title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        vc.myTitle = updatedTitle
        
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionViewCell", for: indexPath) as! SearchResultCollectionViewCell
        let item = list[indexPath.item]
        let url = URL(string: list[indexPath.item].image)
        cell.image.kf.setImage(with: url)
        
        //TODO: 장바구니 기능

        if UserDefaults.standard.bool(forKey: list[indexPath.item].productId) {
            cell.bagButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else {
            cell.bagButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        //
        cell.bagButton.tag = indexPath.item
        cell.bagButton.addTarget(self, action: #selector(bagButtonClicked(sender:)), for: .touchUpInside)
        
        cell.mallNameLabel.text = list[indexPath.item].mallName
        
        let updatedTitle = list[indexPath.item].title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        cell.titleLabel.text = updatedTitle
        
        cell.lpriceLabel.text = "\(Int(list[indexPath.item].lprice)?.formatted() ?? String(0))"+"원"
        let sportType = item.getSportType()
        cell.sportTypeLabel.text = sportType
        
        switch sportType {
        case "스케이트보드":
            cell.sportTypeLabel.backgroundColor = .systemOrange
        case "축구":
            cell.sportTypeLabel.backgroundColor = .systemGreen
        case "농구":
            cell.sportTypeLabel.backgroundColor = .systemRed
        case "야구":
            cell.sportTypeLabel.backgroundColor = .systemBlue
        case "테니스":
            cell.sportTypeLabel.backgroundColor = .systemYellow
        case "수영":
            cell.sportTypeLabel.backgroundColor = .systemTeal
        case "골프":
            cell.sportTypeLabel.backgroundColor = .systemPurple
        case "러닝":
            cell.sportTypeLabel.backgroundColor = .systemPink
        case "격투기":
            cell.sportTypeLabel.backgroundColor = .systemBrown
        case "클라이밍":
            cell.sportTypeLabel.backgroundColor = .systemIndigo
        case "서핑":
            cell.sportTypeLabel.backgroundColor = .systemCyan
        case "승마":
            cell.sportTypeLabel.backgroundColor = .brown
        case "요가/필라테스":
            cell.sportTypeLabel.backgroundColor = .systemMint
        case "크로스핏":
            cell.sportTypeLabel.backgroundColor = .darkGray
        case "사이클링":
            cell.sportTypeLabel.backgroundColor = .systemGray
        case "스키/스노보드":
            cell.sportTypeLabel.backgroundColor = .systemBlue
        case "스쿠버다이빙":
            cell.sportTypeLabel.backgroundColor = .systemTeal
        default:
            cell.sportTypeLabel.backgroundColor = UIColor(red: 239/255, green: 137/255, blue: 71/255, alpha: 1.0)
        }
            
        let difficulty = item.getDifficulty()
        cell.difficultyLabel.text = difficulty
        
        // 난이도별 색상 설정
            switch difficulty {
        case "전문가용":
            cell.difficultyLabel.backgroundColor = .systemRed
        case "중급자용":
            cell.difficultyLabel.backgroundColor = .systemBlue
        default:
            cell.difficultyLabel.backgroundColor = .systemGreen
        }
        
        return cell
    }
    @objc func bagButtonClicked(sender: UIButton) {
        let productId = list[sender.tag].productId

        //2.
        let data = likeList(image: list[sender.tag].image, mallName: list[sender.tag].mallName, title: list[sender.tag].title, lprice: list[sender.tag].lprice, link: list[sender.tag].link, productId: list[sender.tag].productId)

        if UserDefaults.standard.bool(forKey: list[sender.tag].productId) {
            UserDefaults.standard.set(false, forKey: list[sender.tag].productId)
            SettingViewController.cartList.removeAll(where: { $0 == productId })//-장바구니 개수
            //껐다 켜서 장바구니 지우면 무조건 0개로 되는 놈 지움!!
            //if let delete = list2.first(where: { $0.productId == list[sender.tag].productId }) {//.where{ $0.productId == productId }[0] {
                try! realm.write{
                    print(list2[sender.tag].id)
                    realm.delete(list2[sender.tag])
                    //realm.delete(delete)
                    print("Realm delete Success")
                }
           // }
            
        }
        else {
            UserDefaults.standard.set(true, forKey: list[sender.tag].productId)
            SettingViewController.cartList.append(list[sender.tag].productId)//+장바구니 개수//cartList가 아니라!! userDefaults에 저장해야함!
            
            //3.
            try! realm.write {
                realm.add(data)
                print("Realm Create Success")
            }
        }
        UserDefaults.standard.set(SettingViewController.cartList, forKey: "cartCount")
        collectionView.reloadData()
    }
}
