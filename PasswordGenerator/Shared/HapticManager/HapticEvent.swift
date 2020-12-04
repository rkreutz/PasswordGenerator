import Foundation

enum HapticEvent {

    enum ImpactStyle {

        case light
        case medium
        case heavy
        case soft
        case rigid
    }

    case selection
    case impact(style: ImpactStyle, intensity: Float? = nil)
    case success
    case error
    case warning
}
