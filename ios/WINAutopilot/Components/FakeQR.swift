import SwiftUI

struct FakeQR: View {
    let seed: String
    var size: CGFloat = 180

    private var grid: [[Bool]] {
        var hash: UInt64 = 5381
        for c in seed.unicodeScalars { hash = (hash &* 33) &+ UInt64(c.value) }
        let n = 11
        var rows: [[Bool]] = []
        var h = hash
        for _ in 0..<n {
            var row: [Bool] = []
            for _ in 0..<n {
                h = h &* 6364136223846793005 &+ 1442695040888963407
                row.append((h >> 33) % 2 == 0)
            }
            rows.append(row)
        }
        return rows
    }

    var body: some View {
        let g = grid
        let n = g.count
        let cell = size / CGFloat(n)
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
            VStack(spacing: 0) {
                ForEach(0..<n, id: \.self) { r in
                    HStack(spacing: 0) {
                        ForEach(0..<n, id: \.self) { c in
                            let isCorner = (r < 3 && c < 3) || (r < 3 && c >= n - 3) || (r >= n - 3 && c < 3)
                            Rectangle()
                                .fill(g[r][c] || isCorner ? Color.black : Color.white)
                                .frame(width: cell, height: cell)
                        }
                    }
                }
            }
            .padding(8)
        }
        .frame(width: size, height: size)
        .overlay(
            RoundedRectangle(cornerRadius: 14).stroke(Color.black.opacity(0.1), lineWidth: 1)
        )
    }
}
