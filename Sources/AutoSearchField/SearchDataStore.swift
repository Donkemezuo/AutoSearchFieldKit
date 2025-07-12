//
//  SearchDataStore.swift
//  AutoSearchField
//
//  Created by Raymond Donkemezuo on 7/12/25.
//
import Foundation

private final class Node<T: Hashable> {
    var value: T?
    var children: [T: Node<T>] = [:]
    var parent: Node<T>?
    var isEndOfEntry = false
    
    init(
        value: T?,
        parent: Node<T>?
    ) {
        self.value = value
        self.parent = parent
    }
}

final class SearchDataStore<T: Hashable> {
    private var rootNode = Node<T>(value: nil, parent: nil)
    
    public init<Collection: RangeReplaceableCollection>( _ entries: [Collection]) where Collection.Element == T {
        self.addEntries(entries)
    }
    
    private func addEntries<Collection: RangeReplaceableCollection>( _ entries: [Collection]) where Collection.Element == T {
        
        for entry in entries {
            insertEntry(entry)
        }
    }
    
    private func insertEntry<Collection: RangeReplaceableCollection>(_ entry: Collection) where Collection.Element == T {
        var currentNode = rootNode
        
        for value in entry {
            // Check if the current node does not exist, add it as a child node
            if currentNode.children[value] == nil {
                let newNode = Node<T>(value: value, parent: currentNode)
                currentNode.children[value] = newNode
            }
            
            // Move to the next node by setting the child of the current value
            currentNode = currentNode.children[value]!
        }
        
        // Mark last node as the end of a word
        currentNode.isEndOfEntry = true
    }
    
    func matchingEntries<Collection: RangeReplaceableCollection>(prefix entry: Collection) -> [Collection] where Collection.Element == T {
        var currentNode = rootNode
        
        for value in entry {
            // Check if the entry exist in the store else return empty list
            guard let nextNode = currentNode.children[value] else {
                return []
            }
            currentNode = nextNode
        }
        
        var result = [Collection]()
        
        findMatchingEntries(node: currentNode, prefix: entry, result: &result)
        return result
    }
    
    private func findMatchingEntries<Collection: RangeReplaceableCollection>(
        node: Node<T>,
        prefix entry: Collection,
        result: inout [Collection]
    ) where Collection.Element == T {
        if node.isEndOfEntry {
            result.append(entry)
        }
        for (value, child) in node.children {
            let newPrefix = entry + [value]
            findMatchingEntries(node: child, prefix: newPrefix, result: &result)
        }
    }
}

