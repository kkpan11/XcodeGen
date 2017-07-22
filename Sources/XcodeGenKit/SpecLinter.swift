//
//  SpecLinter.swift
//  XcodeGen
//
//  Created by Yonas Kolb on 22/7/17.
//
//

import Foundation

public struct SpecLinter {

    public static func lint(_ spec: Spec) -> (spec: Spec, appliedFixits: [SpecLinterFixit], errors: [SpecLinterError]) {
        var spec = spec
        var errors: [SpecLinterError] = []
        var fixits: [SpecLinterFixit] = []

        if spec.configs.isEmpty {
            spec.configs = [Config(name: "debug", type: .debug), Config(name: "release", type: .release)]
            fixits.append(.createdConfigs)
        }

        return (spec, fixits, errors)
    }
}

public enum SpecLinterError: CustomStringConvertible {
    case invalidDependancy(String)

    public var description: String {
        switch self {
        case let .invalidDependancy(dependancy): return "Invalid dependancy \(dependancy)"
        }
    }
}

public enum SpecLinterFixit: CustomStringConvertible {
    case createdConfigs

    public var description: String {
        switch self {
        case .createdConfigs: return "Created default debug and release configs"
        }
    }
}
