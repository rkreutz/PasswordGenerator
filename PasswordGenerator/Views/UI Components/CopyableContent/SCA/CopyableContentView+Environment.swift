import Foundation
import protocol Combine.Scheduler
import struct ComposableArchitecture.AnyScheduler
import struct ComposableArchitecture.AnySchedulerOf
import class UIKit.UIPasteboard

extension CopyableContentView {

    struct Environment {

        let scheduler: AnySchedulerOf<DispatchQueue>
        let hapticManager: HapticManager
        let pasteboard: Pasteboard

        init<Scheduler: Combine.Scheduler>(
            scheduler: Scheduler,
            hapticManager: HapticManager,
            pasteboard: Pasteboard
        ) where
            Scheduler.SchedulerOptions == DispatchQueue.SchedulerOptions,
            Scheduler.SchedulerTimeType == DispatchQueue.SchedulerTimeType {

            self.scheduler = AnyScheduler(scheduler)
            self.hapticManager = hapticManager
            self.pasteboard = pasteboard
        }
    }
}

// MARK: Factories

extension CopyableContentView.Environment {

    static func live() -> Self {

        CopyableContentView.Environment(
            scheduler: DispatchQueue.main,
            hapticManager: UIKitHapticManager(),
            pasteboard: UIPasteboard.general
        )
    }
}
