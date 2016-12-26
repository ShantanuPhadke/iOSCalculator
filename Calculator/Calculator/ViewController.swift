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
    
    var myBrain = CalculatorBrain()
    
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
    
    //var operandStack = Array<Double>()
    
    //Initializing instance of an Array of Doubles
    //NOTE: Some classes can have multiple initializers
    
    @IBAction func enter() {
        userInMiddleOfTypingNumber = false
        if let result = myBrain.pushOperand(displayValue){
            displayValue = result
        }else{
            displayValue = 0 //This is if evaluate in CalculatorBrain returns nil!
        }
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
        
        if userInMiddleOfTypingNumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = myBrain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
        
    }
    
}

