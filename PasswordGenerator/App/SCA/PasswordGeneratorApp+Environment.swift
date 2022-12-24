import Foundation
import protocol PasswordGeneratorKit.MasterPasswordProvider
import protocol Combine.Scheduler
import struct ComposableArchitecture.AnyScheduler
import struct ComposableArchitecture.AnySchedulerOf
import class UIKit.UIPasteboard

extension PasswordGeneratorApp {

    struct Environment {

        let scheduler: AnySchedulerOf<DispatchQueue>
        let hapticManager: HapticManager
        let pasteboard: Pasteboard
        let masterPasswordStorage: MasterPasswordStorage
        let masterPasswordValidator: MasterPasswordValidator
        let masterPasswordProvider: MasterPasswordProvider
        let entropyConfigurationStorage: EntropyConfigurationStorage

        init<Scheduler: Combine.Scheduler>(
            scheduler: Scheduler,
            hapticManager: HapticManager,
            pasteboard: Pasteboard,
            masterPasswordStorage: MasterPasswordStorage,
            masterPasswordValidator: MasterPasswordValidator,
            masterPasswordProvider: MasterPasswordProvider,
            entropyConfigurationStorage: EntropyConfigurationStorage
        ) where
            Scheduler.SchedulerOptions == DispatchQueue.SchedulerOptions,
            Scheduler.SchedulerTimeType == DispatchQueue.SchedulerTimeType {

            self.scheduler = AnyScheduler(scheduler)
            self.hapticManager = hapticManager
            self.pasteboard = pasteboard
            self.masterPasswordStorage = masterPasswordStorage
            self.masterPasswordValidator = masterPasswordValidator
            self.masterPasswordProvider = masterPasswordProvider
            self.entropyConfigurationStorage = entropyConfigurationStorage
        }
    }
}

// MARK: Factories

extension PasswordGeneratorApp.Environment {

    static func live() -> Self {

        let keychain = MasterPasswordKeychain()
        return PasswordGeneratorApp.Environment(
            scheduler: DispatchQueue.main,
            hapticManager: UIKitHapticManager(),
            pasteboard: UIPasteboard.general,
            masterPasswordStorage: keychain,
            masterPasswordValidator: keychain,
            masterPasswordProvider: keychain,
            entropyConfigurationStorage: UserDefaultsEntropyConfigurationStorage(userDefaults: .standard)
        )
    }

    #if DEBUG
    static func mock() -> Self {
        let passwordStorage = MockMasterPasswordStorage()
        return PasswordGeneratorApp.Environment(
            scheduler: DispatchQueue.main,
            hapticManager: UIKitHapticManager(),
            pasteboard: UIPasteboard.general,
            masterPasswordStorage: passwordStorage,
            masterPasswordValidator: passwordStorage,
            masterPasswordProvider: passwordStorage,
            entropyConfigurationStorage: UserDefaultsEntropyConfigurationStorage(userDefaults: .standard)
        )
    }
    #endif
}

extension MasterPasswordView.Environment {

    init(from passwordGeneratorAppEnvironment: PasswordGeneratorApp.Environment) {

        self.init(masterPasswordStorage: passwordGeneratorAppEnvironment.masterPasswordStorage)
    }
}

extension PasswordGeneratorView.Environment {

    init(from passwordGeneratorAppEnvironment: PasswordGeneratorApp.Environment) {

        self.init(
            scheduler: passwordGeneratorAppEnvironment.scheduler,
            hapticManager: passwordGeneratorAppEnvironment.hapticManager,
            pasteboard: passwordGeneratorAppEnvironment.pasteboard,
            masterPasswordStorage: passwordGeneratorAppEnvironment.masterPasswordStorage,
            masterPasswordProvider: passwordGeneratorAppEnvironment.masterPasswordProvider
        )
    }
}

extension AppConfigurationView.Environment {

    init(from passwordGeneratorAppEnvironment: PasswordGeneratorApp.Environment) {

        self.init(
            entropyConfigurationStorage: passwordGeneratorAppEnvironment.entropyConfigurationStorage,
            masterPasswordStorage: passwordGeneratorAppEnvironment.masterPasswordStorage
        )
    }
}
