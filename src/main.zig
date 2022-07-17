const std = @import("std");
const parser = @import("parser.zig");
const bf = @import("bf.zig");

pub fn main() anyerror!void {
    if (std.os.argv.len < 2) {
        std.log.err("{s} [file]", .{std.os.argv[0]});
        std.log.err("specify a file", .{});
        std.os.exit(1);
    }

    const name: []const u8 = std.os.argv[1][0..strlen(std.os.argv[1])];
    const data = try readFile(name);

    const actions = try parser.parse(data);
    try bf.run(actions);
}

fn readFile(name: []const u8) anyerror![]u8 {
    const file = try std.fs.cwd().openFile(name, .{});
    defer file.close();

    var reader = std.io.bufferedReader(file.reader());
    const stream = reader.reader();

    var buf: [1024]u8 = undefined;
    const last = try stream.readAll(&buf);

    return buf[0..last];
}

fn strlen(ptr: [*]const u8) usize {
    var count: usize = 0;
    while (ptr[count] != 0) : (count += 1) {}
    return count;
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
