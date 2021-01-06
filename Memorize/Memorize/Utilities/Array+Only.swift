//
//  Array+Only.swift
//  Memorize
//
//  Created by Jiaxin Shou on 2020/12/22.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
