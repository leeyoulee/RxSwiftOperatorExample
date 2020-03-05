//
//  DeferViewController.swift
//  rxSwiftOperator
//
//  Created by 이유리 on 04/12/2019.
//  Copyright © 2019 이유리. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DeferViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Defer"
        
        let deferObservable = Observable<String>.deferred {
            print("waiting..")
            // observer가 subscribe 할때까지 기다리다가 생성
            return Observable.create { observer in
                observer.onNext("observar create!")
                return Disposables.create()
            }
        }
        
        deferObservable.subscribe(onNext: { [weak self] result in
            print("\(result)")
        }).disposed(by: disposeBag)

    }

}
