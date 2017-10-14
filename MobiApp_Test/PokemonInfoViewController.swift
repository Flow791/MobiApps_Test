//
//  PokemonInfoViewController.swift
//  MobiApp_Test
//
//  Created by Florian Baudin on 14/10/2017.
//  Copyright © 2017 Florian Baudin. All rights reserved.
//

import UIKit

class PokemonInfoViewController: UIViewController {

    private let pokemonManager:PokemonManager = PokemonManager()
    var pokemon:Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url:URL = URL(string: pokemon!.url!)!
        pokemonManager.loadPokemon(url: url,completion: receivePokemon)
    }
    
    private func receivePokemon(_ pokemons: [Pokemon], error:Error?) {
        
        print(pokemons)
    }
    
}
