//
//  FileManager-DocumentsDirectory.swift
//  DiceRollr
//
//  Created by Anthony Bath on 7/3/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
