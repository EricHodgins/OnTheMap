//
//  RefreshProtocol.swift
//  On The Map
//
//  Created by Eric Hodgins on 2016-01-28.
//  Copyright © 2016 Eric Hodgins. All rights reserved.
//

import Foundation

@objc protocol Refresh {
    func refresh(completionHandler: (finished: Bool) -> Void)
}

@objc protocol RefreshTable {
    func refreshingTable()
}