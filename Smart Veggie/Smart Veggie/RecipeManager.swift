//
//  RecipeManager.swift
//  Smart Veggie
//
//  Created by lttc on 17/6/2019.
//  Copyright © 2019 Team B. All rights reserved.
//

import Foundation

class RecipeManager {
    
    private static var material: [String: Int]!
    private static var receipe: [String: Int] = ["brocolli": 100, "carrot": 100, "salt": 10, "oil": 20] //demo recipe
    
    /*
     name: the name of the material
     quan: the quantity of the food (represented in gram)
    */
    public static func addMaterial(name: String, quan: Int) {
        print("adding \(name), \(quan)g to list")
        self.material[name] = quan
    }
    
    public static func getMaterial() -> Dictionary<String, Int> {
        return self.material
    }
    
}
