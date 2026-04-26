import SwiftUI

struct QRGrid: View {
    let seed: String
    var size: CGFloat = 220

    private var pattern: [[Bool]] {
        let n = 21
        var rng = SeededRNG(seed: seed)
        var grid: [[Bool]] = Array(repeating: Array(repeating: false, count: n), count: n)
        for r in 0..<n {
            for c in 0..<n {
                grid[r][c] = rng.nextBool()
            }
        }
        for (br, bc) in [(0,0),(0,n-7),(n-7,0)] {
            for r in 0..<7 {
                for c in 0..<7 {
                    let edge = r == 0 || r == 6 || c == 0 || c == 6
                    let inner = r >= 2 && r <= 4 && c >= 2 && c <= 4
                    grid[br+r][bc+c] = edge || inner
                }
            }
        }
        return grid
    }

    var body: some View {
        let grid = pattern
        let n = grid.count
        let cell = size / CGFloat(n)
        ZStack {
            RoundedRectangle(cornerRadius: 8).fill(Color.white)
            VStack(spacing: 0) {
                ForEach(0..<n, id: \.self) { r in
                    HStack(spacing: 0) {
                        ForEach(0..<n, id: \.self) { c in
                            Rectangle()
                                .fill(grid[r][c] ? Color.black : Color.white)
                                .frame(width: cell, height: cell)
                        }
                    }
                }
            }
            Circle()
                .fill(ConsumerColors.green)
                .frame(width: size * 0.22, height: size * 0.22)
                .overlay(
                    Text("WIN")
                        .font(.system(size: size * 0.07, weight: .heavy))
                        .foregroundStyle(.white)
                )
                .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
        }
        .frame(width: size, height: size)
    }
}

private struct SeededRNG {
    var state: UInt64
    init(seed: String) {
        var h: UInt64 = 1469598103934665603
        for byte in seed.utf8 {
            h ^= UInt64(byte)
            h = h &* 1099511628211
        }
        self.state = h == 0 ? 1 : h
    }
    mutating func next() -> UInt64 {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
    mutating func nextBool() -> Bool {
        next() % 100 < 48
    }
}
