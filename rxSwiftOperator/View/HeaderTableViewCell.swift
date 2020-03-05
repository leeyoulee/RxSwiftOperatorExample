//
//  HeaderTableViewCell.swift
//  rxSwiftOperator
//
//  Created by 이유리 on 28/11/2019.
//  Copyright © 2019 이유리. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate : class{
    func headerSection(header: HeaderTableViewCell, section: Int)
}

class HeaderTableViewCell: UITableViewHeaderFooterView {
    weak var delegate: HeaderViewDelegate?
    var section: Int!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(headerTapAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    @objc func headerTapAction(gestureRecognizer: UITapGestureRecognizer) {
        if let cell = gestureRecognizer.view as? HeaderTableViewCell {
            delegate?.headerSection(header: self, section: cell.section)
        }
    }
    
    func initData(title: String, section: Int, delegate : HeaderViewDelegate ) {
        self.textLabel?.text = title
        self.section = section
        self.delegate = delegate
    }
    
}
