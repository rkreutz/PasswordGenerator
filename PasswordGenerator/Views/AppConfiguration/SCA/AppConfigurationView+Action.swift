import Foundation
import PasswordGeneratorKit

extension AppConfigurationView {

    enum Action {

        case resetMasterPasswordTapped
        case didResetMasterPassword
        case entropyConfigurationUpdated(generator: PasswordGenerator.EntropyGenerator, entropySize: UInt)
        case entropyGeneratorUpdated(PasswordGenerator.EntropyGenerator)
        case entropyGeneratorIterationsUpdated(UInt)
        case entropyGeneratorMemoryUpdated(UInt)
        case entropyGeneratorThreadsUpdated(UInt)
        case entropySizeUpdated(UInt)
        case updateError(Error?)
    }
}
