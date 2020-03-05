//
//  operatorItem.swift
//  rxSwiftOperator
//
//  Created by 이유리 on 28/11/2019.
//  Copyright © 2019 이유리. All rights reserved.
//

import Foundation

struct OperatorItem {
    var operators: String!
    var function: AnyObject
    
    init(operators: String, function: AnyObject) {
        self.operators = operators
        self.function = function
    }
    
}
