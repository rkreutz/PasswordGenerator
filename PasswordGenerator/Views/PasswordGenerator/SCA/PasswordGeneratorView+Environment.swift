import Foundation
import protocol PasswordGeneratorKit.MasterPasswordProvider
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
        let masterPasswordProvider: MasterPasswordProvider

        init<Scheduler: Combine.Scheduler>(
            scheduler: Scheduler,
            hapticManager: HapticManager,
            pasteboard: Pasteboard,
            masterPasswordStorage: MasterPasswordStorage,
            masterPasswordProvider: MasterPasswordProvider
        ) where
            Scheduler.SchedulerOptions == DispatchQueue.SchedulerOptions,
            Scheduler.SchedulerTimeType == DispatchQueue.SchedulerTimeType {

            self.scheduler = AnyScheduler(scheduler)
            self.hapticManager = hapticManager
            self.pasteboard = pasteboard
            self.masterPasswordStorage = masterPasswordStorage
            self.masterPasswordProvider = masterPasswordProvider
        }
    }
}

// MARK: Factories

extension PasswordGeneratorView.Environment {

    static func preview() -> Self {

        let keychain = MasterPasswordKeychain()
        return PasswordGeneratorView.Environment(
            scheduler: DispatchQueue.main,
            hapticManager: UIKitHapticManager(),
            pasteboard: UIPasteboard.general,
            masterPasswordStorage: keychain,
            masterPasswordProvider: keychain
        )
    }
}
