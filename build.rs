fn main() {
    // Embed the app icon into the .exe so Explorer and the taskbar show it.
    // Only meaningful when compiling for Windows; a no-op elsewhere.
    if std::env::var("CARGO_CFG_TARGET_OS").as_deref() == Ok("windows") {
        winresource::WindowsResource::new()
            .set_icon("assets/oxpad.ico")
            .compile()
            .expect("failed to embed Windows resources");
    }
}
