//
//  ProductsDetailViewController.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/15/24.
//

import UIKit
import SnapKit
import WebKit
import Toast

class ProductsDetailViewController: UIViewController,WKNavigationDelegate {
    
    var link = ""
    var myTitle = ""
    var getKey = "" //장바구니 기능 indexPath.item 가져와서 사용
    
    let webView = WKWebView()
    let notFoundImage = UIImageView()
    let notFoundLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        view.backgroundColor = .white
        navigationItem.title = myTitle
        if UserDefaults.standard.bool(forKey: getKey) {
            let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(rightBarButtonClicked))
            navigationItem.rightBarButtonItem = rightBarButton
        }
        else {
            let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(rightBarButtonClicked))
            navigationItem.rightBarButtonItem = rightBarButton
        }

        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        let url = URL(string: link)
        if url != nil {
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        else if url == nil {
            view.addSubview(notFoundImage)
            notFoundImage.snp.makeConstraints { make in
                make.center.equalTo(view.safeAreaLayoutGuide)
            }
            notFoundImage.image = UIImage(named: "empty")
            
            view.addSubview(notFoundLabel)
            notFoundLabel.snp.makeConstraints { make in
                make.top.equalTo(notFoundImage.snp.bottom).offset(10)
                make.centerX.equalTo(view.safeAreaLayoutGuide)
            }
            notFoundLabel.text = "Link를 찾을 수 없어요"
            notFoundLabel.font = .boldSystemFont(ofSize: 15)
        }
        else {
            self.view.makeToast("네트워크 연결이 끊어졌습니다. 인터넷 연결을 확인해주세요.")
        }
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        self.view.makeToast("네트워크 연결이 끊어졌습니다. 인터넷 연결을 확인해주세요.")
    }
    @objc func rightBarButtonClicked() {
        if UserDefaults.standard.bool(forKey: getKey) {
            UserDefaults.standard.set(false, forKey: getKey)
            navigationItem.rightBarButtonItem!.image = UIImage(systemName: "heart")
            
            SettingViewController.cartList.removeAll(where: { $0 == getKey })//-장바구니 개수
        }
        else {
            UserDefaults.standard.set(true, forKey: getKey)
            navigationItem.rightBarButtonItem!.image = UIImage(systemName: "heart.fill")
            SettingViewController.cartList.append(getKey)//+장바구니 개수//cartList가 아니라!! userDefaults에 저장해야함!
        }
        UserDefaults.standard.set(SettingViewController.cartList, forKey: "cartCount")
    }
}
