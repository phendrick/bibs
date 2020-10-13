import UIKit

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
