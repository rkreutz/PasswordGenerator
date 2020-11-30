import ComposableArchitecture

// TODO: Open PR for this

extension Reducer {

    init<ActionResult>(
        forAction casePath: CasePath<Action, ActionResult>,
        handler: @escaping (inout State, ActionResult, Environment) -> Effect<Action, Never>
    ) {

        self.init { state, action, environment -> Effect<Action, Never> in

            guard let actionResult = casePath.extract(from: action) else { return .none }
            return handler(&state, actionResult, environment)
        }
    }

    init(
        forAction casePath: CasePath<Action, Void>,
        handler: @escaping (inout State, Environment) -> Effect<Action, Never>
    ) {

        self.init { state, action, environment -> Effect<Action, Never> in

            guard casePath.extract(from: action) != nil else { return .none }
            return handler(&state, environment)
        }
    }

    init<ActionResult>(
        forActions casePaths: CasePath<Action, ActionResult>...,
        handler: @escaping (inout State, ActionResult, Environment) -> Effect<Action, Never>
    ) {

        self.init { state, action, environment -> Effect<Action, Never> in

            for casePath in casePaths {

                guard let actionResult = casePath.extract(from: action) else { continue }
                return handler(&state, actionResult, environment)
            }

            return .none
        }
    }

    init(
        forActions casePaths: CasePath<Action, Void>...,
        handler: @escaping (inout State, Environment) -> Effect<Action, Never>
    ) {

        self.init { state, action, environment -> Effect<Action, Never> in

            for casePath in casePaths {

                guard casePath.extract(from: action) != nil else { continue }
                return handler(&state, environment)
            }

            return .none
        }
    }

    init<ActionResult>(
        bindingAction casePath: CasePath<Action, ActionResult>,
        to keyPath: WritableKeyPath<State, ActionResult>,
        producing effect: @escaping (ActionResult) -> Effect<Action, Never> = { _ in .none }
    ) {

        self.init(forAction: casePath) { state, actionResult, _ -> Effect<Action, Never> in

            state[keyPath: keyPath] = actionResult
            return effect(actionResult)
        }
    }

    init<ActionResult>(
        bindingActions casePaths: CasePath<Action, ActionResult>,
        to keyPath: WritableKeyPath<State, ActionResult>,
        producing effect: @escaping (ActionResult) -> Effect<Action, Never> = { _ in .none }
    ) {

        self.init(forActions: casePaths) { state, actionResult, _ -> Effect<Action, Never> in

            state[keyPath: keyPath] = actionResult
            return effect(actionResult)
        }
    }
}
