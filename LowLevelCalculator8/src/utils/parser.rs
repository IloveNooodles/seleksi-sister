use std::{io, fmt::Debug};

// #[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
}

impl Debug for Point {
  fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
    Ok(())
  }
}

pub fn parseString() {
    // let mut stdin = io::stdin();
    let test = Point { x: 1, y: 2 };

    println!("{:?}", test)
}

// 2 + 5 * 3 - 2
