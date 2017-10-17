//
//  PokemonInfoViewController.swift
//  MobiApp_Test
//
//  Created by Florian Baudin on 14/10/2017.
//  Copyright © 2017 Florian Baudin. All rights reserved.
//

import UIKit

class PokemonInfoViewController: UIViewController {
    
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonAbilities: UILabel!
    @IBOutlet weak var pokemonTypes: UILabel!
    @IBOutlet weak var pokemonStats: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let pokemonManager:PokemonManager = PokemonManager()
    var pokemon:Pokemon?
    var sharedText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        
        initView(pokemon!)
    }
    
    private func initView(_ pokemon: Pokemon) {
        
        self.pokemonStats.text = "Stats :\n\n"
        self.pokemonTypes.text = "Types :\n\n"
        self.pokemonAbilities.text = "Abilities :\n\n"
        
        self.pokemonName.text = pokemon.name!
        for ability in pokemon.abilities! {
            self.pokemonAbilities.text?.append("\(String(describing: (ability as! Abilities).name!)) \n")
        }
        for type in pokemon.types! {
            self.pokemonTypes.text?.append("\(String(describing: (type as! Types).name!)) \n")
        }
        for stat in pokemon.stats! {
            self.pokemonStats.text?.append("\(String(describing: (stat as! Stats).stat!)) \n")
        }
        self.activityIndicator.isHidden = true
        self.sharedText = "Pokemon: \(self.pokemonName.text!), \(self.pokemonTypes.text!), \(self.pokemonAbilities.text!), \(self.pokemonStats.text!)"
        
    }
    
    @objc private func shareAction() {
        let vc = UIActivityViewController(activityItems: [sharedText], applicationActivities: nil)
        present(vc, animated: true)
    }
}
