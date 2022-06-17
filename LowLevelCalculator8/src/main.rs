pub mod utils;
use std::{
    char,
    io::{self},
};
fn main() {
    let mut input = String::new();
    let mut stack: Vec<i32> = vec![];
    let mut operations: &str = "_";
    let mut err: bool = false;

    println!("Welcome to low level calculator made by rust :D");
    println!("To use the calculator just input the expression as usual: ex 1 + 2 * 3");
    println!("make sure to just only have 1 space between each number/operation");
    println!("The calculator only works with integer :D so please keep that in mind");
    // read the input
    io::stdin()
        .read_line(&mut input)
        .expect("There was an error reading the string");

    if !is_input_valid(&input) {
        println!("Please enter correct input");
        return;
    }

    let char_vector: Vec<_> = input.trim().split_whitespace().collect();

    for character in char_vector {
        if let Ok(x) = character.parse() {
            stack.push(x);
        }

        if is_valid_operation(character) {
            operations = character;
        }

        if is_complete(&stack, operations) {
            let (y, x) = (stack.pop().unwrap(), stack.pop().unwrap());
            match operations {
                "+" => stack.push(utils::utils::ffi::addition(x, y)),
                "-" => stack.push(utils::utils::ffi::substraction(x, y)),
                "*" => stack.push(utils::utils::ffi::multiplication(x, y)),
                "/" => stack.push(utils::utils::ffi::division(x, y)),
                "^" => stack.push(utils::utils::ffi::power(x, y)),
                _ => {
                    println!("INI ERROR NGABB {}", operations);
                    err = true;
                    break;
                }
            }
        }
    }

    if !err && stack.len() == 1 {
        println!(
            "The Result of {}(without order of operation) is {}",
            input,
            stack.pop().unwrap()
        );
    }
    if err {
        println!("There was some error, try to put correct number")
    }
}

fn is_input_valid(input: &str) -> bool {
    input
        .chars()
        .all(|c| c.is_numeric() || is_valid_operation_char(c) || c.is_whitespace())
}

fn is_valid_operation(operation: &str) -> bool {
    return operation == "+"
        || operation == "-"
        || operation == "*"
        || operation == "/"
        || operation == "^";
}

fn is_valid_operation_char(operation: char) -> bool {
    return operation == '+'
        || operation == '-'
        || operation == '*'
        || operation == '/'
        || operation == '^';
}

fn is_complete(calc_input: &Vec<i32>, operation: &str) -> bool {
    return calc_input.len() == 2 && is_valid_operation(operation);
}
