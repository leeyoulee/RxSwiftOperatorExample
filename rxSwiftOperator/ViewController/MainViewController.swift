//
//  ViewController.swift
//  rxSwiftOperator
//
//  Created by 이유리 on 28/11/2019.
//  Copyright © 2019 이유리. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum OperatorType: Int {
    case Create          = 0
    case Defer           = 1
    case From            = 2
    case Just            = 3
    case Of              = 4
    case Range           = 5
    case Repeat          = 6
    case StartWith       = 7
    case Take            = 8
    case Skip            = 9
    case Filter          = 10
    case Merge           = 11
    case Zip             = 12
    case CombineLatest   = 13
    case Map             = 14
    case FlatMap         = 15
}

class MainViewController: UIViewController {

    @IBOutlet weak var operatorTableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    var operatorList = ["Create", "Defer", "From", "Just", "Of", "Range", "Repeat", "StartWith", "Take", "Skip", "Filter", "Merge", "Zip", "CombineLatest", "Map", "FlatMap"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }

}

extension MainViewController {
    
    func setTableView() {
        // 셀 등록
        operatorTableView.register(UINib(nibName: OperatorTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OperatorTableViewCell.identifier)
        // 테이블뷰에 값 넣어주기
        Observable.from(optional: operatorList).bind(to: operatorTableView.rx.items) { (tableView, index, data) in
            guard let cell = self.operatorTableView.dequeueReusableCell(withIdentifier: OperatorTableViewCell.identifier) as? OperatorTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none // 셀 클릭했을때 회색처리 안되도록
            cell.operatorTitle?.text = data
            return cell
            }.disposed(by: disposeBag)
        
        // 셀 클릭 이벤트
        operatorTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                guard let `self` = self else { return }
                if let type = OperatorType(rawValue: index.item) {
                    switch type {
                    case .Create: self.create()
                    case .Defer: self.deferred()
                    case .From: self.from()
                    case .Just: self.just()
                    case .Of: self.of()
                    case .Range: self.range()
                    case .Repeat: self.repeatElement()
                    case .Take: self.take()
                    case .Skip: self.skip()
                    case .StartWith: self.startWith()
                    case .Filter: self.filter()
                    case .Merge: self.merge()
                    case .Zip: self.zip()
                    case .CombineLatest: self.combineLatest()
                    case .Map: self.map()
                    case .FlatMap: self.flatMap()
                    }
                }
            }).disposed(by: disposeBag)
    }
    
}

extension MainViewController {
    
    func create() {
        let createString = "create string"
        // 구독해서 next 발생할때 출력
        arrCreateObservar(element: createString).subscribe(onNext: { [weak self] result in
            guard let _ = self else { return }
            print("\(result)")
            print("===============")
        }).disposed(by: disposeBag)
    }
    // Observable 생성
    func arrCreateObservar<E>(element: E) -> Observable<E> {
        return Observable.create { observer in
            print("create ->")
            observer.on(.next(element))
            observer.on(.completed)
            return Disposables.create()
        }
    }
    
    // observer가 subscribe 할때까지 기다리다가 생성
    func deferred() {
        let deferObservable = Observable<String>.deferred {
            print("waiting..")
            return Observable.create { observer in
                observer.onNext("observar create!")
                return Disposables.create()
            }
        }
        
        deferObservable.subscribe(onNext: { [weak self] result in
            guard let _ = self else { return }
            print("\(result)")
            print("===============")
        }).disposed(by: disposeBag)
    }
    
    // arr, dictionary들을 observable로 만들때 사용
    func from() {
        let arr = Observable.from(["월","화","수","목","금"])
        let dict = Observable.from([1:"Mon", 2:"The", 3:"Wed", 4:"Thu", 5:"Fri"])
        
        arr.subscribe(onNext: { [weak self] result in
            guard let _ = self else { return }
            print("arr : \(result)")
            print("===============")
        }).disposed(by: disposeBag)
        
        
        dict.subscribe(onNext: { [weak self] result in
            guard let _ = self else { return }
            print("dict : \(result)")
            print("===============")
        }).disposed(by: disposeBag)
    }
    
    // 하나의 element들을 observable로 만들때 사용
    func just() {
        let justString = Observable.just(["월","화","수","목","금"])// "just string")
        
        justString.subscribe(onNext:{ [weak self] result in
            guard let _ = self else { return }
            print("just : \(result)")
            print("===============")
        }).disposed(by: disposeBag)
    }
    
    // 여러개의 element들을 observable로 만들때 사용
    func of() {
        let element = Observable.of(["월","화","수","목","금"])
        
        element.subscribe(onNext:{ [weak self] result in
            guard let _ = self else { return }
            print("of : \(result)")
            print("===============")
        }).disposed(by: disposeBag)
    }
    
    
    
    // 원하는 범위내에 있는 Int 반환
    func range() {
        Observable.range(start: 1, count: 5).subscribe(onNext: { [weak self] result in
            guard let _ = self else { return }
            print("range: \(result)")
            print("===============")
        }).disposed(by: disposeBag)
    }
    
    // 무기한 반복해서 next
    func repeatElement() {
        Observable.repeatElement("repeat").subscribe(onNext: { [weak self] result in
            guard let _ = self else { return }
            print("\(result)")
            print("===============")
        }).disposed(by: disposeBag)
    }
    
    // observable의 처음에 데이터를 추가함
    func startWith() {
        let arr = ["월","화","수","목","금"]
        
        Observable.from(arr).startWith("일").subscribe(onNext: { [weak self] result in
            guard let _ = self else { return }
            print("\(result)")
            print("===============")
        }).disposed(by: disposeBag)
    }
    
    // 무기한 반복해서 next되는 것을 제한 -> 처음 n개만 배출
    // takeLast -> 마지막 n개 배출
    func take() {
        Observable.repeatElement("repeat").takeLast(3).subscribe(onNext: { [weak self] result in
            guard let _ = self else { return }
            print("take : \(result)")
            print("===============")
        }).disposed(by: disposeBag)
    }
    
    // 처음 n개만 숨김
    // skipLast -> 마지막 n개 숨김
    func skip() {
        let arr = ["월","화","수","목","금"]
        
        Observable.from(arr).skip(3).subscribe(onNext: { [weak self] result in
            guard let _ = self else { return }
            print("\(result)")
            print("===============")
        }).disposed(by: disposeBag)
    }
    
    
    // 구독하기전에 핸들링 할 수 있음
    func doOn() {
        let arr = Observable.from(["월","화","수","목","금"])
        
        arr.do(onNext: { [weak self] result in
            guard let _ = self else { return }
            print("beforeSubscribeNext : \(result)")
            }, onError: { [weak self] error in
                guard let _ = self else { return }
                print("beforeSubscribeError : \(error)")
                }, onCompleted: { [weak self] in
                    guard let _ = self else { return }
                    print("beforeSubscribeCompleted")
                    print("===============")
            }).subscribe(onNext: { [weak self] result in
                guard let _ = self else { return }
                print("Next : \(result)")
            })
    }
    
    
    func filter() {
        let arr = ["월","화","수","목","금"]
        // 배열 중 수요일만 배출
        Observable.from(arr).filter({ $0 == "수" }).subscribe(onNext: { [weak self] result in
            guard let _ = self else { return }
            print("\(result)")
            print("===============")
        }).disposed(by: disposeBag)
    }
    
    // 여러개의 Observable을 하나로 만들어줌
    func merge() {
        let firstRelay = PublishSubject<Int>()
        let secondRelay = PublishSubject<Int>()
        
        Observable.of(firstRelay, secondRelay)
            .merge()
            .subscribe(onNext: { [weak self] result in
                guard let _ = self else { return }
                print("\(result)")
                print("===============")
            }).disposed(by: disposeBag)
        
        firstRelay.on(.next(10))
        firstRelay.on(.next(20))
        secondRelay.on(.next(30))
        firstRelay.on(.next(40))
        secondRelay.on(.next(50))
    }
    
    // 최대 8개 타입까지 하나의 observar로 만들어서 배출 -> 발행 순서가 같은 것끼리 묶음
    func zip() {
        let firstRelay = PublishSubject<String>()
        let secondRelay = PublishSubject<Int>()
        
        Observable
            .zip(firstRelay, secondRelay) { ($0, $1) }
            .subscribe(onNext: { [weak self] result in
                guard let _ = self else { return }
                print("\(result)")
                print("===============")
            }).disposed(by: disposeBag)
        
        firstRelay.on(.next("월"))
        firstRelay.on(.next("화"))
        secondRelay.on(.next(1))
        secondRelay.on(.next(2))
        firstRelay.on(.next("수"))
        secondRelay.on(.next(3))
        secondRelay.on(.next(4))
        firstRelay.on(.next("목"))
        secondRelay.on(.next(5))
        firstRelay.on(.next("금"))
    }
    
    // 두개의 observar를 결합 -> 첫번째 옵저버가 배출될때 다른 옵저버의 마지막 배출값으로 결합
    func combineLatest() {
        let firstRelay = PublishSubject<String>()
        let secondRelay = PublishSubject<Int>()
        
        Observable.combineLatest(firstRelay, secondRelay) { first, second in
            "\(first) -> \(second)"
            }
            .subscribe(onNext: { [weak self] result in
                guard let _ = self else { return }
                print("\(result)")
                print("===============")
            }).disposed(by: disposeBag)
        
        firstRelay.on(.next("월"))
        secondRelay.on(.next(1))
        firstRelay.on(.next("화"))
        firstRelay.on(.next("수"))
        secondRelay.on(.next(2))
    }
    
    // 배출된 observable에 함수를 적용시킴
    func map() {
        
//        let dict = Observable.from([1:"Mon", 2:"The", 3:"Wed", 4:"Thu", 5:"Fri"])
//
//        dict.map{ $0.key }.subscribe(onNext: { [weak self] result in
//            guard let _ = self else { return }
//            print("\(result)")
//            print("===============")
//        }).disposed(by: disposeBag)
        
        
        let arr = Observable.of("월","화","수","목","금")
        
        arr.map{ item -> (String) in
            let filterItem = item.filter{ $0 == "수" }
            return filterItem
            }.subscribe(onNext: { [weak self] result in
            guard let _ = self else { return }
            print("\(result)")
        }).disposed(by: disposeBag)
    }
    
    func flatMap() {
        let int = Observable.of(1, 2, 3)
        let string = Observable.of("월", "화", "수", "목")

        int.flatMap { (i: Int) -> Observable<String> in
                print("\(i)")
                return string
            }
            .subscribe(onNext: { [weak self] result in
                guard let _ = self else { return }
                print("\(result)")
                print("===============")
            }).disposed(by: disposeBag)
    }
}

