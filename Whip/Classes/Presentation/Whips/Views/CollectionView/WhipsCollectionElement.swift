//
//  WhipsCollectionElement.swift
//  Whip
//
//  Created by Андрей Чернышев on 03.04.2024.
//

final class WhipsCollectionElement {
    let whip: Whip
    let needPayment: Bool
    var marked: Bool
    
    init(
        whip: Whip,
        needPayment: Bool,
        marked: Bool
    ) {
        self.whip = whip
        self.needPayment = needPayment
        self.marked = marked
    }
}
