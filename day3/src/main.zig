const std = @import("std");
const input = @embedFile("input2.txt");

const Symbole = struct {
    x: u32,
    y: u32,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const taille: f32 = @floatFromInt(input.len);
    const largeur: u32 = @intFromFloat(@sqrt(taille));
    std.debug.print("Largeur = {}\n", .{largeur});

    // 1. Passer une 1ere fois pour connaitre la position de tous les symboles
    var symboles: std.ArrayList(Symbole) = std.ArrayList(Symbole).init(allocator);
    defer symboles.deinit();
    var i: usize = 0;
    while (i <= largeur) : (i += 1) {
        var j: usize = 0;
        while (j <= largeur) : (j += 1) {
            std.debug.print("{c}", .{input[i * largeur + j]});
        }
    }
    // 2. Parser les nombres et durant le parsage verifier si chaque digit est adjacent si aucun n est adjacent, on ne compte pas le nombre
}
