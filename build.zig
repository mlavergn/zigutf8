const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addSharedLibrary(.{
        .name = "utf8proc",
        .root_source_file = .{ .path = "utf8proc.zig" },
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();
    b.installArtifact(lib);

    const bin = b.addExecutable(.{
        .name = "example",
        .root_source_file = .{ .path = "utf8.zig" },
        .target = target,
        .optimize = optimize,
    });
    bin.linkSystemLibrary("dist/lib/libicuuc.a");
    bin.linkSystemLibrary("dist/lib/libicui18n.a");
    // bin.linkSystemLibrary("zigutf8/utf8proc-2.9.0/libutf8proc.a");
    bin.linkLibC();

    const tests = b.addTest(.{
        .root_source_file = .{ .path = "utf8.zig" },
        .target = target,
        .optimize = optimize,
    });
    tests.linkSystemLibrary("dist/lib/libicuuc.a");
    tests.linkSystemLibrary("dist/lib/libicui18n.a");
    // tests.linkSystemLibrary("zigutf8/utf8proc-2.9.0/libutf8proc.a");
    const run_tests = b.addRunArtifact(tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_tests.step);
}
