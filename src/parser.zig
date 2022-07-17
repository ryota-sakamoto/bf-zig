const std = @import("std");
const bf = @import("bf.zig");
const allocator = std.heap.page_allocator;

pub fn parse(data: []u8) anyerror![]bf.Type {
    var result = std.ArrayList(bf.Type).init(allocator);

    for (data) |v| {
        const t = switch (v) {
            '>' => bf.Type.PointerIncrement,
            '<' => bf.Type.PointerDecrement,
            '+' => bf.Type.ValueIncrement,
            '-' => bf.Type.ValueDecrement,
            '.' => bf.Type.Print,
            ',' => bf.Type.Read,
            '[' => bf.Type.WhileStart,
            ']' => bf.Type.WhileEnd,
            else => bf.Type.Unknown,
        };
        try result.append(t);
    }

    return result.items;
}
