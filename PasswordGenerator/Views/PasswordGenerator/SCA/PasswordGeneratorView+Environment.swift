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

        PasswordGeneratorView.Environment(
            scheduler: DispatchQueue.main,
            hapticManager: UIKitHapticManager(),
            pasteboard: UIPasteboard.general,
            masterPasswordStorage: MasterPasswordKeychain(),
            passwordGenerator: PasswordGenerator(
                masterPasswordProvider: MasterPasswordKeychain(),
                iterations: 1_000,
                bytes: 40
            )
        )
    }
}
