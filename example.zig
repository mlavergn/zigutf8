const std = @import("std");
const UTF8 = @import("utf8.zig").UTF8;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    var utf8String = try UTF8.init(allocator, "Hello world");
    UTF8.count();
    utf8String.description();
}
