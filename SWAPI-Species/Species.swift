//
//  Species.swift
//  SWAPI-Species
//
//  Created by John Gallaugher on 8/13/18.
//  Copyright © 2018 John Gallaugher. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Species {
    struct SpeciesData {
        var name = ""
        var url = ""
    }
    
    var nextURL = "https://swapi.co/api/species/"
    var numberOfSpecies = 0
    var speciesArray = [SpeciesData]()
    
    func getSpecies(completed: @escaping ()->() ) {
        Alamofire.request(nextURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.numberOfSpecies = json["count"].intValue
                self.nextURL = json["next"].stringValue
                let results = json["results"]
                for index in 0..<results.count {
                    let name = json["results"][index]["name"].stringValue
                    let url = json["results"][index]["url"].stringValue
                    self.speciesArray.append(SpeciesData(name: name, url: url))
                    print("\(self.speciesArray[index].name) \(self.speciesArray[index].url)")
                }
                print("URL = \(self.nextURL)")
                print("# of species = \(self.numberOfSpecies)")
            case .failure(let error):
                print("ERROR \(error) calling Alamofire at url \(self.nextURL)")
            }
            completed()
        }
    }
}
