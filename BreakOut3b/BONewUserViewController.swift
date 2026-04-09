import UIKit

@objc protocol BONewUserViewControllerDelegate: AnyObject {
    func boNewUserViewController(
        _ sender: BONewUserViewController,
        gotUserId uid: String,
        gotDifficulty diff: NSNumber,
        score aScore: NSNumber,
        andGotBackgroundColor bkg: NSNumber
    )
}

@objc(BONewUserViewController)
final class BONewUserViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet private weak var userIdTextField: UITextField!
    @IBOutlet private weak var difficultyTextField: UITextField!
    @IBOutlet private weak var backgroundColorTextField: UITextField!

    @objc var theUserId: String?
    @objc var theDifficulty: NSNumber?
    @objc var theBackgroundColor: NSNumber?
    @objc override var isEditing: Bool {
        get { super.isEditing }
        set { super.isEditing = newValue }
    }
    @objc weak var delegate: BONewUserViewControllerDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userIdTextField.becomeFirstResponder()
        userIdTextField.delegate = self
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if isEditing {
            if textField.placeholder == "Enter a digit between 1 and 3." {
                theDifficulty = NSNumber(value: Int(textField.text ?? "") ?? 0)
                backgroundColorTextField.returnKeyType = .done
                backgroundColorTextField.becomeFirstResponder()
                backgroundColorTextField.delegate = self
            } else {
                theBackgroundColor = NSNumber(value: Int(textField.text ?? "") ?? 0)
                isEditing = false

                if (textField.text ?? "").isEmpty {
                    presentingViewController?.dismiss(animated: true)
                } else if let userId = theUserId,
                          let difficulty = theDifficulty,
                          let backgroundColor = theBackgroundColor {
                    delegate?.boNewUserViewController(
                        self,
                        gotUserId: userId,
                        gotDifficulty: difficulty,
                        score: NSNumber(value: 0),
                        andGotBackgroundColor: backgroundColor
                    )
                }
            }
        } else {
            theUserId = textField.text ?? ""
            isEditing = true
            difficultyTextField.returnKeyType = .done
            difficultyTextField.becomeFirstResponder()
            difficultyTextField.delegate = self
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        textField.resignFirstResponder()
        return true
    }
}
