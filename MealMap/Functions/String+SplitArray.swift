//
//  String+SplitArray.swift
//  MealMap
//
//  Created by Jabir Chowdhury on 5/18/23.
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
