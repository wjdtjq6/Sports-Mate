//
//  SearchResultViewController.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/14/24.
//

import UIKit
import SnapKit
import Alamofire
import Kingfisher

struct Shopping: Codable {
    let total: Int
    let start: Int
    let items: [Items]
}
struct Items: Codable {
    let title: String
    let mallName: String
    let image: String
    let lprice: String
    
    let productId: String
    let link: String
}
class SearchResultViewController: UIViewController {

    var list = [Items]()
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
        view.backgroundColor = .white

        navigationItem.title = searchQuery
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
        
        view.addSubview(resultLabel)
        view.addSubview(simButton)
        view.addSubview(dateButton)
        view.addSubview(ascButton)
        view.addSubview(dscButton)
        callRequest()
        notCollectionView()
        yesCollectionView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    func callRequest() {
        let url = "https://openapi.naver.com/v1/search/shop.json?display=30&query=\(searchQuery)&sort=\(sort)&start=\(start)"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": Private.naverId,
            "X-Naver-Client-Secret": Private.naverPassword
        ]
        AF.request(url,headers: header).responseDecodable(of: Shopping.self) { [self] response in
            switch response.result {
            case .success(let value):
                if self.start == 1 {
                    self.list = value.items
                }
                else {
                    self.list.append(contentsOf: value.items)
                }
                collectionView.reloadData()

                if self.start == 1 && !list.isEmpty { //검색어 없을때 && !list.isEmpty만 추가해서 해결!!!!
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }

                self.totalCount = value.total
                resultLabel.text = "\(totalCount.formatted())개의 검색결과"
            case .failure(let error):
                print(error)
            }
        }
        
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
            make.top.equalTo(view.safeAreaLayoutGuide)//.offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(40)
        }
        //resultLabel.text = "\(totalCount)개의 검색결과"
        resultLabel.textColor = UIColor(red: 239/255, green: 137/255, blue: 71/255, alpha: 1.0)
        resultLabel.font = .boldSystemFont(ofSize: 14)
        
        simButton.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(5)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        simButton.setTitle("정확도", for: .normal)
        simButton.setTitleColor(.white, for: .normal)
        simButton.backgroundColor = UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0)
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
        dateButton.setTitleColor(UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0), for: .normal)
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
        ascButton.setTitleColor(UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0), for: .normal)
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
        dscButton.setTitleColor(UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0), for: .normal)
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
        sort = "sim"
        simButton.setTitleColor(.white, for: .normal)
        simButton.backgroundColor = UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0)
        
        dateButton.backgroundColor = .white
        dateButton.setTitleColor(UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0), for: .normal)
        
        ascButton.backgroundColor = .white
        ascButton.setTitleColor(UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0), for: .normal)
        
        dscButton.backgroundColor = .white
        dscButton.setTitleColor(UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0), for: .normal)
        
        start = 1
        callRequest()
        collectionView.reloadData()
    }
    @objc func date() {
        sort = "date"
        dateButton.setTitleColor(.white, for: .normal)
        dateButton.backgroundColor = UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0)
        
        ascButton.backgroundColor = .white
        ascButton.setTitleColor(UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0), for: .normal)
        
        dscButton.backgroundColor = .white
        dscButton.setTitleColor(UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0), for: .normal)
        
        simButton.backgroundColor = .white
        simButton.setTitleColor(UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0), for: .normal)
        
        start = 1
        callRequest()
        collectionView.reloadData()
    }
    @objc func asc() {
        sort = "dsc"
        ascButton.setTitleColor(.white, for: .normal)
        ascButton.backgroundColor = UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0)
        
        dateButton.backgroundColor = .white
        dateButton.setTitleColor(UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0), for: .normal)
        
        dscButton.backgroundColor = .white
        dscButton.setTitleColor(UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0), for: .normal)
        
        simButton.backgroundColor = .white
        simButton.setTitleColor(UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0), for: .normal)
        
        start = 1
        callRequest()
        collectionView.reloadData()
    }
    @objc func dsc() {
        sort = "asc"
        dscButton.setTitleColor(.white, for: .normal)
        dscButton.backgroundColor = UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0)
        
        dateButton.backgroundColor = .white
        dateButton.setTitleColor(UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0), for: .normal)
        
        ascButton.backgroundColor = .white
        ascButton.setTitleColor(UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0), for: .normal)
        
        simButton.backgroundColor = .white
        simButton.setTitleColor(UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1.0), for: .normal)
        
        start = 1
        callRequest()
        collectionView.reloadData()
    }
}
extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for i in indexPaths {
            if i.row == list.count-2 && start+30 <= totalCount {
                start += 31
                callRequest()
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
        SettingViewController.getKey = list[indexPath.item].productId 
        
        let updatedTitle = list[indexPath.item].title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        vc.myTitle = updatedTitle
        
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionViewCell", for: indexPath) as! SearchResultCollectionViewCell
        let url = URL(string: list[indexPath.item].image)
        cell.image.kf.setImage(with: url)
        
        //TODO: 장바구니 기능
        //UserDefaults.standard.synchronize()
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
        cell.titleLabel.text = updatedTitle//list[indexPath.item].title
        
        cell.lpriceLabel.text = "\(Int(list[indexPath.item].lprice)?.formatted() ?? String(0))"+"원"
        return cell
    }
    @objc func bagButtonClicked(sender: UIButton) {
        //let svc = SettingViewController()
        
        if UserDefaults.standard.bool(forKey: list[sender.tag].productId) {
            UserDefaults.standard.set(false, forKey: list[sender.tag].productId)
            SettingViewController.cartList.removeAll(where: { $0 == list[sender.tag].productId }) //-장바구니 개수
        }
        else {
            UserDefaults.standard.set(true, forKey: list[sender.tag].productId)
            SettingViewController.cartList.append(list[sender.tag].productId) //+장바구니 개수
        }
        //print(svc.cartList)

        collectionView.reloadData()
    }
}
