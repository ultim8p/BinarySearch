//
//  File.swift
//  
//
//  Created by Ita on 7/2/20.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    func compare(to val: Any?, key: String) -> Operator? {
        guard let value = self[key], let valueToCompare = val else { return nil }
        if let eqActVal = value as? Int, let eqCmpValue = valueToCompare as? Int {
            return eqActVal == eqCmpValue ? .equal : (eqActVal < eqCmpValue ? .lower : .greater)
        } else if let eqActVal = value as? String, let eqCmpValue = valueToCompare as? String {
            return eqActVal == eqCmpValue ? .equal : (eqActVal < eqCmpValue ? .lower : .greater)
        } else if let eqActVal = value as? Double, let eqCmpValue = valueToCompare as? Double {
            return eqActVal == eqCmpValue ? .equal : (eqActVal < eqCmpValue ? .lower : .greater)
        } else if let eqActVal = value as? Date, let eqCmpValue = valueToCompare as? Date {
            return eqActVal == eqCmpValue ? .equal : (eqActVal < eqCmpValue ? .lower : .greater)
        } else if let eqActVal = value as? Float, let eqCmpValue = valueToCompare as? Float {
            return eqActVal == eqCmpValue ? .equal : (eqActVal < eqCmpValue ? .lower : .greater)
        } else {
            return nil
        }
    }
}
