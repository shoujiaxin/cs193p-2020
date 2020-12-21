//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2020/12/21.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int {
        for index in 0 ..< count {
            if self[index].id == matching.id {
                return index
            }
        }
        return 0
    }
}
