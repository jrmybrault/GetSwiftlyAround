// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
public enum Translation {
public enum Car {

    public enum List {
      /// Available cars
      public static let title = Translation.of(key: "list.title", in: "Car")

      public enum RefreshError {
        /// Failed to refresh cars list. Please check your internet connexion.
        public static let message = Translation.of(key: "list.refreshError.message", in: "Car")
        /// Error
        public static let title = Translation.of(key: "list.refreshError.title", in: "Car")
      }
    }

    public enum Pricing {
      /// %@ / day
      public static func format(_ p1: String) -> String {
        return Translation.of(key: "pricing.format", in: "Car", args: p1)
      }
      /// Unknown price
      public static let unknown = Translation.of(key: "pricing.unknown", in: "Car")
    }

    public enum Rating {
      /// %@ (%u reviewers)
      public static func format(_ p1: String, _ p2: Int) -> String {
        return Translation.of(key: "rating.format", in: "Car", args: p1, p2)
      }
      /// No rating yet
      public static let `none` = Translation.of(key: "rating.none", in: "Car")
    }
}
public enum Common {
    /// OK
    public static let confirm = Translation.of(key: "confirm", in: "Common")
}
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension Translation {

    private static var localizedBundle: Bundle = {
        let localizedBundle: Bundle?
        if let path = Bundle.main.path(forResource: Locale.defaultLanguage, ofType: "lproj") {
            localizedBundle = Bundle(path: path)
        } else {
            localizedBundle = nil
        }
        return localizedBundle ?? Bundle.main
    }()

    public static func of(key: String, in table: String, defaultValue: String = "", args: CVarArg...) -> String {
        let format = localizedBundle.localizedString(forKey: key, value: defaultValue, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

extension Locale {

    public static var defaultLanguage: String {
        get {
            return preferredLanguages.first ?? "en_GB"
        }
        set {
           UserDefaults.standard.set([newValue], forKey: "AppleLanguages")
           UserDefaults.standard.synchronize()
        }
    }
}
