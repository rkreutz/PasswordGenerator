import Foundation
import class PasswordGeneratorKit.PasswordGenerator
import protocol Combine.Scheduler
import struct ComposableArchitecture.AnyScheduler
import struct ComposableArchitecture.AnySchedulerOf
import class UIKit.UIPasteboard

extension PasswordGeneratorView {

    struct Environment {

        let scheduler: AnySchedulerOf<DispatchQueue>
        let hapticManager: HapticManager
        let pasteboard: Pasteboard
        let masterPasswordStorage: MasterPasswordStorage
        let passwordGenerator: PasswordGenerator

        init<Scheduler: Combine.Scheduler>(
            scheduler: Scheduler,
            hapticManager: HapticManager,
            pasteboard: Pasteboard,
            masterPasswordStorage: MasterPasswordStorage,
            passwordGenerator: PasswordGenerator
        ) where
            Scheduler.SchedulerOptions == DispatchQueue.SchedulerOptions,
            Scheduler.SchedulerTimeType == DispatchQueue.SchedulerTimeType {

            self.scheduler = AnyScheduler(scheduler)
            self.hapticManager = hapticManager
            self.pasteboard = pasteboard
            self.masterPasswordStorage = masterPasswordStorage
            self.passwordGenerator = passwordGenerator
        }
    }
}

// MARK: Factories

extension PasswordGeneratorView.Environment {

    static func live() -> Self {

        let keychain = MasterPasswordKeychain()
        return PasswordGeneratorView.Environment(
            scheduler: DispatchQueue.main,
            hapticManager: UIKitHapticManager(),
            pasteboard: UIPasteboard.general,
            masterPasswordStorage: keychain,
            passwordGenerator: PasswordGenerator(
                masterPasswordProvider: keychain,
                entropyGenerator: .pbkdf2(iterations: 1_000),
                bytes: 40
            )
        )
    }
}
