//
//  File.swift
//  
//
//  Created by Ita on 7/2/20.
//

import Foundation

public extension Dictionary where Key == String, Value == Any {
    func compare(to val: Any?, key: String) -> Operator? {
        guard let value = self[key], let valueToCompare = val else { return nil }
        if let eqActVal = value as? Int, let eqCmpValue = valueToCompare as? Int {
            return eqActVal == eqCmpValue ? .equal : (eqActVal < eqCmpValue ? .lower : .greater)
        } else if let eqActVal = value as? String, let eqCmpValue = valueToCompare as? String {
            return eqActVal == eqCmpValue ? .equal : (eqActVal < eqCmpValue ? .lower : .greater)
        } else if let eqActVal = value as? Double, let eqCmpValue = valueToCompare as? Double {
            return eqActVal == eqCmpValue ? .equal : (eqActVal < eqCmpValue ? .lower : .greater)
        } else if let eqActVal = value as? Bool, let eqCmpValue = valueToCompare as? Bool {
            return eqActVal == eqCmpValue ? .equal : (eqActVal == false  ? .lower : .greater)
        }else if let eqActVal = value as? Float, let eqCmpValue = valueToCompare as? Float {
            return eqActVal == eqCmpValue ? .equal : (eqActVal < eqCmpValue ? .lower : .greater)
        } else if let eqCmpValue = valueToCompare as? Date, let eqActVal = value as? Double {
            let eqCmpValueToDouble = eqCmpValue.timeIntervalSince1970 * 1000
            return eqActVal == eqCmpValueToDouble ? .equal : (eqActVal < eqCmpValueToDouble ? .lower : .greater)
        } else {
            return nil
        }
    }
}
