//
//  CakeTableViewCell.swift
//  ProbaNew
//
//  Created by No name on 25.06.2024.
//

import UIKit

class CakeTableViewCell: UITableViewCell {
    
// MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gramLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var cake: Cake?
    
    var likeAction: ((Bool) -> Void)?
    var likeActionBasket: ((Bool) -> Void)?
        
    var isLiked: Bool = false {
        didSet {
            likeButton.tintColor = isLiked ? .systemRed : .systemGray
        }
    }
    
    var inBasket: Bool = false {
        didSet {
            let title = inBasket ? "В корзине" : (cake?.price ?? "")
            priceButton.setTitle(title, for: .normal)
            
            priceButton.isHidden = inBasket
            deleteButton.isHidden = !inBasket
            addButton.isHidden = !inBasket
            quantityLabel.isHidden = !inBasket
        }
        
    }
    /// Cвойство для отслеживания количества тортов в корзине
    var quantity: Int = 0 {
        didSet {
            quantityLabel.text = "\(quantity)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteButton.isHidden = true
        addButton.isHidden = true
        quantityLabel.isHidden = true
    }

    
// MARK: - IBAction
    @IBAction func priceButtonDidTapped(_ sender: Any) {
        
        inBasket.toggle()
        likeActionBasket?(inBasket)
        
    }
    
    @IBAction func deleteButtonDidTapped() {
        
        // Уменьшаем количество тортов в корзине
        if quantity > 0 {
            quantity -= 1
        }
        
        // Если количество тортов в корзине равно 0, скрываем кнопки управления и показываем кнопку цены
        if quantity == 0 {
            inBasket = false
        }
    }
    
    @IBAction func addButtonDidTapped() {
        
        // Увеличиваем количество тортов в корзине
        quantity += 1
    }
    
    @IBAction func likeButtonDidTapped(_ sender: Any) {
        isLiked.toggle()
        likeAction?(isLiked)
    }
    
    func configurate(with cake: Cake) {
        self.cake = cake
        
        nameLabel.text = cake.nameCake
        gramLabel.text = cake.gram
        photoImage.image = UIImage(named: cake.nameCake)
        isLiked = cake.isLike
        inBasket = cake.inBasket
        
        // Устанавливаем начальное количество тортов в корзине
        if cake.inBasket {
            quantity = cake.quantity
        }
        
        // Обновляем текст метки количества
        quantityLabel.text = "\(quantity)"
    }
}
