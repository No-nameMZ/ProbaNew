//
//  Cake.swift
//  ProbaNew
//
//  Created by No name on 22.06.2024.
//

import Foundation

class Cake {
    let nameCake: String
    let ingredient: String
    let gram: String
    let price: String
    var isLike: Bool
    let byPromotion: Bool
    var inBasket: Bool
    var quantity: Int
    
    var fullName: String {
        "\(nameCake) \(ingredient)"
    }
    
    init(
        nameCake: String,
        ingredient: String,
        gram: String,
        price: String,
        isLike: Bool,
        byPromotion: Bool,
        inBasket: Bool,
        quantity: Int
    ) {
        self.nameCake = nameCake
        self.ingredient = ingredient
        self.gram = gram
        self.price = price
        self.isLike = isLike
        self.byPromotion = byPromotion
        self.inBasket = inBasket
        self.quantity = quantity
    }
}

struct CakeGroup {
    let title: String
    let cakes: [Cake]
}







