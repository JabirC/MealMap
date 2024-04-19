//
//  String+SplitArray.swift
//  MealMap
//
//  Created by Jabir Chowdhury
//

import Foundation


extension String {
    func split() -> [String]{
            return self.components(separatedBy: "#")
    }
    
    func generalSplit() -> [String]{
        var splitByComma = self.components(separatedBy: ",")
        for (ind, element) in splitByComma.enumerated() {
            splitByComma[ind] = element.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return splitByComma
    }
}
