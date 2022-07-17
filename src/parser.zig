const std = @import("std");
const bf = @import("bf.zig");
const allocator = std.heap.page_allocator;

pub fn parse(data: []u8) anyerror![]bf.Type {
    var result = std.ArrayList(bf.Type).init(allocator);
    var start = std.ArrayList(usize).init(allocator);

    for (data) |v, i| {
        const t: bf.Type = switch (v) {
            '>' => bf.Type.PointerIncrement,
            '<' => bf.Type.PointerDecrement,
            '+' => bf.Type.ValueIncrement,
            '-' => bf.Type.ValueDecrement,
            '.' => bf.Type.Print,
            ',' => bf.Type.Read,
            '[' => blk: {
                try start.append(i);
                break :blk bf.Type{ .WhileStart = .{ .end = 0 } };
            },
            ']' => blk: {
                var pos = start.pop();
                result.items[pos].WhileStart.end = i;
                break :blk bf.Type{ .WhileEnd = .{ .start = pos } };
            },
            else => bf.Type.Unknown,
        };
        try result.append(t);
    }

    return result.items;
}
