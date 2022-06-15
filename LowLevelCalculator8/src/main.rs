pub mod utils;
fn main() {
    println!("Hello, world!");
    let a = utils::utils::ffi::power(33, 2);
    println!("{} is 3", a);
    utils::parser::parseString();
}
