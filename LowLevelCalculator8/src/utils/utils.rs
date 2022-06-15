#[cxx::bridge]
pub mod ffi {
    unsafe extern "C++" {
        include!("LowLevelCalculator8/src/include/utils.h");

        pub fn absolute(x: i32) -> i32;
        pub fn addition(x: i32, y: i32) -> i32;
        pub fn substraction(x: i32, y: i32) -> i32;
        pub fn multiplication(x: i32, y: i32) -> i32;
        pub fn division(x: i32, y: i32) -> i32;
        pub fn power(x: i32, y: i32) -> i32;
    }
}
