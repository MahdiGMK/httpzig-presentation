const std = @import("std");
pub fn main() !void {
    const addr = std.net.Address.initIp4(.{ 0, 0, 0, 0 }, 8080);
    var srv = try addr.listen(.{});
    std.debug.print("server is running @ http://127.0.0.1:{}\n", .{8080});
    while (true) {
        var conn = try srv.accept();
        var rbuf: [1024]u8 = undefined;
        var wbuf: [32]u8 = undefined;

        var reader = conn.stream.reader(&rbuf);
        var writer = conn.stream.writer(&wbuf);

        var http = std.http.Server.init(reader.interface(), &writer.interface);
        var req = try http.receiveHead();
        std.debug.print(
            \\content_length            : {?}
            \\content_type              : {?s}
            \\expect                    : {?s}
            \\keep_alive                : {}
            \\method                    : {}
            \\target                    : {s}
            \\transfer_compression      : {}
            \\transfer_encoding         : {}
            \\version                   : {}
        , .{
            req.head.content_length,
            req.head.content_type,
            req.head.expect,
            req.head.keep_alive,
            req.head.method,
            req.head.target,
            req.head.transfer_compression,
            req.head.transfer_encoding,
            req.head.version,
        });

        try req.respond("HELLO WORLD", .{ .keep_alive = false });
    }
}
