import Foundation
import class PasswordGeneratorKit.PasswordGenerator
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

extension PasswordGeneratorApp.Environment {

    static func live() -> Self {

        PasswordGeneratorApp.Environment(
            scheduler: DispatchQueue.main,
            hapticManager: UIKitHapticManager(),
            pasteboard: UIPasteboard.general,
            masterPasswordStorage: MasterPasswordKeychain(),
            passwordGenerator: PasswordGenerator(
                masterPasswordProvider: MasterPasswordKeychain(),
                entropyGenerator: .pbkdf2(iterations: 1_000),
                bytes: 40
            )
        )
    }
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
            passwordGenerator: passwordGeneratorAppEnvironment.passwordGenerator
        )
    }
}
