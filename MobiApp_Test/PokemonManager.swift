//
//  PokemonManager.swift
//  MobiApp_Test
//
//  Created by Florian Baudin on 13/10/2017.
//  Copyright © 2017 Florian Baudin. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class PokemonManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadPokemon(url:URL, completion: @escaping (_ data:[Pokemon],_ error:Error?)->()) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion(self.getPokemonsSaved(),error)
                return
            }
            
            self.deleteAllPokemons()
            completion(self.parse(data: data),error)
        }
        task.resume()
    }
    
    private func parse(data: Data?) -> [Pokemon] {
        guard let data = data,
            let serializedJson = try? JSONSerialization.jsonObject(with: data, options: []),
            let result = serializedJson as? [String: Any] else {
                return [Pokemon]()
        }
        
        return getPokemonListFrom(parsedData : result)
    }
    
    private func getPokemonListFrom(parsedData : [String:Any]) -> [Pokemon] {
        
        var pokemonList = [Pokemon]()
        
        let results = parsedData["results"] as! [[String:String]]
        
        for data in results {
            pokemonList.append(getPokemonFrom(parsedData: data))
        }
        
        savePokemons()
        
        return pokemonList
    }
    
    private func getPokemonFrom(parsedData: [String: Any]) -> Pokemon {
        if let name = parsedData["name"] as? String,
            let url = parsedData["url"] as? String{
            
            let pokemon = createPokemon(name: name, url: url)
            
            return pokemon
        }
        return Pokemon()
    }
    
    private func createPokemon(name:String, url:String) -> Pokemon {
        
        let pokemon = Pokemon(context:context)
        
        pokemon.name = name
        pokemon.url = url
        
        return pokemon
    }
    
    private func savePokemons() {
        
        do {
            try self.context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    private func getPokemonsSaved() -> [Pokemon] {
        
        var pokemons:[Pokemon] = []
        do {
            pokemons = try self.context.fetch(Pokemon.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
        return pokemons
    }
    
    private func deleteAllPokemons() {
        
        let pokemonsList = getPokemonsSaved()
        for pokemon in pokemonsList {
            context.delete(pokemon)
        }
        
        do {
            try context.save()
        }catch {
            print("Error")
        }
    }
    
}

