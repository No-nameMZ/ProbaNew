//
//  CartTableViewController.swift
//  ProbaNew
//
//  Created by No name on 01.07.2024.
//

import UIKit

class CartTableViewController: UITableViewController {
    
    private let cakeService = CakeService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.54, green: 0.51, blue: 0.475, alpha: 1.0)
        
        cakeService.addDelegate(self)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cakeService.selectedCakes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CakeCell", for: indexPath) as? CakeTableViewCell else {
            return UITableViewCell()
        }
        
        let cake = cakeService.selectedCakes[indexPath.row]
        cell.nameLabel.text = cake.nameCake
        cell.gramLabel.text = cake.gram
        cell.photoImage.image = UIImage(named: cake.nameCake)
        cell.priceButton.setTitle(cake.price, for: .normal)
        cell.isLiked = cake.isLike
        cell.likeAction = { [weak self, cake] isLiked in
            if isLiked {
                self?.cakeService.favoriteCake(cake: cake)
            } else {
                self?.cakeService.unfavoriteCake(cake: cake)
            }
        }
        
        cell.likeActionBasket = { [weak self, cake] inBasket in
            if inBasket {
                self?.cakeService.removeFromBasket(cake: cake)
            } else {
                self?.cakeService.addToBasket(cake: cake)
            }
        }
        
        return cell
    }
}
    
extension CartTableViewController: CakeServiceDelegate {
    func cakeServiceDidUpdateFavorites(_ cakeService: any ICakeService) {
        tableView.reloadData()
    }
}

extension CartTableViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        view.addSubview(label)
        view.backgroundColor = tableView.backgroundColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                view.heightAnchor.constraint(equalToConstant: 45)
            ]
        )
        
        label.text = "Корзина"
        label.font = .systemFont(ofSize: 25)
        
        return view
    }
    
}


