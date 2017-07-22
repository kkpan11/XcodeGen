//
//  main.swift
//  SwiftySwagger
//
//  Created by Yonas Kolb on 17/09/2016.
//  Copyright © 2016 Yonas Kolb. All rights reserved.
//

import Foundation
import PathKit
import Commander
import XcodeGenKit
import xcodeproj


func generate(spec: String) {

    let specPath = Path(spec).normalize()
    let projectPath = specPath.parent() + "\(specPath.lastComponentWithoutExtension).xcodeproj"

    var spec: Spec
    do {
        spec = try Spec(path: specPath)
        print("Loaded spec: \(spec.targets.count) targets, \(spec.schemes.count) schemes, \(spec.configs.count) configs")
        let specLintingResults = SpecLinter.lint(spec)
        spec = specLintingResults.spec
        if !specLintingResults.errors.isEmpty {
            print("Spec errors: \n\t- \(specLintingResults.errors.map{$0.description}.joined(separator: "\n\t- "))")
        }
        if !specLintingResults.appliedFixits.isEmpty {
            print("Applied spec fixits:\n\t- \(specLintingResults.appliedFixits.map{$0.description}.joined(separator: "\n\t- "))")
        }
    } catch {
        print("Parsing spec failed: \(error)")
        return
    }

    do {
        let projectGenerator = ProjectGenerator(spec: spec, path: projectPath)
        let project = try projectGenerator.generate()
        print("Generated project")
        try project.write(override: true)
        print("Wrote project to file \(projectPath.string)")
    } catch {
        print("Project Generation failed: \(error)")
    }
}

command(
    Option<String>("spec", "", flag: "p", description: "The path to the spec file"),
    generate)
    .run()
