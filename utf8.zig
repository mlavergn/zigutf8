const std = @import("std");

pub const Lib = @cImport({
    @cInclude("unicode/ustring.h");
});

pub const UTF8 = struct {
    _: []u8,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, value: []const u8) !UTF8 {
        const copy = try allocator.dupe(u8, value);
        return .{ ._ = copy, .allocator = allocator };
    }

    pub fn deinit(self: UTF8) void {
        self.allocator.free(self._);
        self.allocator = undefined;
        self._ = undefined;
    }

    pub fn count() u64 {
        var utf16String: Lib.UChar = "Hello, 你好";

        var status: Lib.UErrorCode = Lib.U_ZERO_ERROR;
        var converter: *Lib.UConverter = Lib.ucnv_open("UTF-8", &status);
        if (Lib.U_SUCCESS(status)) {
            var utf8Buffer: u8[256] = undefined;
            Lib.ucnv_fromUChars(converter, utf8Buffer, utf8Buffer.len, utf16String, -1, &status);
            if (Lib.U_SUCCESS(status)) {
                       std.debug.print("\nOK\n"); 
            }
        }

        return 0;
    }

    pub fn description(self: UTF8) void {
        std.debug.print("\nUTF8[{d}]: {s}\n", .{ self._.len, self._ });
    }
};

test "utf8" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    // var allocator = std.testing.allocator;
    var string = try UTF8.init(allocator, "Hello world");
    string.description();
}