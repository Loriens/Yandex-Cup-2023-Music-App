//
//  UITableView+registerCellClass.swift
//  YandexCup2023MusicApp
//
//  Created by Vladislav Markov on 05.11.2023.
//

import UIKit

extension UITableView {
    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = NSStringFromClass(cellClass).components(separatedBy: ".").last ?? ""
        register(cellClass, forCellReuseIdentifier: identifier)
    }
}
