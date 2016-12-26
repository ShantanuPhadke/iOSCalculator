//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Shantanu Phadke on 12/24/16.
//  Copyright © 2016 Shantanu. All rights reserved.
//

import Foundation
class CalculatorBrain {
    
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String{ //Has to be READ-ONLY string property, so no set
            get{
                switch self{
                    case .Operand(let operand):
                        return "\(operand)"
                    case .UnaryOperation(let symbol, _):
                        return "\(symbol)"
                    case .BinaryOperation(let symbol, _):
                        return "\(symbol)"
                }
            }
        }
    }
    
    private var opStack = [Op]() //Have to specify private when you want objects to be private
    
    private var knownOps = [String:Op]() //Maps the string names of operations to actual Op objects (Dictionary)
    
    //Initializer
    init(){
        //used whenever there is something like let brain = CalculatorBrain()
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("✖️", *))
        learnOp(Op.BinaryOperation("➖", {$1-$0}))
        learnOp(Op.BinaryOperation("➕", +))
        learnOp(Op.BinaryOperation("➗", {$1/$0}))
        learnOp(Op.UnaryOperation("℃", fToC))
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){//In Swift, you can combine multiple data structures into a tuple
        if !ops.isEmpty{
            var remainingOps = ops// Workaround to the implicit let
            
            let op = remainingOps.removeLast() //CANNOT do removeLast on ops because ops has an implicit let in front of it in Swift
            
            //GENERAL NOTES: Like Structs in C, which are also passed in by value
            //Objects of classes are passed in by reference
            switch op {
                case .Operand(let operand): //Inside case operand will have associated value of .Operand
                    return (operand, remainingOps)
            
                case .UnaryOperation(_, let operation): //_ ignores the specific parameter (in our case the String)
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result{
                        return (operation(operand), operandEvaluation.remainingOps)
                    }
                case .BinaryOperation(_, let operation):
                    let op1Evaluation = evaluate(remainingOps)
                    if let operand1 = op1Evaluation.result{
                        let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2Evaluation.result{
                            return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        }
                    }
            }
            
            
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double?{ // Called when you actually want to evaluate your Stack expression
        
        //Example: Stack = {'x', '4', '+', '5', '6'}
        // => 4 x (5 + 6)
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        //opStack elements just convert themselves to the String "Enum Value" over and over 
        //again
        return result
    }
    
    func pushOperand(operand: Double) -> Double? { //Just returns operation everytime you push in an operand
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(operation: String) -> Double?{
        if let myOperation = knownOps[operation]{
            opStack.append(myOperation);
        }//Finding something via dictionary returns an Optional Op! (have to unwrap to use)
        return evaluate()
    }
    
    func fToC(fVal: Double) -> Double{
        return (fVal-32.0)/9.0 * 5.0
    }
    
}