import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ProfileQRView: View {
    let text: String

    var qrImage: Image? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(text.utf8)
        filter.correctionLevel = "M"
        guard let outputImage = filter.outputImage else { return nil }
        let scaled = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return Image(uiImage: UIImage(cgImage: cgImage))
    }

    var body: some View {
        Group {
            if let qr = qrImage {
                qr
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
            } else {
                Color.secondary.opacity(0.2)
                    .overlay(Image(systemName: "qrcode"))
            }
        }
    }
}

#Preview {
    ProfileQRView(text: "https://viz.cx/@kudos-demo")
        .frame(width: 200, height: 200)
        .padding()
}
