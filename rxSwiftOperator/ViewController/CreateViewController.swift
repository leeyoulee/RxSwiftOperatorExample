//
//  CreateViewController.swift
//  rxSwiftOperator
//
//  Created by 이유리 on 03/12/2019.
//  Copyright © 2019 이유리. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateViewController: UIViewController {
    
    var dayArr = ["월","화","수","목","금"]
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Create"
        
        observableSubscribe()
    }
    
}

extension CreateViewController {
    
    func observableSubscribe() {
        // observable 구독하면서 next, error, completed 처리
        arrayObservable(items: dayArr)
            .subscribe { event in
                switch event {
                case .next(let value):
                    print(value)
                case .error(let error):
                    print(error)
                case .completed:
                    print("completed")
                }
            }.disposed(by: self.disposeBag)
    }
    
    func arrayObservable(items: [String]) -> Observable<String> {
        return Observable<String>.create { observer -> Disposable in
            for item in items {
                // 목요일이면 error 발생
                if item == "목" {
                    observer.onError(NSError(domain: "ERROR", code: 0, userInfo: nil))
                    break
                }
                // 목요일이 아니면 next
                observer.onNext(item)
            }
            observer.onCompleted()
            // dispose 리턴
            return Disposables.create()
        }
    }
}
