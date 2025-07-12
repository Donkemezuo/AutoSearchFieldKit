// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct AutoSearchField<Collection: RangeReplaceableCollection & Hashable & Equatable>: View where Collection.Element: Hashable {
    @ObservedObject var viewModel: AutoSearchFieldViewModel<Collection>
    public init(viewModel: AutoSearchFieldViewModel<Collection>) {
        self.viewModel = viewModel
    }
    public var body: some View {
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

public class AutoSearchFieldViewModel<Collection: RangeReplaceableCollection>: ObservableObject where Collection.Element: Hashable {
    private let searchStore: SearchDataStore<Collection.Element>
    var placeHolder: String
    var isCaseSensitive = false
    
    @Published var isSearching = false
    @Published var searchedPrefix: Collection?
    @Published var result: [Collection] = []
    
    public init(
        allEntries: [Collection],
        placeHolder: String = "",
        isCaseSensitive: Bool = false
    ) {
        self.placeHolder = placeHolder
        self.isCaseSensitive = isCaseSensitive
        let processedEntries = AutoSearchFieldViewModel<Collection>.lowercaseEntryIfNeeded(allEntries: allEntries, isCaseSensitive: isCaseSensitive)
        self.searchStore = SearchDataStore(processedEntries)
    }
    
    private static func lowercaseEntryIfNeeded(allEntries: [Collection], isCaseSensitive: Bool) -> [Collection] {
        if isCaseSensitive {
            return allEntries
        } else {
            // lowercase all entry
            let lowerCasedEntries = allEntries.map { entry in
                if Collection.self == String.self {
                    return (entry as! String).lowercased() as! Collection
                } else if Collection.self == [Character].self {
                    let lowercasedCharacters = (entry as? [Character]).map { Character(String($0).lowercased()) }
                    return lowercasedCharacters as! Collection
                } else {
                    return entry
                }
            }
            return lowerCasedEntries
        }
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
        let searchedText = isCaseSensitive ? string : string.lowercased()
        if Collection.self == String.self {
            searchedPrefix = searchedText as? Collection
        } else if Collection.self == [Character].self {
            searchedPrefix = Array(searchedText) as? Collection
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
