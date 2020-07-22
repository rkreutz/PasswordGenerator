import SwiftUI
import Combine
import PasswordGeneratorKit
import PasswordGeneratorKitPublishers

extension PasswordGeneratorView {

    final class ViewModel: ObservableObject {

        @Environment(\.passwordGenerator) private var generator
        @Environment(\.masterPasswordStorage) private var masterPasswordStorage

        @Published var passwordType: PasswordType = .domainBased
        @Published var username: String = ""
        @Published var domain: String = ""
        @Published var seed: Int = 1
        @Published var service: String = ""
        @Published var length: Int = 8
        @Published var shouldIncludeDigits: Bool = true
        @Published var numberOfDigits: Int = 1
        @Published var shouldIncludeSymbols: Bool = false
        @Published var numberOfSymbols: Int = 1
        @Published var shouldIncludeLowercase: Bool = true
        @Published var numberOfLowercase: Int = 1
        @Published var shouldIncludeUppercase: Bool = true
        @Published var numberOfUppercase: Int = 1
        @Published var minimalLength: Int = 4
        @Published var passwordState: PasswordState = .invalid
        @Published var error: Error?

        private var cancellableStore: Set<AnyCancellable> = []

        func bind() {

            subscribeToCharacterUpdates()
            subscribeToLengthUpdates()
            subscribeToValidationUpdates()
        }

        func generatePassword() {

            let publisher: AnyPublisher<String, PasswordGenerator.Error>
            switch passwordType {

            case .domainBased:
                publisher = generator.publishers.generatePassword(username: username, domain: domain, seed: seed, rules: rules)
            case .serviceBased:
                publisher = generator.publishers.generatePassword(service: service, rules: rules)
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

        func logout(_ appState: AppState) {

            do {

                try masterPasswordStorage.deleteMasterPassword()
                appState.state = .mustProvideMasterPassword
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
        if shouldIncludeDigits { rules.append(.mustContainDecimalCharacters(atLeast: numberOfDigits)) }
        if shouldIncludeSymbols { rules.append(.mustContainSymbolCharacters(atLeast: numberOfSymbols)) }
        if shouldIncludeLowercase { rules.append(.mustContainLowercaseCharacters(atLeast: numberOfLowercase)) }
        if shouldIncludeUppercase { rules.append(.mustContainUppercaseCharacters(atLeast: numberOfUppercase)) }
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

        return Publishers
            .CombineLatest3(
                Publishers.Merge(domainBasedInput, serviceBasedInput),
                $length.map { $0 > 4 },
                Publishers
                    .CombineLatest4(
                        $numberOfDigits,
                        $numberOfSymbols,
                        $numberOfLowercase,
                        $numberOfUppercase
                    )
                    .map { $0 + $1 + $2 + $3 > 0 }
                    .eraseToAnyPublisher()
            )
            .map { $0 && $1 && $2 }
            .eraseToAnyPublisher()
    }

    private func subscribeToCharacterUpdates() {

        $shouldIncludeLowercase
            .removeDuplicates()
            .map { $0 ? 1 : 0 }
            .assign(to: \.numberOfLowercase, on: self)
            .store(in: &cancellableStore)

        $shouldIncludeUppercase
            .removeDuplicates()
            .map { $0 ? 1 : 0 }
            .assign(to: \.numberOfUppercase, on: self)
            .store(in: &cancellableStore)

        $shouldIncludeDigits
            .removeDuplicates()
            .map { $0 ? 1 : 0 }
            .assign(to: \.numberOfDigits, on: self)
            .store(in: &cancellableStore)

        $shouldIncludeSymbols
            .removeDuplicates()
            .map { $0 ? 1 : 0 }
            .assign(to: \.numberOfSymbols, on: self)
            .store(in: &cancellableStore)
    }

    private func subscribeToLengthUpdates() {

        Publishers
            .CombineLatest4(
                $numberOfDigits,
                $numberOfLowercase,
                $numberOfUppercase,
                $numberOfSymbols
            )
            .map { max($0 + $1 + $2 + $3, 4) }
            .assign(to: \.minimalLength, on: self)
            .store(in: &cancellableStore)

        Publishers
            .CombineLatest(
                $minimalLength,
                $length
            )
            .filter { $0 > $1 }
            .map(\.0)
            .assign(to: \.length, on: self)
            .store(in: &cancellableStore)
    }

    private func subscribeToValidationUpdates() {

        isValid
            .map { isValid -> PasswordGeneratorView.PasswordState in

                isValid ? .readyToGenerate : .invalid
            }
            .assign(to: \.passwordState, on: self)
            .store(in: &cancellableStore)
    }
}
