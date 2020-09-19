import SwiftUI
import UIKit
import Combine
import PasswordGeneratorKit

struct PasswordGeneratorView: View {

    @ObservedObject var viewModel = ViewModel()
    
    @ScaledMetric private var spacing: CGFloat = 16
    @ScaledMetric private var loaderSize: CGFloat = 44

    var body: some View {

        ScrollView {

            VStack(alignment: .center, spacing: spacing) {

                PasswordGeneratorView.ConfigurationView()

                LengthView()

                CharactersView()

                if  viewModel.passwordState == .invalid ||
                    viewModel.passwordState == .readyToGenerate {

                    MainButton(action: viewModel.generatePassword, text: Strings.PasswordGeneratorView.generatePassword)
                        .disabled(viewModel.passwordState == .invalid)
                } else if viewModel.passwordState == .loading {

                    Loader()
                        .frame(height: loaderSize)
                } else if case let .generated(password) = viewModel.passwordState {

                    CopyableContentView(content: password)
                        .expandedInParent()
                        .asCard()
                }
            }
            .padding(spacing)
        }
        .accentColor(.accent)
        .background(
            Rectangle()
                .foregroundColor(.background01)
                .edgesIgnoringSafeArea(.all)
        )
        .emittingError($viewModel.error)
        .injectEnvironment(into: viewModel)
        .onAppear(perform: viewModel.bind)
        .navigationBarItems(
            trailing: Button(
                action: viewModel.logout,
                label: {

                    Text(Strings.PasswordGeneratorView.resetMasterPassword)
                        .font(.headline)
                }
            )
        )
        .environmentObject(viewModel)
        .navigationBarTitle("", displayMode: .inline)
    }
}
