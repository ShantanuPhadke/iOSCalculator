//
//  ViewController.swift
//  Calculator
//
//  Created by Shantanu Phadke on 12/21/16.
//  Copyright © 2016 Shantanu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Inherits from UIViewController
    //ViewController is a bad name, probably should be replaced, but is fine 
    //for the first few assignments.
    
    //Property -> Instance Variable of a class
    
    @IBOutlet weak var display: UILabel!//We have created an Outlet for the UILabel on our UI display
    //UILabel is an Optional -> gets initialized to nil by deafult in the program
    //Difference between a ? and a ! -> ? does NOT unwrap the Optional, unlike the ! operator
    //The ! signifies that "This is an Optional, BUT always unwrap it whenever it is used"
    
    var userInMiddleOfTypingNumber: Bool = false //In Swift, ALL properties NEED to be initialized right when they are declared! (AKA they need default values)
    
    //weak -> No garbage collection in Swift, simply reference counting when 
    //deciding which variables to throw in the garbage
    
    //UILabel -> Type of the variable display above
    
    @IBAction func appendDigit(sender: UIButton) {
        //IBAction -> Just like Outlet, except a method
        //Has one input, a sender, which is of type UIButton
        //IF you want to return something, -> <return_type> in the method header
        
        let digit = sender.currentTitle!//Let is EXACTLY like var, except its a CONSTANT
        print("digit = \(digit)") //\(...) embeds the ... portion into the string
        
        //Optional -> a type in Swift, specified by ? (eg. String?) can ONLY have TWO values:
        //(a) Not Set -> nil
        //(b) String? -> Optional that CAN BE a String
        
        //Exclamation point (!) can be used to "unwrap" an Optional, BUT
        //if the value of the offset is unset, then the program will crash
        
        if userInMiddleOfTypingNumber{
            display.text = display.text! + digit
        }else{
            display.text = digit
            userInMiddleOfTypingNumber = true
        }
        //display.text is also an Optional
        //Can't append strings to optionals! So have to first unwrap display.text!!
    }
    
    //var operandStack: Array<Double> = Array<Double>()
    //^Considered bad form because the type can be inferred from Array<Double> after =
    
    var operandStack = Array<Double>()
    
    //Initializing instance of an Array of Doubles
    //NOTE: Some classes can have multiple initializers
    @IBAction func enter() {
        userInMiddleOfTypingNumber = false
        operandStack.append(displayValue)
        
        print("Operand Stack: \(operandStack)") //The \(..) notation also works for arrays like operandStack
        
    }
    
    //Computed Properties: We always want whatever is displayed in the display (display.text!) to be converted to a Double Object
    var displayValue: Double {
        get{
            //Default method that will be used to GET current display.text! value
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            
        }set{
           //Default method that will be used to SET the display.text! value
            display.text = "\(newValue)"
            userInMiddleOfTypingNumber = false
        }
    }
    
    
    
    @IBAction func operate(sender: UIButton) {
        
        let operation = sender.currentTitle!
        
        if userInMiddleOfTypingNumber {
            enter()
        }
        
        //switch statement in Swift is just like the switch statement in JAVA
        switch operation{
            case "➕": performOperation(add)
            case "➖": performOperation(subtract)
            case "✖️": performOperation(multiply)
            case "➗": performOperation(divide)
            
            //Even better implementation (does not require add, subtract, multiply, divide buttons
            //case '+': performOperation{$0 + $1}
            //...
            case "℃": performOperation2(fToC)
            default: break
            
        }
        
    }
    
    //Helper function that performs specified operation on the last two elements in operandStack and puts the outcome into operandStack
    //This is possible because we can have function types in Swift!
    func performOperation(operation: (Double, Double) -> Double){
        if(operandStack.count >= 2){
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    //Just the add, subtract, multiply, and divide methods will be defined below this 
    //point in the code
    func add(arg1: Double, arg2: Double) -> Double{
        return arg1 + arg2
    }
    
    func subtract(arg1: Double, arg2: Double) -> Double{
        return arg1 - arg2
    }
    
    func multiply(arg1: Double, arg2: Double) -> Double{
        return arg1 * arg2
    }
    
    func divide(arg1: Double, arg2: Double) -> Double{
        return arg1/arg2
    }
    
    //Method overloading, this is a second performOperation that will take in an operation with a single argument that returns a Double
    func performOperation2(operation: Double -> Double){
        if(operandStack.count >= 1){
            displayValue = operation(operandStack.removeLast())
            //enter() Took out the enter since the only 1 function operation on my calculator is Fahrenheit to Celsius conversion
        }
    }
    
    func fToC(fVal: Double) -> Double{
        return (fVal-32.0)/9.0 * 5.0
    }
}

