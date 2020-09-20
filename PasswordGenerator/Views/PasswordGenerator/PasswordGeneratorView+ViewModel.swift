import SwiftUI
import Combine
import PasswordGeneratorKit
import PasswordGeneratorKitPublishers

extension PasswordGeneratorView {

    final class ViewModel: ObservableObject, DependencyInjectable {

        var environment: EnvironmentValues = .init()

        @Published var passwordType: PasswordType = .domainBased
        @Published var username: String = ""
        @Published var domain: String = ""
        @Published var seed: Int = 1
        @Published var service: String = ""
        @Published var length: Int = 8
        @Published var numberOfDigits: Int = 1
        @Published var numberOfSymbols: Int = 0
        @Published var numberOfLowercase: Int = 1
        @Published var numberOfUppercase: Int = 1
        @Published var passwordState: PasswordState = .invalid
        @Published var error: Error?

        var minimalLength: Int {

            max(numberOfDigits + numberOfSymbols + numberOfLowercase + numberOfUppercase, 4)
        }

        private var cancellableStore: Set<AnyCancellable> = []

        func bind() {

            subscribeToLengthUpdates()
            subscribeToValidationUpdates()
        }

        func generatePassword() {

            let publisher: AnyPublisher<String, PasswordGenerator.Error>
            switch passwordType {

            case .domainBased:
                publisher = environment.passwordGenerator.publishers.generatePassword(
                    username: username,
                    domain: domain,
                    seed: seed,
                    rules: rules
                )
            case .serviceBased:
                publisher = environment.passwordGenerator.publishers.generatePassword(
                    service: service,
                    rules: rules
                )
            }

            publisher
                .prefix(untilOutputFrom: isValid.dropFirst())
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveRequest: { [weak self] _ in self?.passwordState = .loading })
                .sink(
                    receiveCompletion: { [weak self] completion in

                        guard case let .failure(error) = completion else { return }
                        self?.error = error
                        self?.passwordState = .readyToGenerate
                    },
                    receiveValue: { [weak self] in self?.passwordState = .generated($0) }
                )
                .store(in: &cancellableStore)
        }

        func logout() {

            do {

                try environment.masterPasswordStorage.deleteMasterPassword()
                environment.appState.state = .mustProvideMasterPassword
            } catch {

                self.error = error
            }
        }
    }
}

// MARK: - Private methods/variables

private extension PasswordGeneratorView.ViewModel {

    private var rules: Set<PasswordRule> {

        var rules = [PasswordRule.length(length)]
        if numberOfDigits > 0 { rules.append(.mustContainDecimalCharacters(atLeast: numberOfDigits)) }
        if numberOfSymbols > 0 { rules.append(.mustContainSymbolCharacters(atLeast: numberOfSymbols)) }
        if numberOfLowercase > 0 { rules.append(.mustContainLowercaseCharacters(atLeast: numberOfLowercase)) }
        if numberOfUppercase > 0 { rules.append(.mustContainUppercaseCharacters(atLeast: numberOfUppercase)) }
        return Set(rules)
    }

    private var isValid: AnyPublisher<Bool, Never> {

        let domainBasedInput = Publishers
            .CombineLatest4(
                $username,
                $domain,
                $seed,
                $passwordType.filter { $0 == .domainBased }
            )
            .map { username, domain, _, _ in

                username.isNotEmpty && domain.hasMatchingTypes(NSTextCheckingResult.CheckingType.link.rawValue)
            }

        let serviceBasedInput = Publishers
            .CombineLatest(
                $service,
                $passwordType.filter { $0 == .serviceBased }
            )
            .map { service, _ in

                service.isNotEmpty
            }

        let charactersInput = Publishers
            .CombineLatest4(
                $numberOfDigits,
                $numberOfSymbols,
                $numberOfLowercase,
                $numberOfUppercase
            )
            .map { $0 + $1 + $2 + $3 > 0 }

        return Publishers
            .CombineLatest3(
                Publishers.Merge(domainBasedInput, serviceBasedInput),
                $length.map { $0 >= 4 },
                charactersInput
            )
            .map { $0 && $1 && $2 }
            .eraseToAnyPublisher()
    }

    private func subscribeToLengthUpdates() {

        let characterChanges = Publishers
            .CombineLatest4(
                $numberOfDigits,
                $numberOfLowercase,
                $numberOfUppercase,
                $numberOfSymbols
            )
            .map { max($0 + $1 + $2 + $3, 4) }

        Publishers
            .CombineLatest(
                characterChanges,
                $length
            )
            .filter { $0 > $1 }
            .map(\.0)
            .assign(to: \.length, onWeak: self)
            .store(in: &cancellableStore)
    }

    private func subscribeToValidationUpdates() {

        isValid
            .map { isValid -> PasswordGeneratorView.PasswordState in

                isValid ? .readyToGenerate : .invalid
            }
            .assign(to: \.passwordState, onWeak: self)
            .store(in: &cancellableStore)
    }
}
