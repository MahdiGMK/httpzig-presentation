const std = @import("std");
const httpz = @import("httpz");

const State = struct {
    counter: usize,
};

pub fn main() !void {
    var deballoc = std.heap.DebugAllocator(.{}){};
    const allocator = deballoc.allocator();

    const state = try allocator.create(State);
    state.counter = 0;
    var server = try httpz.Server(*State).init(allocator, .{ .port = 8080 }, state);
    defer {
        server.stop();
        server.deinit();
    }

    var router = try server.router(.{});
    router.get("/api/hello", hello, .{});

    std.debug.print("server is running @ http://127.0.0.1:{}\n", .{8080});
    try server.listen();
}

fn hello(state: *State, req: *httpz.Request, res: *httpz.Response) !void {
    state.counter += 1;
    res.status = 200;
    var writer = std.Io.Writer.Allocating.init(req.arena);
    try writer.writer.print("HELLO WORLD {}", .{state.counter});
    res.body = try writer.toOwnedSlice();
}
