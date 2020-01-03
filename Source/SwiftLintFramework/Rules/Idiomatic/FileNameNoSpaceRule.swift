import Foundation
import SourceKittenFramework

public struct FileNameNoSpaceRule: ConfigurationProviderRule, OptInRule {
    public var configuration = FileNameNoSpaceConfiguration(
        severity: .warning,
        excluded: []
    )

    public init() {}

    public static let description = RuleDescription(
        identifier: "file_name_no_space",
        name: "File Name No Space",
        description: "File name should not contain any whitespace.",
        kind: .idiomatic
    )

    public func validate(file: SwiftLintFile) -> [StyleViolation] {
        guard let filePath = file.path,
            case let fileName = filePath.bridge().lastPathComponent,
            !configuration.excluded.contains(fileName) else {
            return []
        }

        let typeInFileName = fileName.bridge().deletingPathExtension

        if typeInFileName.rangeOfCharacter(from: .whitespaces) == nil {
            return []
        }

        return [StyleViolation(ruleDescription: type(of: self).description,
                               severity: configuration.severity.severity,
                               location: Location(file: filePath, line: 1))]
    }
}
