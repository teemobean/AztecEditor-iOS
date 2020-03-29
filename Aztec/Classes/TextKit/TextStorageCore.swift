import Foundation
import UIKit

/// Stores attributed strings (to find attributes) and the raw string
/// Supplements TextStorage, and allows customization of the attributed string
/// to provide attributes that are not persisted
///
open class TextStorageCore {

    fileprivate var textStore = NSMutableAttributedString(string: "", attributes: nil)
    fileprivate var textStoreString = ""

    public init() {
        
    }

    // MARK: - Accessors

    open var string: String {
        return textStoreString
    }

    open var length: Int {
        return textStore.length
    }

    // MARK: - Attribute Methods

    open func attribute(_ attrName: NSAttributedString.Key, at location: Int, effectiveRange range: NSRangePointer?) -> Any? {
        return textStore.attribute(attrName, at: location, effectiveRange: range)
    }

    open func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        guard textStore.length > 0 else {
            return [:]
        }
        return textStore.attributes(at: location, effectiveRange: range)
    }

    // MARK: - Editing methods

    private func replaceTextStoreString(_ range: NSRange, with string: String) {
        let utf16String = textStoreString.utf16
        let startIndex = utf16String.index(utf16String.startIndex, offsetBy: range.location)
        let endIndex = utf16String.index(startIndex, offsetBy: range.length)
        textStoreString.replaceSubrange(startIndex..<endIndex, with: string)
    }

    open func replaceCharacters(in range: NSRange, with str: String) {
        textStore.replaceCharacters(in: range, with: str)
        replaceTextStoreString(range, with: str)
    }

    open func replaceCharacters(in range: NSRange, with attrString: NSAttributedString, and preprocessedString: NSAttributedString) {

        textStore.replaceCharacters(in: range, with: preprocessedString)
        replaceTextStoreString(range, with: attrString.string)
    }

    open func setAttributes(_ attrs: [NSAttributedString.Key: Any], range: NSRange) {
        textStore.setAttributes(attrs, range: range)
    }

    // MARK: - Set methods

    open func setString(_ attrString: NSAttributedString) {
        textStore = NSMutableAttributedString(attributedString: attrString)
        textStoreString = textStore.string
    }

    // MARK: - Attachment Methods

    open func enumerateAttachmentsOfType<T : NSTextAttachment>(_ type: T.Type, range: NSRange? = nil, block: ((T, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void)) {
        textStore.enumerateAttachmentsOfType(type, range: range, block: block)
    }

    open func enumerateRenderableAttachments(range: NSRange? = nil, block: ((RenderableAttachment, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void)) {
        let range = range ?? NSMakeRange(0, length)
        textStore.enumerateAttribute(.attachment, in: range, options: []) { (object, range, stop) in
            if let object = object as? RenderableAttachment {
                block(object, range, stop)
            }
        }
    }
}
