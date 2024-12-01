# 🏃‍♂️ Sports Mate
> ### 스포츠 용품 전문 쇼핑 플랫폼

<br />

## 📱 프로젝트 소개
> **개발 기간**: 2024.6.13 ~ 2024.6.18 (1주) <br/>
> **개발 인원**: 1인 (기획/디자인/개발)

<div align="center">

 <img width="32%" src="https://github.com/user-attachments/assets/882be721-b8d0-4fe3-ad0a-b93461167a34" />
  <img width="32%" src="https://github.com/user-attachments/assets/772a023d-4147-4206-80e9-bc874f22e375" />
  <img width="32%" src="https://github.com/user-attachments/assets/7b6a7f81-eb96-450d-b611-e1e1e6484eb5" />
</div>

<br />

## 🛠 기술 스택

### iOS
- **Language**: Swift 5.10
- **Framework**: UIKit
- **Minimum Target**: iOS 16.0

### 아키텍처 & 디자인 패턴
- **Architecture**: MVC
- **Design Pattern**: Singleton, Observer Pattern

### 데이터베이스 & 네트워킹
- **Local Storage**: Realm, UserDefaults
- **Network**: Alamofire
- **Image Caching**: Kingfisher

### 외부 라이브러리
- **UI/Layout**: SnapKit
- **Utility**: Toast

## 📋 주요 기능

### 스포츠 카테고리 기반 검색 시스템
- 17개 전문 스포츠 카테고리 지원
- 카테고리별 자동 검색어 보정
- 실시간 검색어 저장 및 관리

### 네이버 쇼핑 API 연동 및 페이지네이션
- Singleton 패턴을 활용한 네트워크 매니저 구현
- Alamofire를 활용한 비동기 네트워크 통신
- UICollectionViewDataSourcePrefetching 기반 무한 스크롤
- 다중 정렬 옵션 지원 (정확도/날짜/가격)

### 하이브리드 데이터 저장소
- UserDefaults와 Realm을 활용한 이중 저장 구조
- 좋아요 상태의 빠른 접근성 확보
- 상품 상세 정보의 영구 저장 지원

## 🔧 시행착오

### 1. 페이지네이션 데이터 관리
#### 문제상황
- 스크롤 시 중복 데이터 로딩 문제
- 정렬 옵션 변경 시 데이터 초기화 필요

#### 해결방안
```swift
extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for i in indexPaths {
            if i.row == list.count-2 && start+30 <= totalCount {
                start += 30
                Network.shared.callRequest(
                    searchQuery: searchQuery,
                    sort: sort,
                    start: start,
                    success: { [weak self] value in
                        // 데이터 병합 및 UI 업데이트
                    },
                    failure: { [weak self] in
                        self?.view.makeToast("네트워크 오류")
                    }
                )
            }
        }
    }
}
```

### 2. 좋아요 기능 데이터 동기화
#### 문제상황
- UserDefaults와 Realm 간 데이터 동기화
- 앱 재실행 시 상태 복원 문제

#### 해결방안
```swift
class LikeListViewController: UIViewController {
    let realm = try! Realm()
    var list: Results<likeList>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 좋아요 상태 복원
        if let savedList = UserDefaults.standard.array(forKey: "cartCount") as? [String] {
            SettingViewController.cartList = savedList
        }
        collectionView.reloadData()
    }
    
    @objc func bagButtonClicked(sender: UIButton) {
        let productId = list[sender.tag].productId
        if UserDefaults.standard.bool(forKey: productId) {
            // 좋아요 제거
            UserDefaults.standard.set(false, forKey: productId)
            SettingViewController.cartList.removeAll { $0 == productId }
            try! realm.write {
                realm.delete(list[sender.tag])
            }
        } else {
            // 좋아요 추가
            UserDefaults.standard.set(true, forKey: productId)
            SettingViewController.cartList.append(productId)
            try! realm.write {
                realm.add(data)
            }
        }
        UserDefaults.standard.set(SettingViewController.cartList, forKey: "cartCount")
    }
}
```

## 📝 회고

### 잘한 점
1. UICollectionViewDataSourcePrefetching을 활용한 효율적인 페이지네이션
2. 하이브리드 저장소 설계로 데이터 접근 최적화
3. 카테고리 기반 검색 시스템의 체계적인 구현

### 아쉬운 점
1. 네트워크 레이어의 추상화 부족
2. 단위 테스트 부재

### 시도할 점
1. 코드 모듈화 및 테스트 가능한 구조로 개선
2. 검색 결과 캐싱 시스템 도입
3. 상품 추천 알고리즘 구현
