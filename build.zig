const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const tool = b.addExecutable(.{
        .name = "w2c2",
        .link_libc = true,
        .target = b.host,
    });
    tool.addIncludePath(b.path("w2c2"));
    tool.addCSourceFiles(.{ .files = &.{ "./w2c2/export.c", "./w2c2/c.c", "./w2c2/file.c", "./w2c2/debug.c", "./w2c2/opcode.c", "./w2c2/reader.c", "./w2c2/instruction.c", "./w2c2/main.c", "./w2c2/array.c", "./w2c2/section.c", "./w2c2/stringbuilder.c", "./w2c2/valuetype.c", "./w2c2/compat.c", "./w2c2/sha1.c" }, .flags = &.{"-DHAS_UNISTD"} });
    b.installArtifact(tool);
    const target = b.standardTargetOptions(.{});
    const lib = b.addStaticLibrary(.{ .name = "w2c2_base", .link_libc = true, .target = target, .optimize = optimize });
    lib.addIncludePath(b.path("w2c2"));
    lib.addCSourceFile(.{ .file = b.path("./dummy.c") });
    b.installArtifact(lib);
    const wasi = b.addStaticLibrary(.{ .name = "w2c2_wasi", .link_libc = true, .target = target, .optimize = optimize });
    wasi.linkLibrary(lib);
    wasi.addIncludePath(b.path("wasi"));
    wasi.addCSourceFiles(.{ .files = &.{"./wasi/wasi.c"}, .flags = &.{ "-DHAS_UNISTD", "-DHAS_TIMESPEC" } });
    b.installArtifact(wasi);
}
