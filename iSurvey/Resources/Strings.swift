// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Already Submitted
  internal static let alreadySubmitted = L10n.tr("Localizable", "already_submitted")
  /// Your answer submitted successfully
  internal static let answerSubmitted = L10n.tr("Localizable", "answer_submitted")
  /// Exit
  internal static let exit = L10n.tr("Localizable", "exit")
  /// Failed to fetch survey from the server. Please try again
  internal static let fetchSurveyError = L10n.tr("Localizable", "fetch_survey_error")
  /// Next  
  internal static let next = L10n.tr("Localizable", "next")
  /// Previous
  internal static let previous = L10n.tr("Localizable", "previous")
  /// Question
  internal static let question = L10n.tr("Localizable", "question")
  /// Retry Submit
  internal static let retrySubmit = L10n.tr("Localizable", "retry_submit")
  /// Start Survey
  internal static let startSurvey = L10n.tr("Localizable", "start_survey")
  /// Submit
  internal static let submit = L10n.tr("Localizable", "submit")
  /// Failed to submit answer to the server. Please try again
  internal static let submitAnswerError = L10n.tr("Localizable", "submit_answer_error")
  /// Thank you!
  internal static let thankYou = L10n.tr("Localizable", "thank_you")
  /// Total Submitted
  internal static let totalSubmitted = L10n.tr("Localizable", "total_submitted")
  /// Welcome
  internal static let welcome = L10n.tr("Localizable", "welcome")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle = Bundle(for: BundleToken.self)
}
// swiftlint:enable convenience_type
