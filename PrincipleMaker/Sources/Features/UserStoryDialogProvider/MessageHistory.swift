//
//  MessageHistory.swift
//  PrincipleMaker
//
//  Created by choijunios on 11/12/25.
//

actor MessageHistory {
    private enum Config {
        static let maxTokenCount: Int = 2000
    }
    
    private(set) var messages: [String] = []
    
    func append(_ message: String) {
        
        messages.append(message)
        
        while totalTokenCount() > Config.maxTokenCount {
            messages.removeFirst()
        }
    }
    
    func clear() {
        messages.removeAll()
    }
    
    func totalTokenCount() -> Int {
        messages.reduce(0) { $0 + tokenCount(for: $1) }
    }
    
    private func tokenCount(for message: String) -> Int {
        var englishLikeCharacterCount = 0
        var cjkCharacterCount = 0
        
        for scalar in message.unicodeScalars {
            if isCJKScalar(scalar) {
                cjkCharacterCount += 1
            } else {
                englishLikeCharacterCount += 1
            }
        }
        
        let englishTokens = (englishLikeCharacterCount + 2) / 3 // round up every 3 chars
        return englishTokens + cjkCharacterCount
    }
    
    private func isCJKScalar(_ scalar: Unicode.Scalar) -> Bool {
        switch scalar.value {
        case 0x4E00...0x9FFF, // CJK Unified Ideographs
             0x3400...0x4DBF, // CJK Unified Ideographs Extension A
             0xF900...0xFAFF, // CJK Compatibility Ideographs
             0x3040...0x309F, // Hiragana
             0x30A0...0x30FF, // Katakana
             0x31F0...0x31FF, // Katakana Phonetic Extensions
             0xAC00...0xD7AF, // Hangul Syllables
             0x1100...0x11FF, // Hangul Jamo
             0x3130...0x318F: // Hangul Compatibility Jamo
            return true
        default:
            return false
        }
    }
}
