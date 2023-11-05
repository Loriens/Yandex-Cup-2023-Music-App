//
//  UITableView+deque.swift
//  YandexCup2023MusicApp
//
//  Created by Vladislav Markov on 05.11.2023.
//

import UIKit

extension UITableView {
    func dequeue<T: UITableViewCell & Reusable>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell: \(T.reuseIdentifier)")
        }
        return cell
    }
}
