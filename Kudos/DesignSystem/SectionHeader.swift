import SwiftUI

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(BrandColor.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
