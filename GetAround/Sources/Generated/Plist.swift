// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Plist Files

// swiftlint:disable identifier_name line_length type_body_length
public enum Plist {
  private static let _document = PlistDocument(path: "Info.plist")

  public static let backendConfiguration: String = _document["Backend Configuration"]
  public static let cfBundleDevelopmentRegion: String = _document["CFBundleDevelopmentRegion"]
  public static let cfBundleExecutable: String = _document["CFBundleExecutable"]
  public static let cfBundleIdentifier: String = _document["CFBundleIdentifier"]
  public static let cfBundleInfoDictionaryVersion: String = _document["CFBundleInfoDictionaryVersion"]
  public static let cfBundleName: String = _document["CFBundleName"]
  public static let cfBundlePackageType: String = _document["CFBundlePackageType"]
  public static let cfBundleShortVersionString: String = _document["CFBundleShortVersionString"]
  public static let cfBundleVersion: String = _document["CFBundleVersion"]
  public static let lsRequiresIPhoneOS: Bool = _document["LSRequiresIPhoneOS"]
  public static let uiLaunchStoryboardName: String = _document["UILaunchStoryboardName"]
  public static let uiRequiredDeviceCapabilities: [String] = _document["UIRequiredDeviceCapabilities"]
  public static let uiSupportedInterfaceOrientations: [String] = _document["UISupportedInterfaceOrientations"]
  public static let uiSupportedInterfaceOrientationsIpad: [String] = _document["UISupportedInterfaceOrientations~ipad"]
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

private func arrayFromPlist<T>(at path: String) -> [T] {
  let bundle = Bundle(for: BundleToken.self)
  guard let url = bundle.url(forResource: path, withExtension: nil),
    let data = NSArray(contentsOf: url) as? [T] else {
    fatalError("Unable to load PLIST at path: \(path)")
  }
  return data
}

private struct PlistDocument {
  let data: [String: Any]

  init(path: String) {
    let bundle = Bundle(for: BundleToken.self)
    guard let url = bundle.url(forResource: path, withExtension: nil),
      let data = NSDictionary(contentsOf: url) as? [String: Any] else {
        fatalError("Unable to load PLIST at path: \(path)")
    }
    self.data = data
  }

  subscript<T>(key: String) -> T {
    guard let result = data[key] as? T else {
      fatalError("Property '\(key)' is not of type \(T.self)")
    }
    return result
  }
}

private final class BundleToken {}
