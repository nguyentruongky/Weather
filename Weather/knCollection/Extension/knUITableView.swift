//
//  knUITableView.swift
//  kynguyenCodebase
//
//  Created by Ky Nguyen on 11/25/16.
//  Copyright © 2016 kynguyen. All rights reserved.
//

import UIKit

extension UITableView {
    
    func resizeTableHeaderView(toSize size: CGSize) {
        
        guard let headerView = tableHeaderView else { return }
        headerView.frame.size = headerView.systemLayoutSizeFitting(size)
        tableHeaderView? = headerView
    }
    
}

