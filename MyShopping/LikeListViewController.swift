//
//  LikeListViewController.swift
//  MyShopping
//
//  Created by t2023-m0032 on 7/7/24.
//

import UIKit
import RealmSwift

class LikeListViewController: UIViewController {
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
    var list: Results<likeList>!
    //create 1.Realm 위치 찾기
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(realm.configuration.fileURL)

        configureHierarchy()
        configureLayout()
        configureUI()
        list = realm.objects(likeList.self)
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    func configureHierarchy() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        
        //collectionView.prefetchDataSource = self // pagenation
    }
    func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    func configureUI() {
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        navigationItem.title = "나의 장바구니 목록"
    }
}
extension LikeListViewController: UICollectionViewDelegate, UICollectionViewDataSource{//, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductsDetailViewController()
        vc.link = list[indexPath.item].link!
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
        return cell
    }
    @objc func bagButtonClicked(sender: UIButton) {
        if UserDefaults.standard.bool(forKey: list[sender.tag].productId) {
            UserDefaults.standard.set(false, forKey: list[sender.tag].productId)
            SettingViewController.cartList.removeAll(where: { $0 == list[sender.tag].productId })//-장바구니 개수
            try! realm.write({
                realm.delete(list[sender.tag])
                print("Realm delete Success")
            })
        }
        UserDefaults.standard.set(SettingViewController.cartList, forKey: "cartCount")
        collectionView.reloadData()
    }
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        <#code#>
//    }
    
}
