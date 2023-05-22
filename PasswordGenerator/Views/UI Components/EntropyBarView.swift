import ComposableArchitecture
import PasswordGeneratorKit
import SwiftUI

struct EntropyBarView: View {

    let entropy: Double

    var body: some View {
        ProgressView(
          value: entropy,
          total: Defaults.Entropy.max,
          label: { Text(entropyLabelFor: entropy).foregroundColor(for: entropy) }
        )
        .colored(for: entropy)
    }
}

private extension Text {
    init(entropyLabelFor entropy: Double) {
        switch entropy {
        case Defaults.Entropy.great...:
            self.init(Strings.PasswordGeneratorView.veryStrongPassword(Int(entropy)))
        case Defaults.Entropy.recommended...:
            self.init(Strings.PasswordGeneratorView.recommendedPassword(Int(entropy)))
        case Defaults.Entropy.low...:
            self.init(Strings.PasswordGeneratorView.weakPassword(Int(entropy)))
        default:
            self.init(Strings.PasswordGeneratorView.veryWeakPassword(Int(entropy)))
        }
    }
}

private extension View {
    func foregroundColor(for entropy: Double) -> some View {
        switch entropy {
        case Defaults.Entropy.great...:
            return self.foregroundColor(.systemBlue)
        case Defaults.Entropy.recommended...:
            return self.foregroundColor(.systemGreen)
        case Defaults.Entropy.low...:
            return self.foregroundColor(.systemOrange)
        default:
            return self.foregroundColor(.systemRed)
        }
    }
}

private extension ProgressView {
    func colored(for entropy: Double) -> some View {
        switch entropy {
        case Defaults.Entropy.great...:
            return self.progressViewStyle(LinearProgressViewStyle(tint: .systemBlue))
        case Defaults.Entropy.recommended...:
            return self.progressViewStyle(LinearProgressViewStyle(tint: .systemGreen))
        case Defaults.Entropy.low...:
            return self.progressViewStyle(LinearProgressViewStyle(tint: .systemOrange))
        default:
            return self.progressViewStyle(LinearProgressViewStyle(tint: .systemRed))
        }
    }
}
