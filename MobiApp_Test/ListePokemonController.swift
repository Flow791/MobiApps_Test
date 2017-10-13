//
//  ListePokemonController.swift
//  MobiApp_Test
//
//  Created by Florian Baudin on 13/10/2017.
//  Copyright © 2017 Florian Baudin. All rights reserved.
//

import UIKit

class ListePokemonController: UITableViewController {
    
    private let pokemonManager:PokemonManager = PokemonManager()
    private var pokemons:[Pokemon] = [Pokemon]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let url:URL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        pokemonManager.loadPokemon(url: url,completion: receivePokemon)
    }
    
    private func receivePokemon(_ pokemons: [Pokemon], error:Error?) {
        
        self.pokemons = pokemons
        
        for pokemon in pokemons {
            print("NOM : \(pokemon.name!)")
        }
        
    }

}
