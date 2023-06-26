//
//  FileManger-DocumentsDirectory.swift
//  HotProspects
//
//  Created by Anthony Bath on 6/26/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
