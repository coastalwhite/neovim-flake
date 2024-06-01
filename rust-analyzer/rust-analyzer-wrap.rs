fn main() -> std::io::Result<()> {
    use std::io::ErrorKind;
    use std::os::unix::process::CommandExt;
    use std::process::Command;

    let exec_err = Command::new("rust-analyzer").exec();
    match exec_err.kind() {
        ErrorKind::NotFound => {}
        _ => return std::io::Result::Err(exec_err),
    }

    std::io::Result::Err(
        Command::new("@rust-analyzer@")
            .env("RUST_SRC_PATH", "@RUST_SRC_PATH@")
            .exec(),
    )
}
