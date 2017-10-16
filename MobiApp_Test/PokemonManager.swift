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

enum Mode {
    case Multi
    case Single
}

class PokemonManager {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadPokemonList(url:URL, completion: @escaping (_ data:[Pokemon],_ error:Error?)->()) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion(self.getPokemonsSaved(),error)
                return
            }
            
            self.deleteAllPokemons()
            completion(self.parse(data: data, mode:Mode.Multi),error)
        }
        task.resume()
    }
    
    func loadPokemon(url:URL, completion: @escaping (_ data:[Pokemon],_ error:Error?)->()) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion([Pokemon](),error)
                return
            }
            
            completion(self.parse(data: data, mode:Mode.Single),error)
        }
        task.resume()
    }
    
    private func parse(data: Data?, mode:Mode) -> [Pokemon] {
        guard let data = data,
            let serializedJson = try? JSONSerialization.jsonObject(with: data, options: []),
            let result = serializedJson as? [String: Any] else {
                return [Pokemon]()
        }
        
        guard mode == Mode.Multi else {
            return getPokemonFrom(parsedData: result)
        }
        return getPokemonListFrom(parsedData : result)
    }
    
    private func getPokemonListFrom(parsedData : [String:Any]) -> [Pokemon] {
        
        var pokemonList = [Pokemon]()
        
        let results = parsedData["results"] as! [[String:String]]
        
        for data in results {
            pokemonList.append(getPokemonsFrom(parsedData: data))
        }
        
        savePokemons()
        
        return pokemonList
    }
    
    private func getPokemonsFrom(parsedData: [String: Any]) -> Pokemon {
        if let name = parsedData["name"] as? String,
            let url = parsedData["url"] as? String{
            
            let pokemon = createPokemon(name: name, url: url)
            
            return pokemon
        }
        return Pokemon()
    }
    
    private func getPokemonFrom(parsedData: [String: Any]) -> [Pokemon] {
        if let abilitiesData = parsedData["abilities"] as? [[String:Any]],
            let typesData = parsedData["types"] as? [[String:Any]],
            let statsData = parsedData["stats"] as? [[String:Any]],
            let formsData = parsedData["forms"] as? [[String:Any]] {
            
            let pokemonName = formsData[0]["name"] as! String
            let pokemon:Pokemon = searchPokemon(name: pokemonName)
            
            for abilitieData in abilitiesData {
                let abilitieArray = abilitieData["ability"] as! [String:String]
                let abilityName = abilitieArray["name"]
                
                let ability = Abilities(context: context)
                ability.name = abilityName!
                
                ability.pokemon = pokemon
            }
            
            for typeData in typesData {
                
                let typeArray = typeData["type"] as! [String:String]
                let typeName = typeArray["name"]
                
                let type = Types(context: context)
                type.name = typeName!
                
                type.pokemon = pokemon
            }
            
            for statData in statsData {
                let baseStat = statData["base_stat"] as! Int16
                let statArray = statData["stat"] as! [String:String]
                let statName = statArray["name"]
                
                let stat = Stats(context:context)
                stat.stat = statName!
                stat.base_stat = baseStat
                
                stat.pokemon = pokemon
            }
            
            savePokemons()
            return [pokemon]
        }
        return [Pokemon]()
    }
    
    private func searchPokemon(name:String) -> Pokemon {
        
        var pokemon:Pokemon = Pokemon()
        let pokemons = getPokemonsSaved()
     
        for result in pokemons {
            if result.name == name {
                pokemon = result
            }
        }
        return pokemon
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

