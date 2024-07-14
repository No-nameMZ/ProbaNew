//
//  CakeService.swift
//  ProbaNew
//
//  Created by No name on 02.07.2024.
//

import Foundation

// Протокол ICakeService определяет интерфейс для сервиса тортов
protocol ICakeService: AnyObject {
        
    /// Свойство для хранения избранных тортов
    var favoriteCakes: [Cake] { get }
    
    var selectedCakes: [Cake] { get }
    
    var cakeGroups: [CakeGroup] { get }
        
    /// Метод для добавления торта в избранное
    func favoriteCake(cake: Cake)
    
    /// Метод для удаления торта из избранного
    func unfavoriteCake(cake: Cake)
    
    func addDelegate(_ delegate: CakeServiceDelegate)
    
    /// Метод для добавления торта в корзину
    func addToBasket(cake: Cake)
    
    /// Метод для удаления торта из корзины
    func removeFromBasket(cake: Cake)
}


/// Протокол CakeServiceDelegate определяет метод для обновления избранных тортов
protocol CakeServiceDelegate: AnyObject {
    func cakeServiceDidUpdateFavorites(_ cakeService: ICakeService)
}

// MARK: - Private Property
final class CakeService: ICakeService {
    
    static let shared: ICakeService = CakeService()

    private let dataStore = DataStore()
    
    private(set) var cakeGroups: [CakeGroup]

    /// Свойство для хранения избранных тортов
    private(set) var favoriteCakes = [Cake]()
    
    /// Свойство для хранения корзинных тортов
    private(set) var selectedCakes = [Cake]()
    
    private var delegateList = [CakeServiceDelegate]()
    
    private init() {
        /// Фильтруем торты по акциям
        let promotionCakes = dataStore.cakes.filter { $0.byPromotion }
/* Используем функцию filter, которая проходит по массиву dataStore.cakes
 и выбирает те торты, для которых свойство byPromotion равно true */

        
        /// Фильтруем остальные торты (не акционные)
        let otherCakes = dataStore.cakes.filter { !$0.byPromotion }
/* Используем функцию filter, которая проходит по массиву dataStore.cakes
 и выбирает те торты, для которых свойство byPromotion равно false */
                
        cakeGroups = [
            CakeGroup(title: "Акции", cakes: promotionCakes),
            CakeGroup(title: "Каталог", cakes: otherCakes)
        ]
    }
    
    
// MARK: - Public Methods
    /// Метод для добавления торта в избранное
    func favoriteCake(cake: Cake) {
        guard let likedCake = Array(cakeGroups.map { $0.cakes }.joined())
            .first(where: { $0.nameCake == cake.nameCake }) else {
            return
        }
        
        print(likedCake.nameCake)

        likedCake.isLike = true
        
        // Добавляем торт в список избранных тортов
        favoriteCakes.append(likedCake)
        
        delegateList.forEach {
            $0.cakeServiceDidUpdateFavorites(self)
        }
    }
    
    /// Метод для удаления торта из избранного
    func unfavoriteCake(cake: Cake) {
        guard let likedCake = Array(cakeGroups.map { $0.cakes }.joined())
            .first(where: { $0.nameCake == cake.nameCake }) else { return }
        
        print(likedCake.nameCake)
        
        likedCake.isLike = false
        
        favoriteCakes.removeAll(where: { $0.nameCake == cake.nameCake })
        delegateList.forEach {
            $0.cakeServiceDidUpdateFavorites(self)
        }
    }
    
    func addDelegate(_ delegate: CakeServiceDelegate) {
        delegateList.append(delegate)
    }
    
    /// Метод для добавления торта в корзину
    func addToBasket(cake: Cake) {
        guard let basketCake = Array(cakeGroups.map { $0.cakes }.joined())
            .first(where: { $0.nameCake == cake.nameCake }) else { return }
        
        basketCake.inBasket = true
        // basketCake.quantity += 1
        selectedCakes.append(basketCake)
        
        delegateList.forEach {
            $0.cakeServiceDidUpdateFavorites(self)
        }
        
    }
    
    /// Метод для удаления торта из корзины
    func removeFromBasket(cake: Cake) {
        guard let basketCakes = Array(cakeGroups.map { $0.cakes }.joined())
            .first(where: { $0.nameCake == cake.nameCake}) else { return }
        
        basketCakes.inBasket = false
        
        if let index = selectedCakes.firstIndex(where: { $0.nameCake == cake.nameCake }) {
            selectedCakes.remove(at: index)
        }
        // selectedCakes.append(basketCakes)
        delegateList.forEach {
            $0.cakeServiceDidUpdateFavorites(self)
        }
    }
}
