// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

struct AutoSearchField<Collection: RangeReplaceableCollection & Hashable & Equatable>: View where Collection.Element: Hashable {
    @ObservedObject var viewModel: AutoSearchFieldViewModel<Collection>
    var body: some View {
        VStack(spacing: .zero) {
            TextField(
                viewModel.placeHolder,
                text: Binding (
                    get: {
                        // Converting searched prefix to swiftui's acceptable binding type i.e string
                        guard let searchedPrefix = viewModel.searchedPrefix else { return "" }
                        if let string = searchedPrefix as? String {
                            return string
                        } else if let chars = searchedPrefix as? [Character] {
                            return String(chars)
                        } else {
                            return String(describing: searchedPrefix)
                        }
                    },
                    set: { newSearchEntry in
                        viewModel.updateSearchPrefix(from: newSearchEntry)
                    }
            )).textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: viewModel.searchedPrefix) { _ in
                    viewModel.beginEditing()
            }
            
            if viewModel.isSearching {
                List(viewModel.result, id: \.self) { item in
                    Text(String(describing: item))
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

class AutoSearchFieldViewModel<Collection: RangeReplaceableCollection>: ObservableObject where Collection.Element: Hashable {
    private let searchStore: SearchDataStore<Collection.Element>
    var placeHolder: String
    
    @Published var isSearching = false
    @Published var searchedPrefix: Collection?
    @Published var result: [Collection] = []
    
    init(
        allEntries: [Collection],
        placeHolder: String = ""
    ) {
        self.searchStore = SearchDataStore(allEntries)
        self.placeHolder = placeHolder
    }
    
    func beginEditing() {
        guard let prefix = searchedPrefix,
        !prefix.isEmpty else {
            result = []
            isSearching = false
            return
        }
        result = searchStore.matchingEntries(prefix: prefix)
        isSearching = true
    }
    
    // Converts a searched text into the generic
    func updateSearchPrefix(from string: String) {
        if Collection.self == String.self {
            searchedPrefix = string as? Collection
        } else if Collection.self == [Character].self {
            searchedPrefix = Array(string) as? Collection
        } else {
            searchedPrefix = nil
        }
    }
    
    func clearField() {
        isSearching = false
        searchedPrefix = nil
        result = []
    }
    
}
