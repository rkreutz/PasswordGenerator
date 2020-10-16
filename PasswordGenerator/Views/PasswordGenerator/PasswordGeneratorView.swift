import SwiftUI
import UIKit
import Combine
import PasswordGeneratorKit

struct PasswordGeneratorView: View {

    @ObservedObject var viewModel = ViewModel()
    
    @ScaledMetric private var spacing: CGFloat = 16
    @ScaledMetric private var loaderSize: CGFloat = 44
    @ScaledMetric private var maxWidth: CGFloat = 450

    var body: some View {

        ScrollView {

            VStack(alignment: .center, spacing: spacing) {

                ConfigurationView()

                LengthView()

                CharactersView()

                switch viewModel.passwordState {

                case .invalid, .readyToGenerate:
                    Button(Strings.PasswordGeneratorView.generatePassword, action: viewModel.generatePassword)
                        .buttonStyle(MainButtonStyle())
                        .disabled(viewModel.passwordState == .invalid)

                case .loading:
                    ProgressView()
                        .frame(height: loaderSize)
                        .progressViewStyle(LoaderStyle())

                case let .generated(password):
                    CopyableContentView(content: password)
                        .expandedInParent()
                        .asCard()
                }
            }
            .padding(spacing)
        }
        .frame(maxWidth: maxWidth)
        .accentColor(.accentColor)
        .background(
            Rectangle()
                .foregroundColor(.systemBackground)
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
