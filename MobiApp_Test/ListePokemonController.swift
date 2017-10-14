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
        pokemonManager.loadPokemonList(url: url,completion: receivePokemon)
    }
    
    private func receivePokemon(_ pokemons: [Pokemon], error:Error?) {
        
        DispatchQueue.main.async {
            self.pokemons = pokemons
            
            self.tableView.reloadData()
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell")
     
        cell?.textLabel?.text = pokemons[indexPath.row].name!
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pokemonInfoSegue" {
            
            let destination = segue.destination as! PokemonInfoViewController
            destination.pokemon = pokemons[self.tableView.indexPathForSelectedRow!.row]
            
        }
    }
}
