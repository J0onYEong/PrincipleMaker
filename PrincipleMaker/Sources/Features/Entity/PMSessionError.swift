//
//  PMSessionError.swift
//  PrincipleMaker
//
//  Created by choijunios on 10/4/25.
//

enum PMSessionError: Error {
    case sessionIsNotExist
    case sessionIsResponding
    case underlyingError(Error)
}
