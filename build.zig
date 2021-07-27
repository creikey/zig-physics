const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("zig-physics", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.addIncludeDir("SDL2/include");

    exe.linkLibC();
    exe.linkSystemLibrary("opengl32");
    exe.addLibPath("SDL2/lib/x64");
    exe.linkSystemLibrary("SDL2");
    


    exe.install();

    b.installLibFile("SDL2/lib/x64/SDL2.dll", "bin/SDL2.dll");
    // _ = b.addInstallLibFile(std.build.FileSource.relative("SDL2-2.0.14/lib/x64/SDL2.dll"), "..");
    // file.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
