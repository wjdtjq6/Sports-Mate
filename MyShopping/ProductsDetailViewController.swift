//
//  ProductsDetailViewController.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/15/24.
//

import UIKit
import SnapKit
import WebKit

class ProductsDetailViewController: UIViewController {
    
    var link = ""
    var myTitle = ""
    let webView = WKWebView()
    let notFoundImage = UIImageView()
    let notFoundLabel = UILabel()
    
    //var cart:[Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = myTitle
        
        if UserDefaults.standard.bool(forKey: "bag") {
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
        else {
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
    }
    @objc func rightBarButtonClicked() {
        if UserDefaults.standard.bool(forKey: "bag") {
            navigationItem.rightBarButtonItem!.image = UIImage(systemName: "heart")
            UserDefaults.standard.set(false, forKey: "bag")
        }
        else {
            navigationItem.rightBarButtonItem!.image = UIImage(systemName: "heart.fill")
            UserDefaults.standard.set(true, forKey: "bag")
        }
    }
}
