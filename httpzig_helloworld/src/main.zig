const std = @import("std");
const httpz = @import("httpz");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var server = try httpz.Server(void).init(allocator, .{ .port = 8080 }, {});
    defer {
        server.stop();
        server.deinit();
    }

    var router = try server.router(.{});
    router.get("/api/hello", hello, .{});

    std.debug.print("server is running @ http://127.0.0.1:{}\n", .{8080});
    try server.listen();
}

fn hello(req: *httpz.Request, res: *httpz.Response) !void {
    _ = req; // autofix

    res.status = 200;
    res.body = "HELLO WORLD";
}
