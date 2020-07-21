//
//  File.swift
//  
//
//  Created by Ita on 7/2/20.
//

import Foundation

public enum Operator {
    case equal
    case greater
    case lower
    
    static func getOp(with op: LowerOperator) -> Operator {
        switch op {
        case .greaterOrequal:
            return .equal
        case .greater:
            return .greater
        }
    }

    static func getOp(with op: UpperOperator) -> Operator {
        switch op {
        case .lowerOrequal:
            return .equal
        case .lower:
            return .lower
        }
    }
}

