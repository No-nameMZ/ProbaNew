//
//  CatalogTableViewController.swift
//  ProbaNew
//
//  Created by No name on 21.06.2024.
//

import UIKit

class CatalogTableViewController: UITableViewController {

    private let cakeService = CakeService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
       
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.54, green: 0.51, blue: 0.475, alpha: 1.0)
        
        cakeService.addDelegate(self)
        
        
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        cakeService.cakeGroups.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cakeService.cakeGroups[section].cakes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CakeCell", for: indexPath) as? CakeTableViewCell else {
            return UITableViewCell()
        }
        
        let cake = cakeService.cakeGroups[indexPath.section].cakes[indexPath.row]
        cell.configurate(with: cake)
        
        cell.likeAction = { [weak self, cake] isLiked in
            if isLiked {
                self?.cakeService.favoriteCake(cake: cake)
            } else {
                self?.cakeService.unfavoriteCake(cake: cake)
            }
        }
        
        cell.likeActionBasket = { [weak self, cake] inBasket in
            if inBasket {
                self?.cakeService.addToBasket(cake: cake)
            } else {
                self?.cakeService.removeFromBasket(cake: cake)
            }
        }

        
        
        return cell
    }
}

extension CatalogTableViewController: CakeServiceDelegate {
    func cakeServiceDidUpdateFavorites(_ cakeService: any ICakeService) {
        tableView.reloadData()
    }
}

extension CatalogTableViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let group = cakeService.cakeGroups[section]
        let view = UIView()
        let label = UILabel()
        view.addSubview(label)
        view.backgroundColor = tableView.backgroundColor
        
        
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                view.heightAnchor.constraint(equalToConstant: 50)
            ]
        )
        
        label.text = group.title
        label.font = .systemFont(ofSize: 25)
        
        
        
        return view
    }
    
}
