const std = @import("std");

pub fn build(b: *std.Build) void {
    const targ = b.standardTargetOptions(.{});
    const opt = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "std_helloworld",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = targ,
            .optimize = opt,
        }),
    });
    b.installArtifact(exe);
    const run = b.addRunArtifact(exe);
    const run_step = b.step("run", "run app");
    run_step.dependOn(&run.step);
}
