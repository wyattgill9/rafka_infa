fn main() {
    tonic_build::compile_protos("proto/engine.proto").unwrap();
}