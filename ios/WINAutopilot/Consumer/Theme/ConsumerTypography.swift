import SwiftUI

enum ConsumerTypography {
    static func display(_ size: CGFloat) -> Font {
        .custom("Syne-ExtraBold", size: size, relativeTo: .title)
    }
    static func displayBold(_ size: CGFloat) -> Font {
        .custom("Syne-Bold", size: size, relativeTo: .title)
    }
    static func body(_ size: CGFloat) -> Font {
        .custom("DMSans-Regular", size: size, relativeTo: .body)
    }
    static func bodyMedium(_ size: CGFloat) -> Font {
        .custom("DMSans-Medium", size: size, relativeTo: .body)
    }
    static func bodyLight(_ size: CGFloat) -> Font {
        .custom("DMSans-Light", size: size, relativeTo: .body)
    }

    enum Sizes {
        static let xs: CGFloat = 9
        static let sm: CGFloat = 11
        static let md: CGFloat = 13
        static let lg: CGFloat = 15
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 26
        static let deal: CGFloat = 30
        static let hero: CGFloat = 36
    }
}

extension View {
    func consumerDisplay(_ size: CGFloat = 20) -> some View {
        self.font(.system(size: size, weight: .heavy, design: .default))
    }
    func consumerBody(_ size: CGFloat = 13, weight: Font.Weight = .regular) -> some View {
        self.font(.system(size: size, weight: weight, design: .default))
    }
}
