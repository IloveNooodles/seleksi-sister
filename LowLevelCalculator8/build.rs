fn main() {
    cxx_build::bridge("src/utils/utils.rs") // returns a cc::Build
        .file("src/utils/utils.cc")
        .compile("cxx-demo");
}
