//
//  BoxBind.swift
//  Locate
//
//  Created by Shubham Singh on 22/11/20.
//

import Foundation

class BoxBind<T> {
    typealias Listener = (T) -> ()
    
    // MARK:- variables
    var value: T {
        didSet {
            listener?(value)
        }
    }

    var listener: Listener?
    
    // MARK:- initializers
    init(_ value: T) {
        self.value = value
    }
    
    // MARK:- functions
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
