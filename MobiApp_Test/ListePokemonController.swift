//
//  ListePokemonController.swift
//  MobiApp_Test
//
//  Created by Florian Baudin on 13/10/2017.
//  Copyright © 2017 Florian Baudin. All rights reserved.
//

import UIKit

class ListePokemonController: UIViewController {
    
    private let pokemonManager:PokemonManager = PokemonManager()
    private var pokemons:[Pokemon] = [Pokemon]()

    override func viewDidLoad() {
        super.viewDidLoad()

        pokemonManager.loadPokemon(completion: receivePokemon)
    }
    
    private func receivePokemon(_ pokemons: [Pokemon], error:Error?) {
        
        self.pokemons = pokemons
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
