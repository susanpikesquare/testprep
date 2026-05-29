import SwiftUI

enum AppTheme {
    static let navy = Color(red: 0.03, green: 0.10, blue: 0.30)
    static let primary = Color(red: 0.02, green: 0.25, blue: 0.67)
    static let royalBlue = Color(red: 0.03, green: 0.39, blue: 0.86)
    static let sky = Color(red: 0.04, green: 0.67, blue: 0.96)
    static let gold = Color(red: 1.00, green: 0.72, blue: 0.10)
    static let orange = Color(red: 0.94, green: 0.42, blue: 0.08)
    static let green = Color(red: 0.29, green: 0.72, blue: 0.10)
    static let purple = Color(red: 0.48, green: 0.18, blue: 0.75)
    static let red = Color(red: 0.82, green: 0.12, blue: 0.08)
    static let teal = Color(red: 0.02, green: 0.55, blue: 0.60)
    static let coral = red
    static let mint = green
    static let ink = Color(red: 0.05, green: 0.08, blue: 0.16)
    static let background = Color(red: 0.94, green: 0.96, blue: 1.00)
    static let surface = Color.white

    static let questGradient = LinearGradient(
        colors: [navy, royalBlue, sky],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let adventureGradient = LinearGradient(
        colors: [Color(red: 0.02, green: 0.11, blue: 0.39), Color(red: 0.05, green: 0.31, blue: 0.77), Color(red: 0.04, green: 0.62, blue: 0.92)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static func subjectColor(_ subject: SubjectArea) -> Color {
        switch subject {
        case .reading:
            return royalBlue
        case .writing:
            return green
        case .math:
            return orange
        case .science:
            return purple
        case .socialStudies:
            return red
        }
    }
}

struct CalmHeaderView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.largeTitle.bold())
                .foregroundStyle(AppTheme.ink)
            Text(subtitle)
                .font(.title3)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct BrandedPageHeroView: View {
    let title: String
    let subtitle: String
    let iconName: String
    let badgeText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(AppTheme.gold)
                    Image(systemName: iconName)
                        .font(.system(size: 30, weight: .black))
                        .foregroundStyle(.white)
                }
                .frame(width: 66, height: 66)
                .shadow(color: AppTheme.gold.opacity(0.35), radius: 12, y: 6)

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    Text(subtitle)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.82))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            HStack(spacing: 8) {
                Text("PREPQUEST")
                    .font(.caption.bold())
                    .foregroundStyle(AppTheme.navy)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(AppTheme.gold, in: Capsule())

                Text(badgeText.uppercased())
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.white.opacity(0.16), in: Capsule())
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.adventureGradient, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(AppTheme.gold, lineWidth: 3)
        )
        .shadow(color: AppTheme.primary.opacity(0.18), radius: 14, y: 8)
    }
}

struct SubjectTokenStrip: View {
    var body: some View {
        HStack(spacing: 8) {
            ForEach(SubjectArea.allCases, id: \.self) { subject in
                Image(systemName: subject.iconName)
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                    .background(AppTheme.subjectColor(subject), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .accessibilityLabel(subject.rawValue)
            }
        }
    }
}
